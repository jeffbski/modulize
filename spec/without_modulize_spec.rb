require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class ClassNoModulize
  def foo
    "ClassNoModulize#foo"
  end
end

module M
  def foo
    "M#foo/"+super
  end
end

class ClassNoModulize
  include M
end

describe ClassNoModulize do
  subject { ClassNoModulize.new.foo }

  it "will stop at ClassNoModulize#foo not calling M#foo" do
    should == "ClassNoModulize#foo"
  end
end



class ParentNoMod
  def bar
    "ParentNoMod#bar"
  end
end

class SubclassedClassNoMod < ParentNoMod
end

module M2
  def bar
    "M2#bar/"+super
  end
end

class SubclassedClassNoMod
  include M2
end

describe SubclassedClassNoMod do
  subject { SubclassedClassNoMod.new.bar }

  it { should == "M2#bar/ParentNoMod#bar" }
end

