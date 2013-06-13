class Purchase < ActiveRecord::Base
  
  belongs_to :item
  belongs_to :supplier
  
  attr_accessible :item_id,
                  :supplier_id,
                  :number,
                  :purchased_on,
                  :active,
                  :comment

  validates :item_id, presence: true
  validates :number,  presence: true, length: { maximum: 64 }
  
  def to_s
    "#{item.name} #{number}"
  end
  
  def name
    to_s
  end
  
end
