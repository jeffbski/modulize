# Modulize

Safe, easy method extension

## Improvement on manual aliasing

 - in aliasing, you have to worry about others using same name for old alias (not unique)
 - http://whynotwiki.com/Ruby_/_Method_aliasing_and_chaining - discusses alias chaining and a facet or ActiveSuppport method called alias_method_chain, however still can cause infinite loop and need to know what method to call if you want to delegate up the chain.
 - must check if alias already exists before doing, no guarantee that everyone will use unique feature names
 - Ara Howard suggests this solution to be a nicer alias_method_chain allowing super, but I find it hard to understand and and more code
 - Jay Fields mentions a technique to get reference to unbound method, then call it from in a define_method, so that you do not leave any artifacts around like the old method. This involves re-opening the class and defining methods in the class which call to the unbound method. You do not have ability to call old method directly by design. http://blog.jayfields.com/2006/12/ruby-alias-method-alternative.html
 - Another blog discussing the unbind technique http://split-s.blogspot.com/2006/01/replacing-methods.html
 - Daniel Cadenas implementation of the unbind method with undo - http://www.danielcadenas.com/2007/11/bit-of-metaprogramming.html
 - an unbound method retains affinity to the original class so we cannot simply use it in another module directly
 - http://yehudakatz.com/2010/02/15/abstractqueryfactoryfactories-and-alias_method_chain-the-ruby-way/
 - Rails 3 prefers to use modules with super to alias_method chains http://yehudakatz.com/2009/11/12/better-ruby-idioms/ http://yehudakatz.com/2009/03/06/alias_method_chain-in-models/
 - Reference to Yehuda Katz Refactoring Rails where they purposely use methods to be able to simply include modules and call super. This involves advanced planning and using modules rather than instance methods originally. http://www.wedesoft.demon.co.uk/no-alias-method-chain.html (This is probably the closest thing explaining)
 - Subclassing will work, but sometimes you need to modify the existing class since all of the methods return the same class, like String, Pathname
 - would like to simply use a module with the desired functionality, eliminating all the brittle aliasing and pre-thought about using modules because often the code you want to change is not your own


## TODO

 - Will this work like extend and only on certain instances?
 - Make class methods work too

## Note on Patches/Pull Requests

 - Fork the project.
 - Make your feature addition or bug fix.
 - Add tests/specs for it. This is important so I don't break it in a future version unintentionally.
 - Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
 - Send me a pull request. Bonus points for topic branches.



## Copyright

Copyright (c) 2010 Jeff Barczewski. See LICENSE for details.


