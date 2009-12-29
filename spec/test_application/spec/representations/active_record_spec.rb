require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations::ActiveRecordRepresentation do
  it "when a method with the same name as associated object is called with a block it should create html tags for representations passed inside a block" do
    profile = stub_model(Profile, {:name => "some name"})
    user = stub_model(User, {:profile => profile})
    user = Representations::representation_for(user, nil, 'user')
    user.profile.name.text_field.should == %Q{<input type="text" id="user_profile_name" name="user[profile_attributes][name]" value="some name"/>}
  end

  it "when a method with the same name as associated object is called with a block and this object is nil it should do nothing" do
    user = stub_model(User, {:profile => nil})
    user = Representations::representation_for(user, nil, 'user')
    (user.profile{|p| p.name.text_field}).should == nil
  end

  describe :link do
    before do
      @user_model = stub_model(User, :id => 1)
      @template = stub("Template", :link_to => nil, :polymorphic_path => "/default_path")
      @user = Representations::representation_for(@user_model, @template, "user" )
    end

    it "uses provided link title" do
      @template.should_receive(:link_to).with("title", "/default_path", {})
      @user.link("title")
    end

    it "should honor provided action" do
      @template.should_receive(:polymorphic_path).with([@user_model], {:anchor => nil, :action => :edit}).and_return("/")
      @user.link("title", :action => :edit)
    end

    it "should have default link title" do
      @template.should_receive(:link_to).with("User", "/default_path", {})
      @user.link
    end

    it "should use HTML options" do
      @template.should_receive(:link_to).with("test", "/default_path", {:class => "AA", :style => "BB"})
      @user.link("test", :class => "AA", :style => "BB")
    end
    
    it "should honor used namespace" do
      @template.should_receive(:polymorphic_path).with([:good, :bad, :ugly, @user_model], {:anchor => nil, :action => nil}).and_return("/")
      @user.namespace("good/bad/ugly").link
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
