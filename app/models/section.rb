class Section < ActiveRecord::Base
  
  has_many :volunteers
  
  attr_accessible :name,
                  :number
  
  validates :name,   presence: true, length: { maximum: 16 }
  validates :number, presence: true, length: { maximum: 4 }
  
  before_destroy :prevent_destroy_unless_empty
  
  def to_s
    name
  end
  
private
  
  def prevent_destroy_unless_empty
    unless ( volunteers.empty? )
      errors.add(:base, "non vide : #{Volunteer.model_name.human}")
      return false
    end
  end
  
end
