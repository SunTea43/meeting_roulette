class RouletteController < ApplicationController
  def index
    @participants = Participant.all
    @active_count = Participant.active.count
  end

  def spin
    active_participants = Participant.active
    
    if active_participants.any?
      # Randomly select one active participant
      @selected = active_participants.offset(rand(active_participants.count)).first
    else
      @selected = nil
    end
    
    # Render the result view
    render :result
  end
end
