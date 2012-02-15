require 'spec_helper'

describe Presentation do
  describe "next meeting day" do
    it "should return the date if it's Monday or Thursday" do
      d = DateTime.civil(2012, 2, 16) # This is Thursday
      meeting_day = Presentation.next_meeting_day d
      meeting_day.thursday?.should == true
    end

    it 'should return the next Monday or Thursday if the given date is not' do
      d = DateTime.civil(2012, 2, 15) # This is Wednesday
      meeting_day = Presentation.next_meeting_day d
      #p meeting_day
      meeting_day.thursday?.should == true

      #p meeting_day + 1.day
      meeting_day = Presentation.next_meeting_day(meeting_day + 1.day)
      #p meeting_day
      meeting_day.monday?.should == true
    end
  end
end
