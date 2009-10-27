require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'representations'

describe Representations::AssociationsRepresentation do

    before(:each) do
        user = User.new
        @user = Representations::representation_for(user, nil )
    end
    describe 'NewRecordRepresentation' do
        it "should create Representations::TimeWithZoneRepresentation for date datatype field nested in the newly added ActiveRecord::Base to the collection" do
            @user.tasks.build{ |new_i| new_i.due_to }.should be_kind_of(Representations::TimeWithZoneRepresentation)
        end
        it "should create Representations::DefaultRepresentation for string datatype field nested in the newly added ActiveRecord::Base to the collection" do
            @user.tasks.build{ |new_i| new_i.title }.should be_kind_of(Representations::DefaultRepresentation)
        end
    end

end
