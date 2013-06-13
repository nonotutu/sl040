class Certificate < ActiveRecord::Base

  attr_accessible :issued_on,
                  :number,
                  :training_id,
                  :volunteer_id
  
  belongs_to :training
  belongs_to :volunteer
  
  validates :training_id,  presence: true
  validates :volunteer_id, presence: true
  validates :number,       length: { maximum: 32 }
  
  default_scope includes(:training).order('trainings.pos')
  
  def to_s
    return "#{self.volunteer} : #{self.training}"
  end
  
end
