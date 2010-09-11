require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Simple example of use

class ClassWithModulize
  def foo
    "ClassWithModulize#foo"
  end
end

module M1
  def foo
    "M1#foo/"+super
  end
end

class ClassWithModulize
  modulize :foo
  include M1
end

describe ClassWithModulize do
  subject { ClassWithModulize.new.foo }

  it "will call both M#foo and ClassWithModulize#foo" do
    should == "M1#foo/ClassWithModulize#foo"
  end
end


# Demonstrate that it does not break anything when called on a subclass it is just a no-op

class Parent
  def bar
    "Parent#bar"
  end
end


class SubclassedClassWithMod < Parent
end

module M2
  def bar
    "M2#bar/"+super
  end
end

class SubclassedClassWithMod
  modulize :bar
  include M2
end

describe SubclassedClassWithMod do
  subject { SubclassedClassWithMod.new.bar }

  it { should == "M2#bar/Parent#bar" }
end


# Demonstrate that it is safe to call multiple times, only the first call needs to do anything

class ClassCallingMultipleTimes
  def great_method
    "It's great!"
  end
end

module ModMultiCall
  def great_method
    "It's awesome! "+super
  end
end

class ClassCallingMultipleTimes # someone does this
  modulize :great_method
  include ModMultiCall
end


# Now another person calls it again to extend

module ModMultiCall2
  def great_method
    "It's wonderful!! "+super
  end
end

class ClassCallingMultipleTimes # This time it doesn't have to do anything, already a module, so no-op
  modulize :great_method
  include ModMultiCall2
end

describe "modulize being called multiple times will work correctly, no-op on successive calls" do
  subject { ClassCallingMultipleTimes.new.great_method }
  it { should == "It's wonderful!! It's awesome! It's great!" }
end
