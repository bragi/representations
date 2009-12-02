require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations::Representation do

  it ".to_s should return escaped string when wrapped object is not nil" do
    user = stub_model(User, {:nick => "some string"})
    user = Representations::representation_for(user, nil, "user" )
    user.nick.to_s.should == ERB::Util::html_escape(user.nick)
  end
  it ".to_s should return empty string if wrapped object is nil" do
    user = Representations::representation_for(nil, nil, "user" )
    user.to_s.should == ERB::Util::html_escape(user.nick)
  end
  it "should be extendible via defining new module with the same name in the app/representations/*_representation.rb" do

    user = stub_model(User)
    user = Representations::representation_for(user, nil, "user" )
    user.should satisfy { user.respond_to?(:test_met) }
  end
end
