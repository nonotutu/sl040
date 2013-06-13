class Category < ActiveRecord::Base
  
  has_many :items
  
  attr_accessible :short_name,
                  :name
  
  validates :short_name, presence: true
  validates :name,       presence: true
  
  before_destroy :prevent_destroy_unless_empty
  
  default_scope order :name
  
  def to_s
    self.name
  end
  
private

  def prevent_destroy_unless_empty
    self.errors.add(:base, "not empty")
      unless ( self.items.empty? )
        return false 
      end
  end

end
