require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# show use of unmodulize_modules, automatically calling unmodulize for all module methods

class ClassShowUnmodMods
  def foo
    "ClassShowUnmodMods#foo"
  end

  def bar
    "ClassShowUnmodMods#bar"
  end
end

module MShowUnmodMods
  def foo
    "MShowUnmodMods#foo/"+super
  end

  def bar
    "MShowUnmodMods#bar/"+super
  end
end

class ClassShowUnmodMods
  modulize_include MShowUnmodMods
end

class ClassShowUnmodMods
  unmodulize_modules MShowUnmodMods
end


describe "unmodulize_modules, automatically calling unmodulize for all module methods" do
  before(:each) { @obj = ClassShowUnmodMods.new }

  it "should modulize all methods defined in Module and include them" do
    @obj.foo.should == "ClassShowUnmodMods#foo"
    @obj.bar.should == "ClassShowUnmodMods#bar"
  end
end


# show use of unmodulize_modules without reopening class

class ClassShowUnmodMods2
  def foo
    "ClassShowUnmodMods2#foo"
  end

  def bar
    "ClassShowUnmodMods2#bar"
  end
end

module MShowUnmodMods1
  def foo
    "MShowUnmodMods1#foo/"+super
  end

  def bar
    "MShowUnmodMods1#bar/"+super
  end
end


module MShowUnmodMods2
  def foo
    "MShowUnmodMods2#foo/"+super
  end

  def bar
    "MShowUnmodMods2#bar/"+super
  end
end

class ClassShowUnmodMods2
  modulize_include MShowUnmodMods1, MShowUnmodMods2
end

class ClassShowUnmodMods2
  unmodulize_modules MShowUnmodMods1, MShowUnmodMods2
end


describe "unmodulize_modules without reopening class" do
  before(:each) { @obj = ClassShowUnmodMods2.new }

  it "should modulize all methods defined in Module and include them" do
    @obj.foo.should == "ClassShowUnmodMods2#foo"
    @obj.bar.should == "ClassShowUnmodMods2#bar"
  end
end


# Show use of unmodulize called as a class method (without manually reopening)

class ClassShowUnmodMods3
  def foo
    "ClassShowUnmodMods3#foo"
  end

  def bar
    "ClassShowUnmodMods3#bar"
  end
end

module MShowUnmodMods31
  def foo
    "MShowUnmodMods31#foo/"+super
  end

  def bar
    "MShowUnmodMods31#bar/"+super
  end
end


module MShowUnmodMods32
  def foo
    "MShowUnmodMods32#foo/"+super
  end

  def bar
    "MShowUnmodMods32#bar/"+super
  end
end

ClassShowUnmodMods3.modulize_include MShowUnmodMods31, MShowUnmodMods32
ClassShowUnmodMods3.unmodulize_modules MShowUnmodMods31, MShowUnmodMods32


describe "unmodulize called as a class method (without manually reopening)" do
  before(:each) { @obj = ClassShowUnmodMods3.new }

  it "should modulize all methods defined in Module and include them" do
    @obj.foo.should == "ClassShowUnmodMods3#foo"
    @obj.bar.should == "ClassShowUnmodMods3#bar"
  end
end


# Show that additional calls to unmodulize do not cause any problem

class ClassShowUnmodMods4
  def foo
    "ClassShowUnmodMods4#foo"
  end

  def bar
    "ClassShowUnmodMods4#bar"
  end
end

module MShowUnmodMods41
  def foo
    "MShowUnmodMods41#foo/"+super
  end

  def bar
    "MShowUnmodMods41#bar/"+super
  end
end


module MShowUnmodMods42
  def foo
    "MShowUnmodMods42#foo/"+super
  end

  def bar
    "MShowUnmodMods42#bar/"+super
  end
end

ClassShowUnmodMods4.modulize_include MShowUnmodMods41, MShowUnmodMods42
ClassShowUnmodMods4.unmodulize_modules MShowUnmodMods41, MShowUnmodMods42
ClassShowUnmodMods4.unmodulize_modules MShowUnmodMods41, MShowUnmodMods42


describe "additional calls to unmodulize do not cause any problem" do
  before(:each) { @obj = ClassShowUnmodMods4.new }

  it "should modulize all methods defined in Module and include them" do
    @obj.foo.should == "ClassShowUnmodMods4#foo"
    @obj.bar.should == "ClassShowUnmodMods4#bar"
  end
end
