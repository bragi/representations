require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'resource_representations'

describe ResourceRepresentations::DefaultRepresentation do

  it " should generate proper html label" do
    user = stub_model(User, {:nick => "some string"})
    user = ResourceRepresentations::representation_for(user, nil )
    ActionView::Helpers::FormTagHelper::form_tag 
    user.nick.to_s.should == ERB::Util::html_escape(user.nick)
  end


end

