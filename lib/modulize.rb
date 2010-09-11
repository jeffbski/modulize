# Modulize makes it easy to override a method without manually alias chaining and
# it moves the original method into a module to make it easy to call the parent method using super.
#
# If a method does not exist, is defined in a parent, defined in a module already,
# or if modulize has already been called, then calling it again is safe and results in
# a no-op.
#
# This makes it safe to use when you do not control the original classes in case they
# are refactored by the owner. Regardless of how they change, as long as there is still
# a method there by some means your code will still work
#
class Module
  # if method is defined in the class/module (not inherited from module or class) then
  # alias method(s), remove, include module with method which calls alias only
  # this allows including modules to simply override, no need for manual alias chaining, just use super
  #
  # Internally the first time this is called for a method if it is directly created in that class,
  # it aliases method to #{methname}_before_modulize, then removes original, and creates
  # module which calls original.
  #
  # @param [Symbol] symbol(s) for method to modulize, one or more
  # @example Modulize a method
  #   modulize :foo
  # @example Modulize multiple methods
  #   modulize :foo, :bar, :baz
  def modulize(*method_syms)
    method_syms.each do |method_sym|
      if instance_methods(false).include?(method_sym) # if not an inherited method continue, otherwise not needed
        methname = method_sym.to_s
        class_eval <<-EOM
          alias_method :#{methname}_before_modulize, :#{methname}
          remove_method :#{methname}
          include(Module.new { def #{methname}(*args, &b); #{methname}_before_modulize(*args, &b); end })
        EOM
      end
    end
  end

  # Rather than defining all the methods that need to be modulized, another way of doing this
  # is to modulize all the instance methods in a module, so you pass the module constant name instead
  # and it will also include the module
  #
  # @param [Constant] mod_consts module name constant(s), will modulize all instance methods in the module, one or more
  #
  # @example modulize instance methods for module and include module
  #   modulize_include MyModule
  #
  # @example modulize instance methods for several modules and include the modules
  #   modulize_include MyModule1, MyModule2, MyModule3
  #
  # @example shortcut for modulizing and including without re-opening class
  #   MyClass.modulize_include MyMod1, MyMod2, MyMod3
  #
  def modulize_include(*mod_consts)
    mod_consts.each do |mod_const|
      modulize *(mod_const.instance_methods)
      include mod_const
    end
  end

  # unmodulize a method that has been modulized, reverts to the original state.
  #
  # Care should be taken in using this since if others have also modulized after
  # resulting in simply additional modules to be included, the result of this
  # unmodulize will reinstate the original method to the class, so all module methods
  # extensions will not be called.
  #
  # You only need to invoke this once, subsequent calls will just no-op
  #
  # Internally this simply reverts the alias. It does not try to clean up the
  # anonymous module that was introduced but it will not be called
  #
  # @param [Symbol] symbol(s) for method to unmodulize, one or more
  # @example Unmodulize a method
  #   unmodulize :foo
  # @example Unmodulize multiple methods
  #   unmodulize :foo, :bar, :baz
  def unmodulize(*method_syms)
    method_syms.each do |method_sym|
      methname = method_sym.to_s
      orig_methname_sym = "#{methname}_before_modulize".to_sym
      if instance_methods(false).include?(orig_methname_sym) # if it was modulized
        class_eval <<-EOM
          alias_method method_sym, orig_methname_sym
          remove_method orig_methname_sym
        EOM
      end
    end
  end

  # unmodulize methods in module(s) that were modulized in
  #
  # @param [Constant] mod_consts module name constant(s), will unmodulize all instance methods in the module, one or more
  #
  # @example unmodulize instance methods for module
  #   unmodulize_modules MyModule
  #
  # @example unmodulize instance methods for several modules
  #   unmodulize_modules MyModule1, MyModule2, MyModule3
  #
  # @example shortcut for unmodulizing and without re-opening class
  #   MyClass.unmodulize_modules MyMod1, MyMod2, MyMod3
  #
  def unmodulize_modules(*mod_consts)
    mod_consts.each { |mod_const| unmodulize *(mod_const.instance_methods) }
  end

end
