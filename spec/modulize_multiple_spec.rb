require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Cat
  def sleep
    "Cat#sleep"
  end

  def eat
    "Cat#eat"
  end
end

module Hunting
  def sleep
    "Hunting#sleep/"+super
  end

  def eat
    "Hunting#eat/"+super
  end
end

class Cat
  modulize :sleep, :eat
  include Hunting
end

class Dog
  def speak(what)
    "Dog#speak(#{what})"
  end

  def find
    "Dog#find/"+yield
  end
end

module M3
  def speak(what)
    "M3#speak(#{what})/"+super
  end

  def find
    "M3#find/"+yield+"/"+super
  end
end

class Dog
  modulize :speak, :find
  include M3
end

describe Cat do
  before(:each) { @cat = Cat.new }

  it "should modulize multiple methods in one call" do
    @cat.sleep.should == "Hunting#sleep/Cat#sleep"
    @cat.eat.should == "Hunting#eat/Cat#eat"
  end
end


# show that methods can use blocks too
describe Dog do
  describe "speak" do
    subject { Dog.new.speak("bowwow") }
    it { should == "M3#speak(bowwow)/Dog#speak(bowwow)" }
  end

  describe "find" do
    subject do
      Dog.new.find do
        "bone"
      end
    end

    it { should == "M3#find/bone/Dog#find/bone" }
  end
end
