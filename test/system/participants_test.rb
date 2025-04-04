require "application_system_test_case"

class ParticipantsTest < ApplicationSystemTestCase
  setup do
    # Clear existing data to ensure a clean test environment
    Participant.delete_all
    @participant = Participant.create(name: "Test Participant", active: true)
  end

  test "visiting the index" do
    visit participants_url
    assert_selector "h1", text: "Meeting Participants"
  end

  test "should create participant" do
    visit participants_url
    click_on "Add New Participant"

    fill_in "Name", with: "New Test Participant"
    check "Active"
    click_on "Add Participant"

    assert_text "Participant was successfully added"
    assert_selector "td", text: "New Test Participant"
  end

  test "should update Participant" do
    visit participants_url
    
    within "tr", text: @participant.name do
      click_on "Edit"
    end

    fill_in "Name", with: "Updated Participant"
    uncheck "Active"
    click_on "Update Participant"

    assert_text "Participant was successfully updated"
    assert_selector "td", text: "Updated Participant"
    assert_selector "span.status-badge.inactive", text: "Inactive"
  end

  test "should destroy Participant" do
    visit participants_url
    
    # Use button_to for delete which doesn't trigger a confirmation dialog in system tests
    within "tr", text: @participant.name do
      click_on "Delete"
    end

    assert_text "Participant was successfully removed"
    assert_no_text @participant.name
  end
  
  test "bulk adding participants" do
    visit participants_url
    click_on "Bulk Add Participants"
    
    fill_in "names", with: "Bulk User 1\nBulk User 2\nBulk User 3"
    click_on "Add Participants"
    
    assert_text "Successfully added 3 participants"
    assert_selector "td", text: "Bulk User 1"
    assert_selector "td", text: "Bulk User 2"
    assert_selector "td", text: "Bulk User 3"
  end
  
  test "bulk toggling participants" do
    # Create some test participants
    active1 = Participant.create(name: "Active Test 1", active: true)
    active2 = Participant.create(name: "Active Test 2", active: true)
    
    visit participants_url
    
    # Select the participants
    # Find the checkbox by its ID which includes the participant ID
    find("input[value='#{active1.id}']").check
    find("input[value='#{active2.id}']").check
    
    # Deactivate them
    click_button "Deactivate Selected"
    
    # Reload the page to see the changes
    visit participants_url
    
    # Verify the participants are now inactive
    within "tr", text: active1.name do
      assert_selector "span.status-badge.inactive", text: "Inactive"
    end
    
    within "tr", text: active2.name do
      assert_selector "span.status-badge.inactive", text: "Inactive"
    end
    
    # Now select them again and activate
    find("input[value='#{active1.id}']").check
    find("input[value='#{active2.id}']").check
    
    click_button "Activate Selected"
    
    # Reload the page to see the changes
    visit participants_url
    
    # Verify the participants are now active
    within "tr", text: active1.name do
      assert_selector "span.status-badge.active", text: "Active"
    end
    
    within "tr", text: active2.name do
      assert_selector "span.status-badge.active", text: "Active"
    end
  end
  
  test "select all and deselect all buttons" do
    # Create some test participants
    3.times do |i|
      Participant.create(name: "Test User #{i}", active: true)
    end
    
    visit participants_url
    
    # Test select all
    click_on "Select All"
    
    # Count all checkboxes (including the header checkbox)
    all_checkboxes = all("input[type=checkbox]")
    checked_checkboxes = all("input[type=checkbox]:checked")
    
    assert_equal all_checkboxes.count, checked_checkboxes.count
    
    # Test deselect all
    click_on "Deselect All"
    checked_checkboxes = all("input[type=checkbox]:checked")
    
    assert_equal 0, checked_checkboxes.count
  end
end
