# app/models/foobar.rb
class Foobar < ActiveRecord::Base
  validates :phone, phone_number: true
end