require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# show how things work without modulize

class ClassNoModulize
  def foo
    "ClassNoModulize#foo"
  end
end

module MNoModulize
  def foo
    "MNoModulize#foo/"+super
  end
end

class ClassNoModulize
  include MNoModulize
end

describe ClassNoModulize do
  subject { ClassNoModulize.new.foo }

  it "will stop at ClassNoModulize#foo not calling MNoModulize#foo" do
    should == "ClassNoModulize#foo"
  end
end



# show that if sublcassed then module works without modulize

class CParentNoMod
  def foo
    "CParentNoMod#foo"
  end
end

class CSubclassedNoMod < CParentNoMod
end

module M2
  def foo
    "M2#foo/"+super
  end
end

class CSubclassedNoMod
  include M2
end

describe CSubclassedNoMod do
  subject { CSubclassedNoMod.new.foo }

  it { should == "M2#foo/CParentNoMod#foo" } # should still work since method was from parent
end

