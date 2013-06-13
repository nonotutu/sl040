class Training < ActiveRecord::Base
  
  has_many :certificates  
  has_many :volunteers, :through => :certificates  
  
  attr_accessible :pos,
                  :name,
                  :short_name,
                  :active
  
  validates :short_name, presence: true, length: { maximum: 8 }
  validates :name,       presence: true, length: { maximum: 40 }
  validates :pos,        uniqueness: true

  before_destroy :prevent_destroy_unless_empty

  default_scope order(:pos)
  scope :only_active, where(:active => true)
  
  def to_s
    return self.name
  end
  
  private
  
  def prevent_destroy_unless_empty
    unless ( certificates.empty? )
      errors.add(:base, "non vide : #{Certificate.model_name.human}")
      return false 
    end
  end

  
end
