class HexColorValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    unless value =~ /^[0-9A-F]{6}$/i
      object.errors[attribute] << (options[:message] || "is not valid")
    end
  end
  
end 
