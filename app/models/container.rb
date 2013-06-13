# coding : UTF-8
class Container < ActiveRecord::Base
  
  belongs_to :container
  has_many :containers
  has_many :contents
  has_many :items, through: :contents

  attr_accessible :container_id,
                  :short_name,
                  :name,
                  :quantity,
                  :model,
                  :pos,
                  :status
  
  validates :name,     presence: true
  validates :quantity, presence: true
  
  validate :cannot_be_self_contained, on: :update
  
  before_destroy :prevent_destroy_unless_empty

  scope :racine, where(container_id: nil)
    
  
  def to_s
    return self.name
  end
  
  
  def contenu
    @contenu = []
    @contenu << [0, self]
    fill_with_items(self, 1)
    visiter_container(self, 0)
    return @contenu
  end
  
  
  def stack_deep
    return deeper(self, 1)
  end
  
  
  def name_with_ancestors
    ancestor = self.name
    container = self.container
    while container
      ancestor += " ⊂ " + container.name
      container = container.container
    end
    return ancestor
  end
  
  def root?
    return true unless self.container
    return false
  end
  
  
  def root
    if self.container
      self.container.root
    else
      return self
    end
  end
  
  
  def array_ancestors
    ancestors = []
    container = self.container
    while container
      ancestors << container
      container = container.container
    end
    return ancestors
  end
  
  
  def count_containers
    count = 0
    self.containers.each do |container|
      count += container.count_containers
    end
    return count += 1
  end
  
  
  def count_contents
    count = 0
    self.containers.each do |container|
      count += container.count_contents
    end
    return count += self.contents.count
  end
    
  
  private
  
  def prevent_destroy_unless_empty
    unless ( self.contents.empty? && self.containers.empty? )
      self.errors.add(:base, "non vide : #{Content.model_name.human}") unless contents.empty?
      self.errors.add(:base, "non vide : #{Container.model_name.human}") unless containers.empty?
      return false 
    end
  end

  
  def cannot_be_self_contained
    if container_id == id
      errors.add(:container_id, "cannot be self contained")
    end
  end
  
  
  def deeper(container, indent)
    container.containers.each do |cont|
      deeper(cont, indent)
      indent += 1
    end
    indent -= 1
  end
  
    
  def visiter_container(container, indent)
    indent += 1
    container.containers.order(:pos).each do |cont|
      @contenu << [indent, cont]
      fill_with_items(cont, indent + 1)
      visiter_container(cont, indent)
    end
    indent -= 1
  end

  
  def fill_with_items(container, indent)
    container.contents.order(:pos).each do |content|
      @contenu << [indent, content]
    end
  end

  
  
end
