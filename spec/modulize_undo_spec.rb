require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Showing how unmodulize can undo and restore to the original call stack

class ClassShowingUndo
  def foo
    "ClassShowingUndo#foo"
  end
end

module ModEnhancingShowUndo
  def foo
    "ModEnhancingShowUndo#foo/"+super
  end
end

class ClassShowingUndo
  modulize :foo
  include ModEnhancingShowUndo
end

class ClassShowingUndo
  unmodulize :foo
end

describe ClassShowingUndo do
  subject { ClassShowingUndo.new.foo }

  it "will call only ClassShowingUndo#foo" do
    should == "ClassShowingUndo#foo"
  end
end


