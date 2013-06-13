class PhoneValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^[+]32((\s\d{3}){3}|(\s\d{2}){4})$/
      object.errors[attribute] << (options[:message] || "is not valid")
    end
  end
  
end 
