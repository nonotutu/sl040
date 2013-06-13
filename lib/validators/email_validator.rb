class EmailValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^([^@\s]+)@([a-z0-9]+\.)+[a-z]{2,}$/i && value.length <= 128
      object.errors[attribute] << (options[:message] || "is not valid")
    end
  end
  
end 
