# app/validators/phone_number_validator.rb
class PhoneNumberValidator < ActiveModel::EachValidator
  @@regex = %r{\A(?:1(?:[. -])?)?(?:\((?=\d{3}\)))?([2-9]\d{2})(?:(?<=\(\d{3})\))? ?(?:(?<=\d{3})[.-])?([2-9]\d{2})[. -]?(\d{4})(?: (?:ext|x)\.? ?(\d{1,5}))?\Z}

  def validate_each (object, attribute, value)
    if m = value.match(@@regex)
      # format the phone number consistently
      object.send("#{attribute}=", "(#{m[1]}) #{m[2]}-#{m[3]}")
    else
      object.errors[attribute] << (options[:message] || "is not an appropriately formatted phone number")
    end
  end
end
