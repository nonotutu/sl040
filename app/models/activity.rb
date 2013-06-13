# coding: utf-8
class Activity < ActiveRecord::Base

  belongs_to :department
  has_many :registrations
  has_many :volunteers, through: :registrations
  has_many :act_needs
  
  attr_accessible :department_id,
                  :name,
                  :place,
                  :address,
                  :rendezvous_place,
                  :rendezvous_at,
                  :starts_at,
                  :ends_at,
                  :description
  
  validates :department_id, presence: true
  validates :name,          presence: true, length: { maximum: 64 }
  validates :place,         presence: true, length: { maximum: 64 }
  validate :starts_at_before_ends_at
  validate :rendezvous_at_before_starts_at
  validate :maximum_duration
  
  before_destroy :prevent_destroy_unless_empty
  
  scope :only_before, lambda { |time| { conditions: ["starts_at < ?", time] } }
  scope :only_after,  lambda { |time| { conditions: ["ends_at > ?", time] } }
  
  def to_s
    name
  end
  
  def rendezvous
    if rendezvous_at && rendezvous_place != ''
      "#{rendezvous_place}, #{rendezvous_at.to_formatted_s(:cust_time)}"
    elsif rendezvous_at
      "#{rendezvous_at.to_formatted_s(:cust_time)}"
    elsif rendezvous_place != ''
      "#{rendezvous_place}"
    else
      nil
    end
  end
  
  def heures_to_s
    "#{starts_at.to_formatted_s(:time)} → #{ends_at.to_formatted_s(:time)}"
  end
  
  def date_to_s
    return "#{real_start.to_formatted_s(:cust_date)}" if real_start.to_date == real_end.to_date
    "#{real_start.day}─#{real_end.to_formatted_s(:cust_date)}"
  end

  def days_to_s
    return "#{real_start.day}" if real_start.to_date == real_end.to_date
    "#{real_start.day}─#{real_end.day}"
  end

  def real_start
    return rendezvous_at if rendezvous_at
    return starts_at
  end
  
  def real_end
    ends_at
  end
  
  def starts_at_to_short_s
    return "#{starts_at.to_formatted_s(:time)}" if one_day_event?
    "#{starts_at.strftime("%A")} ─ #{starts_at.to_formatted_s(:time)}"
  end
    
  def ends_at_to_short_s
    return "#{ends_at.to_formatted_s(:time)}" if one_day_event?
    "#{ends_at.strftime("%A")} ─ #{ends_at.to_formatted_s(:time)}"
  end
  
  def one_day_event?
    return true if real_start.to_date == real_end.to_date
    false
  end
    

private

  def prevent_destroy_unless_empty
    unless ( act_needs.empty? && registrations.empty? )
      self.errors.add(:base, "non vide : #{ActNeed.model_name.human}") unless act_needs.empty?
      self.errors.add(:base, "non vide : #{Registration.model_name.human}") unless registrations.empty?
      return false
    end
  end  

#   def generate(empties)
#     message = "non vide : "
#     empties.each do |empti|
#       mod = empti[0]
#       cnt = empti[1]
#       message += "#{cnt} × #{mod.model_name.human count: cnt}; " unless cnt == 0
#     end
#     return message
#   end
  
  def starts_at_before_ends_at
    if starts_at && ends_at
      errors.add(:starts_at, "must be before #{Activity.human_attribute_name(:ends_at)}") if ends_at < starts_at
    end
  end

  def rendezvous_at_before_starts_at
    if rendezvous_at && ends_at
      errors.add(:rendezvous_at, "must be before #{Activity.human_attribute_name(:starts_at)}") if starts_at < rendezvous_at
    end
  end
  
  def maximum_duration
    if starts_at && ends_at
      errors.add(Activity.model_name.human, "must be maximum 48h long") if ( ends_at - starts_at ) > 48.hours
    end
    if rendezvous_at && starts_at
      errors.add(:rendezvous_at, "must be maximum 4h before #{Activity.human_attribute_name(:starts_at)}") if ( starts_at - rendezvous_at ) > 4.hours
    end
  end
  
end

