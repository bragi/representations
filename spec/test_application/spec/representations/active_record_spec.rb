require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations::ActiveRecordRepresentation do
  it "when a method with the same name as associated object is called with a block it should create html tags for representations passed inside a block" do
    profile = stub_model(Profile, {:name => "some name"})
    user = stub_model(User, {:profile => profile})
    user = Representations::representation_for(user, nil, 'user')
    user.profile.name.text_field.should == %Q{<input type="text" id="user_profile_name" name="user[profile_attributes][name]" value="some name" />}
  end
  it "when a method with the same name as associated object is called with a block and this object is nil it should do nothing" do
    user = stub_model(User, {:profile => nil})
    user = Representations::representation_for(user, nil, 'user')
    (user.profile{|p| p.name.text_field}).should == nil
  end
end
