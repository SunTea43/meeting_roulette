require "application_system_test_case"

class RouletteTest < ApplicationSystemTestCase
  setup do
    # Clear existing data to ensure a clean test environment
    Participant.delete_all
    
    # Create some test participants
    @active1 = Participant.create(name: "Active Participant 1", active: true)
    @active2 = Participant.create(name: "Active Participant 2", active: true)
    @inactive = Participant.create(name: "Inactive Participant", active: false)
  end

  test "visiting the home page" do
    visit root_url
    assert_selector "h1", text: "Meeting Leader Roulette"
    assert_text "Ready to choose from 2 active participants"
    assert_selector ".roulette-wheel"
  end

  test "spinning the roulette" do
    visit root_url
    click_on "Spin the Roulette!"
    
    assert_selector "h1", text: "The Roulette Has Spoken!"
    assert_selector ".winner-name"
    
    # The winner should be one of the active participants
    winner_text = find(".winner-name").text
    assert [
      @active1.name,
      @active2.name
    ].include?(winner_text), "Winner #{winner_text} is not one of the active participants"
  end
  
  test "spinning again" do
    visit spin_url
    assert_selector "h1", text: "The Roulette Has Spoken!"
    
    click_on "Spin Again"
    
    # Should still be on the result page
    assert_selector "h1", text: "The Roulette Has Spoken!"
    assert_selector ".winner-name"
  end
  
  test "back to roulette" do
    visit spin_url
    click_on "Back to Roulette"
    
    # Should be back on the home page
    assert_selector "h1", text: "Meeting Leader Roulette"
  end
  
  test "no active participants" do
    # Deactivate all participants
    Participant.update_all(active: false)
    
    visit root_url
    
    assert_selector ".roulette-status.empty"
    assert_text "No active participants available"
    assert_text "Please add some participants and mark them as active first"
    
    # Should have a link to add participants
    assert_selector "a", text: "Add Participants"
    
    # Should not have the spin button
    assert_no_selector ".spin-button"
  end
  
  test "navigation between roulette and participants" do
    visit root_url
    click_on "Manage Participants"
    
    assert_selector "h1", text: "Meeting Participants"
    
    click_on "Back to Roulette"
    
    assert_selector "h1", text: "Meeting Leader Roulette"
  end
end
