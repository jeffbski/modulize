require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# show use of modulize_include inside of a class, automatically modulizing methods

class Bird
  def fly
    "Bird#fly"
  end

  def walk
    "Bird#walk"
  end
end

module M4
  def fly
    "M4#fly/"+super
  end

  def walk
    "M4#walk/"+super
  end
end

class Bird
  modulize_include M4
end

describe Bird do
  before(:each) { @bird = Bird.new }

  it "should modulize all methods defined in Module and include them" do
    @bird.fly.should == "M4#fly/Bird#fly"
    @bird.walk.should == "M4#walk/Bird#walk"
  end
end



# show use of modulize_include without reopening class

class BigFish
  def foo
    "BigFish"
  end
end

module MFish
  def foo
    "MFish"+super
  end
end

BigFish.modulize_include MFish

describe BigFish do
  subject { BigFish.new.foo }

  it { should == "MFishBigFish" }
end
