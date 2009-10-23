require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'representations'

describe Representations::Representation do

  it ".to_s should return escaped string" do
    user = stub_model(User, {:nick => "some string"})
    user = Representations::representation_for(user, nil )
    user.nick.to_s.should == ERB::Util::html_escape(user.nick)
  end
  it "should be extendible via defining new module with the same name in the environment" do
    module ActiveRecordRepresentation
      def test_method
        'I can be called'
      end
    end
    user = stub_model(User)
    user = Representations::representation_for(user, nil )
    user.test_method.should == 'I can be called'
  end
end
