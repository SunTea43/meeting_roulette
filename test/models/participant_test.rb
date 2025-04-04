require "test_helper"

class ParticipantTest < ActiveSupport::TestCase
  test "should not save participant without name" do
    participant = Participant.new
    assert_not participant.save, "Saved the participant without a name"
  end
  
  test "should save participant with name" do
    participant = Participant.new(name: "John Doe")
    assert participant.save, "Could not save the participant with a name"
  end
  
  test "should set active to true by default" do
    participant = Participant.new(name: "Jane Smith")
    assert participant.active, "Active was not set to true by default"
  end
  
  test "active scope should return only active participants" do
    # Clear existing data to ensure a clean test environment
    Participant.delete_all
    
    # Create test data
    Participant.create(name: "Active User", active: true)
    Participant.create(name: "Inactive User", active: false)
    
    active_participants = Participant.active
    
    assert_equal 1, active_participants.count
    assert_equal "Active User", active_participants.first.name
  end
end
