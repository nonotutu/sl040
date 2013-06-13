class ActNeed < ActiveRecord::Base
  
  belongs_to :activity
  
  attr_accessible :pos,
                  :activity_id,
                  :name,
                  :qty_volunteers
  
  validates :name,        presence: true, length: { maximum: 32 }
  validates :activity_id, presence: true
  
  before_destroy :prevent_destroy_unless_empty
  
  default_scope order(:pos)
  
  def to_s
    r = name
    r += " - " + qty_volunteers.to_s if qty_volunteers
    return r
  end
  
  private
  
  def prevent_destroy_unless_empty
    unless ( Registration.where(:act_need_id => self.id).empty? )
      self.errors.add(:base, "non vide : #{Registration.model_name.human}")
      return false 
    end
  end

end
