module ApplicationHelper

  include NumberHelper

  def age(birth_date)
    age = Date.today - birth_date
    (age / 365.25).to_i
  end

end
