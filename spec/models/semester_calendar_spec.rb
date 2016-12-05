require 'spec_helper'

describe SemesterCalendar do
  before do
    @corporation = create :corporation
    @semester_calendar = @corporation.semester_calendars.create year: Time.zone.now.year, term: :summer_term
    @event = Event.create name: "BBQ", start_at: Time.zone.now.change(month: 8)
    @event_in_another_term = Event.create name: "Christmas Party", start_at: Time.zone.now.change(month: 12)
    @corporation << @event
    @corporation << @event_in_another_term
    @semester_calendar.events(true)
  end

  describe "#events" do
    subject { @semester_calendar.events }
    it "should include the events of the given term and year" do
      subject.should include @event
    end
    it "should not include the events of other terms" do
      subject.should_not include @event_in_another_term
    end
  end

  describe "#update" do
    describe "when changing event attributes" do
      subject { @semester_calendar.update! events_attributes: {0 => {id: @event.id, name: "Special BBQ"}} }
      it "should update the changed attribute on the event" do
        subject
        @event.reload.name.should == "Special BBQ"
      end
      it "should not change the other attributes" do
        @old_start_at = @event.start_at
        subject
        @event.reload.start_at.to_i.should == @old_start_at.to_i
      end
    end

    describe "when adding a new event's attributes" do
      subject { @semester_calendar.update! events_attributes: {0 => {name: "New event"}} }
      it "should create the new event" do
        subject
        Event.last.name.should == "New event"
      end
      it "should add the new event to the calendars corporation" do
        subject
        Event.last.ancestor_groups.should include @corporation
      end
    end
  end

end
