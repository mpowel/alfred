# class Person < ActiveRecord::Base
#
#   belongs_to :team
#
#   validates_presence_of :team_id
#
#   validates :mobile, :phone_number => {:message => "Invalid and can only be attributable to human error"}
#
#   def format_number(number)
#     digits = number.gsub(/\D/, '').split(//)
#     if (digits.length == 11 and digits[0] == '1')
#       # Strip leading 1
#       digits.shift
#     end
#
#     if (digits.length == 10)
#       digits = digits.join
#       '(%s) %s-%s' % [ digits[0,3], digits[3,3], digits[6,4] ]
#     end
#   end
#
# end
