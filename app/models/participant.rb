class Participant < ApplicationRecord
  validates :name, presence: true
  
  # Scope to get only active participants
  scope :active, -> { where(active: true) }
  
  # Set active to true by default
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.active = true if self.active.nil?
  end
end
