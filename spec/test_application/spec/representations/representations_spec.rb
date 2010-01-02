require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations do

  it "should create activeRecordRepresentation for AR objects" do
    user = stub_model(User)
    user = Representations::representation_for(user, nil, "user")
    user.should be_a_kind_of(Representations::ActiveRecord)
  end
  it "should create defaultRepresentation for non AR, non Nil and non ActiveSupport::TimeWithZone objects" do
    user = stub_model(User, { :nick => "some nick"})
    user = Representations::representation_for(user, nil, "user")
    user.nick.should be_a_kind_of(Representations::Default)
  end
  it "should create TimeWithZoneRepresenation for ActiveSupport::TimeWithZone" do
    user = stub_model(User, { :created_at => Time.zone.now})
    user = Representations::representation_for(user, nil, "user")
    user.created_at.should be_a_kind_of(Representations::TimeWithZone)
  end
  it "should create proper chain of Representations" do
    profile = stub_model(Profile, {:name => "some name"})
    user = stub_model(User, {:login => nil, :profile => profile})
    user = Representations::representation_for(user, nil, "user")

    user.should be_a_kind_of(Representations::ActiveRecord)

    user.profile.should be_a_kind_of(Representations::ActiveRecord)

    user.profile.name.should be_a_kind_of(Representations::DefaultRepresentation)
  end


end

