require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Representations::TimeWithZoneRepresentation do

  #it "::select should create proper select tags for date" do
    #user = stub_model(User, {:created_at => Time.zone.now})
    #template = ActionView::Template.new(ActionView::Template.new('.'))
    #user = ResourceRepresentations::representation_for(user, template, 'user')
    #puts 'Puts: ' + user.created_at.select.to_s
    #user.created_at.select.should == #'<select id="user_created_at_1i" name="user[created_at(1i)]">
#<option value="2004">2004</option>
#<option value="2005">2005</option>
#<option value="2006">2006</option>
#<option value="2007">2007</option>
#<option value="2008">2008</option>
#<option selected="selected" value="2009">2009</option>
#<option value="2010">2010</option>
#<option value="2011">2011</option>
#<option value="2012">2012</option>
#<option value="2013">2013</option>
#<option value="2014">2014</option>
#</select>
#<select id="user_created_at_2i" name="user[created_at(2i)]">
#<option value="1">January</option>
#<option value="2">February</option>
#<option value="3">March</option>
#<option value="4">April</option>
#<option value="5">May</option>
#<option value="6">June</option>
#<option value="7">July</option>
#<option value="8">August</option>
#<option value="9">September</option>
#<option selected="selected" value="10">October</option>
#<option value="11">November</option>
#<option value="12">December</option>
#</select>
#<select id="user_created_at_3i" name="user[created_at(3i)]">
#<option value="1">1</option>
#<option value="2">2</option>
#<option value="3">3</option>
#<option value="4">4</option>
#<option value="5">5</option>
#<option value="6">6</option>
#<option value="7">7</option>
#<option value="8">8</option>
#<option value="9">9</option>
#<option value="10">10</option>
#<option value="11">11</option>
#<option value="12">12</option>
#<option selected="selected" value="13">13</option>
#<option value="14">14</option>
#<option value="15">15</option>
#<option value="16">16</option>
#<option value="17">17</option>
#<option value="18">18</option>
#<option value="19">19</option>
#<option value="20">20</option>
#<option value="21">21</option>
#<option value="22">22</option>
#<option value="23">23</option>
#<option value="24">24</option>
#<option value="25">25</option>
#<option value="26">26</option>
#<option value="27">27</option>
#<option value="28">28</option>
#<option value="29">29</option>
#<option value="30">30</option>
#<option value="31">31</option>
#</select>'
  #end
end
