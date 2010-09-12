require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# modulize a class method using include

class CClassMethod1
  def self.foo
    "CClassMethod1#foo"
  end
end

module MClassMethod1
  def foo
    "MClassMethod1#foo/"+super
  end
end

class CClassMethod1
  class << self
    modulize :foo
    include MClassMethod1
  end
end

describe "modulize a class method using include" do
  subject { CClassMethod1.foo }
  it "will call both MClassMethod1#foo and CClassMethod1#foo" do
    should == "MClassMethod1#foo/CClassMethod1#foo"
  end
end



# modulize a class method using extend

class CClassMethod2
  def self.foo
    "CClassMethod2#foo"
  end
end

module MClassMethod2
  def foo
    "MClassMethod2#foo/"+super
  end
end

class CClassMethod2
  class << self
    modulize :foo
  end
end
CClassMethod2.extend MClassMethod2

describe "modulize a class method using extend" do
  subject { CClassMethod2.foo }
  it "will call both MClassMethod2#foo and CClassMethod2#foo" do
    should == "MClassMethod2#foo/CClassMethod2#foo"
  end
end


# modulize a class method using modulize_include

class CClassMethod3
  def self.foo
    "CClassMethod3#foo"
  end
end

module MClassMethod3
  def foo
    "MClassMethod3#foo/"+super
  end
end

class CClassMethod3
  class << self
    modulize_include MClassMethod3
  end
end

describe "modulize a class method using modulize_include" do
  subject { CClassMethod3.foo }
  it "will call both MClassMethod3#foo and CClassMethod3#foo" do
    should == "MClassMethod3#foo/CClassMethod3#foo"
  end
end

