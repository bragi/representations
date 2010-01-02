require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations::ActiveRecord do
  
  describe "when chaining ActiveRecord objects" do
    it "should use ActiveRecord representation for existing object" do
      user = User.new(:profile => Profile.new)
      representation = Representations::ActiveRecord.new(user, nil, 'user')
      representation.profile.should be_a(ProfileRepresentation)
      representation.profile.should be_a(Representations::ActiveRecord)
    end

    it "should use ActiveRecord representation for missing object when it's a relation" do
      user = User.new
      representation = Representations::ActiveRecord.new(user, nil, 'user')
      representation.profile.should be_a(ProfileRepresentation)
      representation.profile.should be_a(Representations::ActiveRecord)
    end
    
    it "should use ActiveRecord representation for chained missing objects" do
      user = User.new
      representation = Representations::ActiveRecord.new(user, nil, 'user')
      representation.profile.should be_a(ProfileRepresentation)
      representation.profile.user.should be_a(UserRepresentation)
      representation.profile.user.should be_a(Representations::ActiveRecord)
    end
  end
  
  # it "when a method with the same name as associated object is called with a block it should create html tags for representations passed inside a block" do
  #   profile = stub_model(Profile, {:name => "some name"})
  #   user = stub_model(User, {:profile => profile})
  #   user = Representations::ActiveRecordRepresentation.new(user, nil, 'user')
  #   user.profile.name.text_field.should == %Q{<input type="text" id="user_profile_name" name="user[profile_attributes][name]" value="some name"/>}
  # end
  # 
  # it "when a method with the same name as associated object is called with a block and this object is nil it should do nothing" do
  #   user = stub_model(User, {:profile => nil})
  #   user = Representations::ActiveRecordRepresentation.new(user, nil, 'user')
  #   (user.profile{|p| p.name.text_field}).should == nil
  # end
  # 
  # describe :link do
  #   before do
  #     @user_model = stub_model(User, :id => 1)
  #     @template = stub("Template", :link_to => nil, :polymorphic_path => "/default_path")
  #     @user = Representations::ActiveRecordRepresentation.new(@user_model, @template, "user" )
  #   end
  # 
  #   it "uses provided link title" do
  #     @template.should_receive(:link_to).with("title", "/default_path", {})
  #     @user.link("title")
  #   end
  # 
  #   it "should honor provided action" do
  #     @template.should_receive(:polymorphic_path).with([@user_model], {:anchor => nil, :action => :edit}).and_return("/")
  #     @user.link("title", :action => :edit)
  #   end
  # 
  #   it "should have default link title" do
  #     @template.should_receive(:link_to).with("User", "/default_path", {})
  #     @user.link
  #   end
  # 
  #   it "should use HTML options" do
  #     @template.should_receive(:link_to).with("test", "/default_path", {:class => "AA", :style => "BB"})
  #     @user.link("test", :class => "AA", :style => "BB")
  #   end
  #   
  #   it "should honor used namespace" do
  #     @template.should_receive(:polymorphic_path).with([:good, :bad, :ugly, @user_model], {:anchor => nil, :action => nil}).and_return("/")
  #     @user.namespace("good/bad/ugly").link
  #   end
  # end
  # 
  # describe :to_s do
  #   before do
  #     @user = mock_model(User)
  #   end
  # 
  #   it "should rander partial when wrapped object does have 'has_one' association with other parent model" do
  #     profile = mock_model(Profile)
  #     @user = Representations::ActiveRecordRepresentation.new(@user, nil, 'user')
  #     profile = Representations::ActiveRecordRepresentation.new(profile, nil, 'profile', @user)
  #     profile.should_receive(:partial)
  #     profile.to_s
  #   end
  # 
  #   it "should not render partial when the wrapped object does not have 'has_one' association with other model" do
  #     task = mock_model(Task, :user => @user)
  #     @user = Representations::ActiveRecordRepresentation.new(@user, nil, 'user')
  #     task = Representations::ActiveRecordRepresentation.new(task, nil, 'tasks', @user)
  #     task.should_not_receive(:partial)
  #     task.to_s
  #   end
  # end
end
