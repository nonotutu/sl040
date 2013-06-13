class Color < ActiveRecord::Base

  has_many :departments
  
  attr_accessible :name,
                  :hex
  
  validates :name, presence: true, uniqueness: true
  validates :hex,  presence: true, uniqueness: true, hex_color: true
  
  before_destroy :prevent_destroy_unless_empty
  
  def to_s
    name
  end
    
  private
  
  def prevent_destroy_unless_empty
    self.errors.add(:base, "not empty")
      unless ( self.departments.empty? )
        return false
      end
  end
  
end
 
