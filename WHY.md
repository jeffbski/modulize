# Why create modulize?

An example to help explain why modulize might be useful.


## Extending a class for which you do not maintain the source code

Given a project that makes heavy use of Pathname there might be aspects of the API that need slight changes for best productivity.

For instance, if we wanted to extend Pathname.find() so that it accepts a filter. The implementation currently only accepts a block, so one would have to chain multiple methods together to get a fnmatch added to find.

     Pathname.find.select {|pn| Pathname.fnmatch?("*.rb", pn)}

One way of doing this is to add a new method Pathname.find_filtered, but now the API is expanding and it can become confusing to know when to use one vs other and which one takes args, etc. The standard method for finding an object in many classes is find, so ideally this would be the intuitive if we were to simply overload the find and handle the case where filter is passed in.

Another approach would be to subclass Pathname to add overload the method, however since many of Pathname's methods also return Pathname now we would have to wrap all of those methods so that they returned our subclass of Pathname.

So the next idea is just reopening Pathname and using alias_method.

     class Pathname
       alias_method :find_old, :find

       def find(filter, &block)
         if filter.nil?
           find_old(&block)
         else # we have the filter so use it
           list = find_old.select { |pn| Pathname.fnmatch?("*.rb", pn) }
           if block_given?
             list.each {|pn| yield pn}
           end
           list
         end
       end
     end



So this works just fine. We did have to alias the method and then remember to use this method anytime we want to refer to original implementation but it does the job. However what happens when the next person want so now support multiple filters?

As long as they choose a different alias name, then everything is fine, they can extend things the same way building on what we started. But since this code can be mixed in from other places, it is hard to insure that everyone will choose a unique alias and not trample on each other's code. Or it might be unique now, but then later when the other person changes his alias to make it clearer, it could end up coliding names in the future.

Yehuda Katz discussed this problem in the upgrade to Rails 3. Since classes in Rails 3 are often extended by plugins this becomes a large problem. Yehuda mentioned that by moving Rails 3 methods into modules then it is easy to extend by simply including your module and calling super. No aliasing needed, no chance for name collisions.

However if you don't own the source code then these kinds of changes aren't very probable. Enter modulize. Create a module with the methods you won't to overload/override and include with modulize. Modulize checks to see if method is implemented directly in the class and not a module and if so it does one single alias_method, detaches the original method name, creates an anonymous module containing the method calling back to original. Then modules can simple by included to extend, no additional alias_method calls are needed regardless of how many times they are overridden. It is safe to call modulize again and again.

     module PathnameFindWithFilter
       def find(filter, &block)
         if filter.nil?
           super(&block)
         else
           list = super().select { |pn| Pathname.fnmatch?("*.rb", pn) }
           if block_given?
             list.each {|pn| yield pn}
           end
           list
         end
       end
     end

     Pathname.modulize_include PathnameFindWithFilter




     module PathnameFindMultipleFilters
       def find(*filters, &block)
         if filters.nil? || filters.empty?
           super(&block)
         else
           # implement multiple filtes here
         end
       end
     end

     Pathname.modulize_include PathnameFindMultipleFilters # this call did not have to alias








