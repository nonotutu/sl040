class IbanValidator < ActiveModel::EachValidator
  
  def validate_each(object, attribute, value)
    #     object.errors.add attribute, 'IBAN is mandatory' and next if value.blank?
    # IBAN code should start with country code (2letters)
    #     object.errors.add attribute, 'Country code is missing from the IBAN code' and next unless value.to_s =~ /^[A-Z]{2}/i
    object.errors.add attribute, 'is not valid IBAN format' unless value.to_s =~ /^[A-Z]{2}\d\d(\s\d{4}){3}$/i
    value = value.gsub(/ /,'')
    iban = value.gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
    object.errors.add attribute, 'is not valid IBAN number' unless (iban[6..iban.length-1].to_s+iban[0..5].to_s).to_i % 97 == 1
  end
  
end 
