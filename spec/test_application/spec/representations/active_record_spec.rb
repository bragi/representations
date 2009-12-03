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

    it "with passed title should create link to show page" do
      @user.link("title").should == '<a href="/users/1">title</a>'
    end

    it "with passed title and :view => :edit should creat link to edit page" do
      @user.link("title", :view => :edit).should == '<a href="/users/1/edit">title</a>'
    end

    it "without passed title should return proper html a tag with wrapped object's class name and id as a title" do
      @user.link().should == '<a href="/users/1">User 1</a>'
    end

    it "should pass pairs from hash (other then key == :view) into html options" do
      @user.link("test", :view => 'edit', :class => "AA", :style => "BB").should == '<a href="/users/1/edit" class="AA" style="BB">test</a>'
    end
  end

  describe :to_s do
    before do
      @user = mock_model(User)
    end

    it "should rander partial when wrapped object does have 'has_one' association with other parent model" do
      profile = mock_model(Profile)
      @user = Representations::representation_for(@user, nil, 'user')
      profile = Representations::representation_for(profile, nil, 'profile', @user)
      profile.should_receive(:partial)
      profile.to_s
    end

    it "should not render partial when the wrapped object does not have 'has_one' association with other model" do
      task = mock_model(Task, :user => @user)
      @user = Representations::representation_for(@user, nil, 'user')
      task = Representations::representation_for(task, nil, 'tasks', @user)
      task.should_not_receive(:partial)
      task.to_s
    end
  end
end
