require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations::TimeWithZone do

  it "should generate select with a valid name" do
    t = Task.new(:due_to => Time.now.in_time_zone)
    @template = stub("Template")
    @template.should_receive(:date_select).with("task", "due_to", {:object=>t}, {})
    t = Representations::representation_for(t, @template, 'task')
    t.due_to.select
  end
end
