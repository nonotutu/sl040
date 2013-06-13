# coding: UTF-8
class Content < ActiveRecord::Base

  belongs_to :item
  belongs_to :container
  
  attr_accessible :item_id,
                  :container_id,
                  :pos,
                  :quantity,
                  :unitary

  validates :item_id,      :presence => true
  validates :container_id, :presence => true
  validates :quantity,     :presence => true
  
  def to_s
    return ( self.unitary ? "*" : "" ) + "#{self.quantity} × #{self.item}"
  end

  
end
