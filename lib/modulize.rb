# Modulize makes it easy to override a method without manually alias chaining.
# It effectively moves the original method into a module to make it easy to call
# the parent method using super.
#
# If a method does not exist, is defined in a parent, defined in a module already,
# or if modulize has already been called, then invoking it again is safe and simple no-op.
#
# This provides an easy safe way to override methods than alias_method chaining. It eliminats the possibility of
# alias clashes and clutter from multiple uses. Extensions are as easy as creating a module
# modulizing and including.
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
  #
  # @example Modulize an instance method
  #   class C
  #     modulize :foo
  #     include M      # module containing methods to override C with
  #   end
  #
  # @example Modulize multiple instance methods
  #   class C
  #     modulize :foo, :bar, :baz
  #     include M      # module containing methods to override C instance methods with
  #   end
  #
  # @example Modulize a class method(s)
  #   class CC
  #      class << self                 # switch into metaclass
  #        modulize :foo, :bar, :baz   # indicate which method(s) to modulize
  #        include MCC                 # module containing method(s) to override CC class methods with
  #      end
  #    end
  #
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
  #   class C
  #     modulize_include MyModule
  #   end
  #
  # @example modulize instance methods for several modules and include the modules
  #   class C
  #     modulize_include MyModule1, MyModule2, MyModule3
  #   end
  #
  # @example shortcut for modulizing and including without manually re-opening class
  #   C.modulize_include MyMod1, MyMod2, MyMod3
  #
  # @example modulize class method(s) contained in module and include the module
  #   class CC
  #      class << self            # switch into metaclass
  #        modulize_include MCC   # override CC's class methods contained in MCC
  #      end
  #    end
  #
  def modulize_include(*mod_consts)
    mod_consts.each do |mod_const|
      modulize *(mod_const.instance_methods)
      include mod_const
    end
  end

  # unmodulize a method that has been modulized, reverts to the original state (but does not un-include modules, only disconnects their use in the methods)
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
  #
  # @example Unmodulize an instance method
  #   class C
  #     unmodulize :foo
  #   end
  #
  # @example Unmodulize multiple instance methods
  #   class C
  #     unmodulize :foo, :bar, :baz
  #   end
  #
  # @example Shortcut to unmodulize multiple instance methods without manually re-opening class
  #   C.unmodulize :foo, :bar, :baz
  #
  # @example Unmodulize class method(s)
  #   class CC
  #      class << self                     # switch into metaclass
  #        unmodulize :foo, :bar, :baz     # indicate which method(s) to return to revert
  #      end
  #    end
  #
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

  # unmodulize instance methods in module(s) that were modulized in (but does not un-include modules, only disconnects their use in the methods)
  #
  # @param [Constant] mod_consts module name constant(s), will unmodulize all instance methods in the module(s), one or more
  #
  # @example unmodulize instance methods for module
  #   class C
  #     unmodulize_modules MyModule
  #   end
  #
  # @example unmodulize instance methods for several modules
  #   class C
  #     unmodulize_modules MyModule1, MyModule2, MyModule3
  #   end
  #
  # @example shortcut for unmodulizing and without manually re-opening class
  #   MyClass.unmodulize_modules MyMod1, MyMod2, MyMod3
  #
  # @example unmodulize class method(s) contained in module
  #   class CC
  #      class << self               # switch into metaclass
  #        unmodulize_modules MCC    # revert class methods contained MCC
  #      end
  #    end
  #
  def unmodulize_modules(*mod_consts)
    mod_consts.each { |mod_const| unmodulize *(mod_const.instance_methods) }
  end

end
