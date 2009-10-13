require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'resource_representations'

describe ResourceRepresentations do

  it "should create activeRecordRepresentation for AR objects" do
    user = stub_model(User)
    user = ResourceRepresentations::representation_for(user, nil)
    user.should be_a_kind_of(ResourceRepresentations::ActiveRecordRepresentation)
  end
  it "should create nilClassRepresentation for nil objects" do
    user = stub_model(User, {:profile => nil})
    user = ResourceRepresentations::representation_for(user, nil)
    user.profile.should be_a_kind_of(ResourceRepresentations::NilClassRepresentation)
  end
  it "should create defaultRepresentation for non AR, non Nil and non ActiveSupport::TimeWithZone objects" do
    user = stub_model(User, { :nick => "some nick"})
    user = ResourceRepresentations::representation_for(user, nil)
    user.nick.should be_a_kind_of(ResourceRepresentations::DefaultRepresentation)
  end
  it "should create TimeWithZoneRepresenation for ActiveSupport::TimeWithZone" do
    user = stub_model(User, { :created_at => Time.zone.now})
    user = ResourceRepresentations::representation_for(user, nil)
    user.created_at.should be_a_kind_of(ResourceRepresentations::TimeWithZoneRepresentation)
  end
  it "should create proper chain of Representations" do
    profile = stub_model(Profile, {:name => "some name", :surname => nil})
    user = stub_model(User, {:login => nil, :profile => profile})
    user = ResourceRepresentations::representation_for(user, nil)

    user.should be_a_kind_of(ResourceRepresentations::ActiveRecordRepresentation)

    user.profile.should be_a_kind_of(ResourceRepresentations::ActiveRecordRepresentation)

    user.profile.name.should be_a_kind_of(ResourceRepresentations::DefaultRepresentation)

    user.profile.surname.should be_a_kind_of(ResourceRepresentations::NilClassRepresentation)
  end


end

