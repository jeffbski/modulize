require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Showing how unmodulize can undo and restore to the original call stack

class ClassShowingUndo1
  def foo
    "ClassShowingUndo1#foo"
  end
end

module MShowingUndo1
  def foo
    "MShowingUndo1#foo/"+super
  end
end

class ClassShowingUndo1
  modulize :foo
  include MShowingUndo1
end

class ClassShowingUndo1
  unmodulize :foo
end

describe ClassShowingUndo1 do
  subject { ClassShowingUndo1.new.foo }

  it "will call only ClassShowingUndo1#foo" do
    should == "ClassShowingUndo1#foo"
  end
end


# Show how calling unmodulize multiple times does not hurt anything

class ClassShowingUndo2
  def foo
    "ClassShowingUndo2#foo"
  end
end

module MShowingUndo2
  def foo
    "MShowingUndo2#foo/"+super
  end
end

class ClassShowingUndo2
  modulize :foo
  include MShowingUndo2
end

class ClassShowingUndo2
  unmodulize :foo
end

class ClassShowingUndo2
  unmodulize :foo
end

describe ClassShowingUndo2 do
  subject { ClassShowingUndo2.new.foo }

  it "will call only ClassShowingUndo2#foo" do
    should == "ClassShowingUndo2#foo"
  end
end


# Show how it is only necessary to call once to undo all modulize calls

class ClassShowingUndo3
  def foo
    "ClassShowingUndo3#foo"
  end
end

module MShowingUndo31
  def foo
    "MShowingUndo31#foo/"+super
  end
end

module MShowingUndo32
  def foo
    "MShowingUndo32#foo/"+super
  end
end

class ClassShowingUndo3
  modulize :foo
  include MShowingUndo31
end

class ClassShowingUndo3
  modulize :foo
  include MShowingUndo32
end

class ClassShowingUndo3
  unmodulize :foo
end

describe ClassShowingUndo3 do
  subject { ClassShowingUndo3.new.foo }

  it "will call only ClassShowingUndo3#foo" do
    should == "ClassShowingUndo3#foo"
  end
end
