require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'representations'

describe Representations::DefaultRepresentation do

  it '::text_field should create html text input tag with rails naming convention' do
    profile = stub_model(Profile, {:name => "some name"})
    user = stub_model(User, {:profile => profile})
    user = Representations::representation_for(user, nil, 'user')
    user.profile.name.text_field.should == %Q{<input type="text" name="user[profile][name]" value="some name" id="name"/>}
  end
  it '::label should create html label tag with rails naming convention' do
    profile = stub_model(Profile, {:name => "some name"})
    user = stub_model(User, {:profile => profile})
    user = Representations::representation_for(user, nil, 'user')
    user.profile.name.label.should == %Q{<label for="name">#{ERB::Util::h("Name")}</label>}
  end
end

