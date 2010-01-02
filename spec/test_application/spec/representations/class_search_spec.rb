require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations::ClassSearch do
  it "should find representation for user-defined class" do
    class Test1; end
    class Test1Representation < Representations::Base; end
    Representations::ClassSearch.new.class_for(Test1.new).should == Test1Representation
  end
  
  it "should create representation for user-defined class" do
    class Test2; end
    Object.send(:remove_const, "Test2Representation") if self.class.const_defined?("Test2Representation")
    representation_class = Representations::ClassSearch.new.class_for(Test2.new)
    representation_class.to_s.should == "Test2Representation"
    representation_class.superclass.should == Representations::Default
  end
  
  it "should create representation for ActiveRecord based class" do
    Object.send(:remove_const, "UserRepresentation") if self.class.const_defined?("UserRepresentation")
    representation_class = Representations::ClassSearch.new.class_for(User.new)
    representation_class.to_s.should == "UserRepresentation"
    representation_class.superclass.should == Representations::ActiveRecord
  end
end