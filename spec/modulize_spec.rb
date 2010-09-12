require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Simple example of use

class ClassWithModulize
  def foo
    "ClassWithModulize#foo"
  end
end

module MWithModulize1
  def foo
    "MWithModulize1#foo/"+super
  end
end

class ClassWithModulize
  modulize :foo
  include MWithModulize1
end

describe "basic use of modulize" do
  subject { ClassWithModulize.new.foo }

  it "will call both M#foo and ClassWithModulize#foo" do
    should == "MWithModulize1#foo/ClassWithModulize#foo"
  end
end


# Demonstrate that it does not break anything when called on a subclass it is just a no-op

class ParentForSubclass
  def bar
    "ParentForSubclass#bar"
  end
end


class SubclassedClassWithMod < ParentForSubclass
end

module MSubclass1
  def bar
    "MSubclass1#bar/"+super
  end
end

class SubclassedClassWithMod
  modulize :bar
  include MSubclass1
end

describe "does not break anything when called on a subclass" do
  subject { SubclassedClassWithMod.new.bar }

  it { should == "MSubclass1#bar/ParentForSubclass#bar" }
end


# Demonstrate that it is safe to call multiple times, only the first call needs to do anything

class ClassCallingMultipleTimes
  def foo
    "ClassCallingMultipleTimes#foo"
  end
end

module MCallingMultipleTimes
  def foo
    "MCallingMultipleTimes#foo/"+super
  end
end

class ClassCallingMultipleTimes # someone does this
  modulize :foo
  include MCallingMultipleTimes
end


# Now another person calls it again to extend

module MCallingMultipleTimes2
  def foo
    "MCallingMultipleTimes2#foo/"+super
  end
end

class ClassCallingMultipleTimes # This time it doesn't have to do anything, already a module, so no-op
  modulize :foo
  include MCallingMultipleTimes2
end

describe "modulize being called multiple times will work correctly, no-op on successive calls" do
  subject { ClassCallingMultipleTimes.new.foo }
  it { should == "MCallingMultipleTimes2#foo/MCallingMultipleTimes#foo/ClassCallingMultipleTimes#foo" }
end
