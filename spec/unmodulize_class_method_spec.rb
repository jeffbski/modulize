require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# unmodulize a class method using unmodulize

class CUnModClassMethod1
  def self.foo
    "CUnModClassMethod1#foo"
  end
end

module MUnModClassMethod1
  def foo
    "MUnModClassMethod1#foo/"+super
  end
end

class CUnModClassMethod1
  class << self
    modulize :foo
    include MUnModClassMethod1
  end
end

class CUnModClassMethod1
  class << self
    unmodulize :foo
  end
end

describe "unmodulize a class method using include" do
  subject { CUnModClassMethod1.foo }
  it "will call only CUnModClassMethod1#foo" do
    should == "CUnModClassMethod1#foo"
  end
end



# unmodulize a class method using unmodulize_modules

class CUnModClassMethod2
  def self.foo
    "CUnModClassMethod2#foo"
  end
end

module MUnModClassMethod2
  def foo
    "MUnModClassMethod2#foo/"+super
  end
end

class CUnModClassMethod2
  class << self
    modulize :foo
    include MUnModClassMethod2
  end
end

class CUnModClassMethod2
  class << self
    unmodulize_modules MUnModClassMethod2
  end
end

describe "unmodulize a class method using extend" do
  subject { CUnModClassMethod2.foo }
  it "will call both MUnModClassMethod2#foo and CUnModClassMethod2#foo" do
    should == "CUnModClassMethod2#foo"
  end
end

