# coding: UTF-8
class Item < ActiveRecord::Base
  
  belongs_to :category
  belongs_to :supplier
  has_many :contents
  has_many :containers, :through => :contents
  has_many :purchases

  attr_accessible :category_id,
                  :supplier_id,
                  :nature,
                  :produit,
                  :condition,
                  :disposable
  
  validates :category_id, presence: true
  validates :nature,      presence: true, length: { maximum: 32 }
  validates :produit,                     length: { maximum: 32 }
  validates :condition,                   length: { maximum: 32 }
    
  before_destroy :prevent_destroy_unless_empty

  #default_scope order(:category_id).order(:nature).order(:produit)
  scope :only_category, lambda { |categ_id| where(:category_id => categ_id) }

  
  def to_s
    r = "#{self.nature}"
    r += " - #{self.produit}" unless self.produit.empty?
    r += " - #{self.condition}" unless self.condition.empty?
    r += " - ➀" if self.disposable
    return r
  end

  def name
    to_s
  end
  
  def count
    
    q = 0
    qu = 0
    self.contents.each do |content|
      if content.unitary
        qu += content.quantity * multiplicande_recursive(content.container)
      else
        q += content.quantity * multiplicande_recursive(content.container)
      end
    end
    return ( (qu > 0 ? "*" + qu.to_s : "" ) + ( q > 0 && qu > 0 ? " + " : "" ) + ( q > 0 ? q.to_s : "" ) )

  end
  
# def ancestor_containers
  def array_array_ancestors
    array_ancestors = []
    self.contents.each do |content|
      array_ancestors << [ content.container ] + content.container.array_ancestors
    end
    return array_ancestors
  end
  

  private
  
  
  def multiplicande_recursive(container)
    return container.quantity * multiplicande_recursive(container.container) if container.container
    return container.quantity
  end
  
  
  def prevent_destroy_unless_empty
    self.errors.add(:base, "not empty")
      unless ( self.contents.empty? )
        return false
      end
  end
  
end
