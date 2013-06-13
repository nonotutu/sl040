class RegistrationStatus < ActiveRecord::Base
  
  has_many :registrations
  
  attr_accessible :name, :pos
  
  def to_s
    name
  end
  
end
