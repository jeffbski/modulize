require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# show use of multiple methods in one call

class CMulti1
  def foo
    "CMulti1#foo"
  end

  def bar
    "CMulti1#bar"
  end
end

module MMulti1
  def foo
    "MMulti1#foo/"+super
  end

  def bar
    "MMulti1#bar/"+super
  end
end

class CMulti1
  modulize :foo, :bar
  include MMulti1
end

describe CMulti1 do
  before(:each) { @obj = CMulti1.new }

  it "should modulize multiple methods in one call" do
    @obj.foo.should == "MMulti1#foo/CMulti1#foo"
    @obj.bar.should == "MMulti1#bar/CMulti1#bar"
  end
end



# Show multiple methods and can use args and blocks

class CMultiWArgBlock
  def foo(arg1)
    "CMultiWArgBlock#foo(#{arg1})"
  end

  def bar
    "CMultiWArgBlock#bar/"+yield
  end
end

module MMultiWArgBlock
  def foo(arg1)
    "MMultiWArgBlock#foo(#{arg1})/"+super
  end

  def bar
    "MMultiWArgBlock#bar/"+yield+"/"+super
  end
end

class CMultiWArgBlock
  modulize :foo, :bar
  include MMultiWArgBlock
end


# show that methods can use blocks too
describe CMultiWArgBlock do
  describe "foo" do
    subject { CMultiWArgBlock.new.foo("myArg1") }
    it { should == "MMultiWArgBlock#foo(myArg1)/CMultiWArgBlock#foo(myArg1)" }
  end

  describe "bar" do
    subject do
      CMultiWArgBlock.new.bar do
        "fromBlock"
      end
    end

    it { should == "MMultiWArgBlock#bar/fromBlock/CMultiWArgBlock#bar/fromBlock" }
  end
end
