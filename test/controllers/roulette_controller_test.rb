require "test_helper"

class RouletteControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Clear existing participants to ensure a clean test environment
    Participant.delete_all
    
    # Create some test participants
    @active1 = Participant.create(name: "Active 1", active: true)
    @active2 = Participant.create(name: "Active 2", active: true)
    @inactive = Participant.create(name: "Inactive", active: false)
  end
  
  test "should get index" do
    get root_url
    assert_response :success
    assert_select 'h1', 'Meeting Leader Roulette'
  end
  
  test "should show active participants count on index" do
    get root_url
    assert_response :success
    assert_select '.roulette-status', /Ready to choose from 2 active participants/
  end
  
  test "should show message when no active participants" do
    # Deactivate all participants
    Participant.update_all(active: false)
    
    get root_url
    assert_response :success
    assert_select '.roulette-status.empty', /No active participants available/
  end

  test "should get spin and select a random participant" do
    get spin_url
    assert_response :success
    assert_select 'h1', 'The Roulette Has Spoken!'
    
    # Check if the winner is one of our active participants
    winner_name = css_select('.winner-name').text.strip
    assert [@active1.name, @active2.name].include?(winner_name), 
           "Winner '#{winner_name}' is not one of the active participants"
  end
  
  test "spin should handle no active participants" do
    # Deactivate all participants
    Participant.update_all(active: false)
    
    get spin_url
    assert_response :success
    assert_select '.no-result', /No active participants available/
  end
end
