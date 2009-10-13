require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'resource_representations'

describe ResourceRepresentations::Representation do

  it ".to_s should return escaped string" do
    user = stub_model(User, {:nick => "some string"})
    user = ResourceRepresentations::representation_for(user, nil )
    user.nick.to_s.should == ERB::Util::html_escape(user.nick)
  end


end

