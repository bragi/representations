#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'representations'

describe Representations::NilClassRepresentation do

  it "::to_s should return an empty string " do
    user = stub_model(User, {:login => nil, :profile => nil})
    user = Representations::representation_for(user, nil)
    user.profile.to_s.should be_empty
  end
  it "::with_block should return Nil" do
    user = stub_model(User, {:login => nil, :profile => nil})
    user = Representations::representation_for(user, nil)
    user.profile.with_block.should be_nil
  end
  it "::method_missing should return self" do
    user = stub_model(User, {:login => nil, :profile => nil})
    user = Representations::representation_for(user, nil)
    user.profile.unknown_method.should equal(user.profile)
  end

end
