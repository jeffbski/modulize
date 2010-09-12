require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# show use of modulize_include inside of a class, automatically modulizing methods

class ClassModulizeInclude
  def foo
    "ClassModulizeInclude#foo"
  end

  def bar
    "ClassModulizeInclude#bar"
  end
end

module MModuleInclude1
  def foo
    "MModuleInclude1#foo/"+super
  end

  def bar
    "MModuleInclude1#bar/"+super
  end
end

class ClassModulizeInclude
  modulize_include MModuleInclude1
end

describe "modulize_include inside of a class, automatically modulizing methods" do
  before(:each) { @obj = ClassModulizeInclude.new }

  it "should modulize all methods defined in Module and include them" do
    @obj.foo.should == "MModuleInclude1#foo/ClassModulizeInclude#foo"
    @obj.bar.should == "MModuleInclude1#bar/ClassModulizeInclude#bar"
  end
end



# show use of modulize_include without reopening class

class CModIncludeSimple
  def foo
    "CModIncludeSimple#foo"
  end
end

module MModIncludeSimple1
  def foo
    "MModIncludeSimple1#foo/"+super
  end
end

CModIncludeSimple.modulize_include MModIncludeSimple1

describe "modulize_include without reopening class" do
  subject { CModIncludeSimple.new.foo }

  it { should == "MModIncludeSimple1#foo/CModIncludeSimple#foo" }
end
