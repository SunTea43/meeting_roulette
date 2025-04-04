class ParticipantsController < ApplicationController
  def index
    @participants = Participant.all
  end

  def new
    @participant = Participant.new
  end

  def create
    @participant = Participant.new(participant_params)
    
    if @participant.save
      redirect_to participants_path, notice: 'Participant was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @participant = Participant.find(params[:id])
  end

  def update
    @participant = Participant.find(params[:id])
    
    if @participant.update(participant_params)
      redirect_to participants_path, notice: 'Participant was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
    
    redirect_to participants_path, notice: 'Participant was successfully removed.'
  end

  # Bulk actions
  def bulk_new
    # Just render the form
  end

  def bulk_create
    names = params[:names].to_s.strip.split("\n").map(&:strip).reject(&:empty?)
    
    if names.empty?
      redirect_to bulk_new_participants_path, alert: 'Please enter at least one name.'
      return
    end
    
    # Create participants
    created_count = 0
    names.each do |name|
      participant = Participant.new(name: name, active: true)
      created_count += 1 if participant.save
    end
    
    redirect_to participants_path, notice: "Successfully added #{created_count} participants."
  end

  def bulk_toggle
    if params[:participant_ids].present?
      active_status = params[:active] == 'true'
      Participant.where(id: params[:participant_ids]).update_all(active: active_status)
      status_text = active_status ? 'activated' : 'deactivated'
      redirect_to participants_path, notice: "Selected participants were #{status_text}."
    else
      redirect_to participants_path, alert: 'No participants were selected.'
    end
  end

  private

  def participant_params
    params.require(:participant).permit(:name, :active)
  end
end
