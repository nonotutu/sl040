class Department < ActiveRecord::Base

  belongs_to :color
  has_and_belongs_to_many :volunteers
  
  attr_accessible :short_name,
                  :name,
                  :color_id
  
  validates :short_name, presence: true, length: { maximum: 4 },  uniqueness: true
  validates :name,       presence: true, length: { maximum: 26 }, uniqueness: true
  validates :color_id,   presence: true,                          uniqueness: true

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
