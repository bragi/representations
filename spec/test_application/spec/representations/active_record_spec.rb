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

  describe :link do
    before do
      user = stub_model(User, :id => 1)
      @user = Representations::representation_for(user, nil, "user" )
    end

    it "link with passed title should create link to show page" do
      @user.link("title").should == '<a href="/users/1">title</a>'
    end

    it "link with passed title and :view => :edit should creat link to edit page" do
      @user.link("title", :view => :edit).should == '<a href="/users/1/edit">title</a>'
    end

    it "link without passed title should return proper html a tag with wrapped object's class name and id as a title" do
      @user.link().should == '<a href="/users/1">User 1</a>'
    end
  end
end
