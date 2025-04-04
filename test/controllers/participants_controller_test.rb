require "test_helper"

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @participant = participants(:one)
  end
  
  test "should get index" do
    get participants_url
    assert_response :success
  end

  test "should get new" do
    get new_participant_url
    assert_response :success
  end

  test "should create participant" do
    assert_difference("Participant.count") do
      post participants_url, params: { participant: { name: "New Participant", active: true } }
    end

    assert_redirected_to participants_url
    assert_equal 'Participant was successfully added.', flash[:notice]
  end

  test "should not create participant without name" do
    assert_no_difference("Participant.count") do
      post participants_url, params: { participant: { name: "", active: true } }
    end

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_participant_url(@participant)
    assert_response :success
  end

  test "should update participant" do
    patch participant_url(@participant), params: { participant: { name: "Updated Name", active: false } }
    assert_redirected_to participants_url
    assert_equal 'Participant was successfully updated.', flash[:notice]
    
    @participant.reload
    assert_equal "Updated Name", @participant.name
    assert_equal false, @participant.active
  end

  test "should destroy participant" do
    assert_difference("Participant.count", -1) do
      delete participant_url(@participant)
    end

    assert_redirected_to participants_url
    assert_equal 'Participant was successfully removed.', flash[:notice]
  end
  
  # Bulk actions tests
  test "should get bulk new" do
    get bulk_new_participants_url
    assert_response :success
  end
  
  test "should create multiple participants" do
    assert_difference("Participant.count", 3) do
      post bulk_create_participants_url, params: { names: "John Doe\nJane Smith\nAlex Johnson" }
    end
    
    assert_redirected_to participants_url
    assert_equal "Successfully added 3 participants.", flash[:notice]
  end
  
  test "should handle empty bulk create" do
    assert_no_difference("Participant.count") do
      post bulk_create_participants_url, params: { names: "" }
    end
    
    assert_redirected_to bulk_new_participants_url
    assert_equal "Please enter at least one name.", flash[:alert]
  end
  
  test "should bulk activate participants" do
    inactive1 = Participant.create(name: "Inactive 1", active: false)
    inactive2 = Participant.create(name: "Inactive 2", active: false)
    
    post bulk_toggle_participants_url, params: { participant_ids: [inactive1.id, inactive2.id], active: "true" }
    
    assert_redirected_to participants_url
    assert_equal "Selected participants were activated.", flash[:notice]
    
    inactive1.reload
    inactive2.reload
    assert inactive1.active
    assert inactive2.active
  end
  
  test "should bulk deactivate participants" do
    active1 = Participant.create(name: "Active 1", active: true)
    active2 = Participant.create(name: "Active 2", active: true)
    
    post bulk_toggle_participants_url, params: { participant_ids: [active1.id, active2.id], active: "false" }
    
    assert_redirected_to participants_url
    assert_equal "Selected participants were deactivated.", flash[:notice]
    
    active1.reload
    active2.reload
    assert_not active1.active
    assert_not active2.active
  end
  
  test "should handle bulk toggle with no participants selected" do
    post bulk_toggle_participants_url, params: { active: "true" }
    
    assert_redirected_to participants_url
    assert_equal "No participants were selected.", flash[:alert]
  end
end
