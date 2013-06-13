# coding: utf-8
class Volunteer < ActiveRecord::Base

  belongs_to :section  
  has_and_belongs_to_many :departments
  has_many :certificates
  has_many :trainings, through: :certificates
  has_many :registrations
  has_many :activities, through: :registrations
  
  attr_accessible :section_id,
                  :pos,
                  :cr_number,
                  :first_name,
                  :last_name,
                  :sex,
                  :date_of_birth,
                  :place_of_birth,
                  :email,
                  :land_phone, 
                  :cell_phone,
                  :cr_joined_on,
                  :department_ids, 
                  :address,
                  :bank_account

  validates :section_id, presence: true
  validates :pos,                        uniqueness: true
  validates :cr_number,                  uniqueness: true, length: { is: 15 },                    unless: "cr_number == nil    || cr_number == ''"
  validates :first_name,
            :last_name,  presence: true,                   length: { maximum: 64 }
  validates :email,                      uniqueness: true, length: { maximum: 128 }, email: true, unless: "email == nil        || email == ''" # nil pour console, '' pour html
  validates :land_phone,                 uniqueness: true,                           phone: true, unless: "land_phone == nil   || land_phone == ''"
  validates :cell_phone,                 uniqueness: true,                           phone: true, unless: "cell_phone == nil   || cell_phone == ''"
  validates :bank_account,               uniqueness: true,                           iban: true,  unless: "bank_account == nil || bank_account == ''"
  
  before_destroy :prevent_destroy_unless_empty

  scope :only_active,     includes(:departments) & joins(:departments)
  scope :only_not_active, includes(:departments) - joins(:departments)
  scope :only_department, lambda { |dep_id| includes(:departments).where('departments_volunteers.department_id = ?', dep_id) }
  scope :only_section,    lambda { |section_id| where(section_id: section_id) }

  def to_s
    "#{first_name} #{last_name}"
  end
  
  def to_long_s
    r = to_s
    r += " (#{section.number})" if section_id != 1 # TODO current_user.section
    return r
  end
  
  def days_to_birthday
    if date_of_birth
      return ( next_birthday_on - Date.today ).to_i
    end
  end
  
  def next_birthday_on
    if date_of_birth
      annif = Date.new(Date.today.year, date_of_birth.month, date_of_birth.day)
      annif = annif + 1.year if (annif+1.day).past?
      return annif
    end
  end
  
  def birthday
    "#{date_of_birth.day}/#{date_of_birth.month}" if date_of_birth
  end
  
  def cell_phone=(cell_phone)
    write_attribute(:cell_phone, phonizer(cell_phone))
  end
  
  def land_phone=(land_phone)
    write_attribute(:land_phone, phonizer(land_phone))
  end
  
  def bank_account=(bank_account)
    write_attribute(:bank_account, ibanizer(bank_account))
  end

  def sex=(sex)
    if sex.to_i != 1 && sex.to_i != 2
      sex = 1
    end
    write_attribute(:sex, sex)
  end
  
  def sex_to_string
    if sex == 1
      return "♀"
    elsif sex == 2
      return "♂"
    else
      return sex
    end
  end

  def active?
    if department_ids != []
      return true
    else
      return false
    end
  end
  
  private
  
  def prevent_destroy_unless_empty
    unless ( certificates.empty? && activities.empty? )
      errors.add(:base, "non vide : #{Certificate.model_name.human}") unless certificates.empty?
      errors.add(:base, "non vide : #{Activity.model_name.human}") unless activities.empty?
      return false 
    end
  end
  
  def phone_to_string(phone)
    if phone
    end
  end
  
  def phonizer(phone)
    phone = phone.gsub(/ /,'')
    if phone[0] == "0"
      phone[0] = "+"
      phone = phone.insert(1,"32")
    end
    case phone.length
      when 12
        phone.insert(3," ").insert(7," ").insert(11," ")
      when 11
        phone.insert(3," ").insert(6," ").insert(9," ").insert(12," ")
    end
    phone
  end
  
  def ibanizer(iban)
    iban = iban.gsub(/ /,'')
    if iban.length == 16
      iban.insert(4," ").insert(9," ").insert(14," ")
    end
    iban
  end
        
end
