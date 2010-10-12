require File.expand_path('../spec_helper', __FILE__)

describe Quickedit::Adapter do
  def new_adapter(parent = Quickedit::Adapter, &blk)
    a = Class.new(parent)
    a.class_eval(&blk) if blk
    a
  end

  it "should store the adapters in .adapters" do
    adapter = new_adapter
    Quickedit::Adapter.adapters.must_include(adapter)
  end

  it "should store the rules in .rules" do
    adapter = new_adapter do
      + is_a(Object)
      + respond_to(:hello)
      + rule(:example, "Hello World")

      - is_a(Class)
      - respond_to(:world)
      - rule(:example, "Hello You")
    end

    rules = [
      { :type => :is_a, :values => [Object], :positive => true },
      { :type => :respond_to, :values => [:hello], :positive => true },
      { :type => :example, :values => ["Hello World"], :positive => true },
      
      { :type => :is_a, :values => [Class], :positive => false },
      { :type => :respond_to, :values => [:world], :positive => false },
      { :type => :example, :values => ["Hello You"], :positive => false },
    ]
    
    adapter.rules.each_with_index do |rule, index|
      rules[index].each do |k, v|
        rule.send(k).must_equal(v)
      end
    end
  end
  
  it "should overwrite a previous definition of a rule" do
    adapter = new_adapter do
      + is_a(Object)
      - is_a(Object)
    end
    
    adapter.rules.length.must_equal(1)
    adapter.rules.first.positive.must_equal(false)
  end
  
  it "should make the rules inheritable" do
    parent = new_adapter do
      + is_a(Object)
    end
    
    child = new_adapter(parent) do
      + respond_to(:find)
    end
    
    parent.rules.length.must_equal(1)
    child.rules.length.must_equal(2)
  end
  
  describe ".find" do
    it "should find the most suitable adapter for an object" do
      everything = new_adapter
      string     = new_adapter { + is_a(String) }
      
      Quickedit::Adapter.find(Object.new).must_be_instance_of(everything)
      Quickedit::Adapter.find("Hello").must_be_instance_of(string)
    end
    
    it "should raise error if there's no suitable adapters" do
      Quickedit::Adapter.adapters.clear
      string = new_adapter { + is_a(String) }
      
      Quickedit::Adapter.find("Hello").must_be_instance_of(string)
      proc { Quickedit::Adapter.find(Object.new) }.must_raise(Quickedit::Error)
    end
  end
end
