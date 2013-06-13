class Supplier < ActiveRecord::Base
  
  has_many :items
  has_many :purchases
  
  attr_accessible :name, :address

  before_destroy :prevent_destroy_unless_empty

  
  def to_s
    self.name
  end
  
  
  private
  
  def prevent_destroy_unless_empty
    self.errors.add(:base, "not empty")
      unless ( self.items.empty? && self.purchases.empty? )
        return false
      end
  end

  
end
