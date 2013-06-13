# coding: utf-8
class Registration < ActiveRecord::Base
  
  belongs_to :activity
  belongs_to :volunteer
  belongs_to :registration_status, foreign_key: :status_id
  
  attr_accessible :activity_id,
                  :act_need_id,  # aucune relation dans la DB
                  :volunteer_id,
                  :status_id,
                  :starts_delay,
                  :ends_delay,
                  :rendezvous_place
  
  validates :activity_id,  presence: true
  validates :volunteer_id, presence: true
  validates :starts_delay, presence: true
  validates :ends_delay,   presence: true
  validate :starts_delay_ends_delay
  
  def to_s
    to_short_s
  end
  
  def status
    registration_status.name
  end
  
  def to_short_s
    result = volunteer.to_long_s
    result += ' (' unless starts_delay.zero? && ends_delay.zero?
    result += starts_at.to_formatted_s(:cust_time) unless starts_delay.zero?
    result += '→' + ends_at.to_formatted_s(:cust_time) unless ends_delay.zero?
    result += ')' unless starts_delay.zero? && ends_delay.zero?
    return result
  end
  
  def starts_at
    activity.real_start + starts_delay * 300
  end

  def starts_at_formatted_s
    return starts_at.to_formatted_s(:cust_time) if activity.real_end - activity.real_start < 86400
    return starts_at.to_formatted_s(:cust_short)
  end  
  
  def ends_at
    activity.real_end - ends_delay * 300
  end

  def ends_at_formatted_s
    return ends_at.to_formatted_s(:cust_time) if activity.real_end - activity.real_start < 86400
    return ends_at.to_formatted_s(:cust_short)
  end  
  
private
  
  def starts_delay_ends_delay
    if starts_delay && ends_delay
      errors.add(:starts_delay, "must be before #{Registration.human_attribute_name(:ends_delay)}") if ( starts_delay + ends_delay ) > (( activity.real_end - activity.real_start )/300 - 1)
    end
  end
  
end
