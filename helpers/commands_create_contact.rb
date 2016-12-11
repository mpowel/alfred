module Sinatra
  module CommandsCreateContact

    # ------------------------------------------------------------------------
    # =>   MAPS THE CURRENT EVENT TO AN ACTION
    # ------------------------------------------------------------------------

    def create_contact client, event

      puts event
      puts "Formatted Text: #{event.formatted_text}"

      return if event.formatted_text.nil?

      is_admin = is_admin_or_owner client, event

      # Hi Commands
      if ["hi", "hey", "hello"].any? { |a| event.formatted_text.starts_with? a }
        client.chat_postMessage(channel: event.channel, text: "I'm Alfred, your personal contact management bot. I can keep track of your important contacts. Would you like to create a new contact? Type 'yes' or no'.", as_user: true)

# Later I hope to add: in my database and soon will be able to track any interaction with the email account etanproject.org@gmail.com

      elsif event.formatted_text == "yes"
              client.chat_postMessage(channel: event.channel, text: "Who would you like to add? Type `add [name]` and I'll add them for you.", as_user: true)

      elsif event.formatted_text == "no"
              client.chat_postMessage(channel: event.channel, text: "Ok, maybe later.", as_user: true)

# Later I hope to add: Type 'view contacts' to see a list of existing contacts, otherwise I’ll come back later.

      elsif event.formatted_text == "add"
        client.chat_postMessage(channel: event.channel, text: "Who would you like to add? Type `add [name]` and I'll add them for you.", as_user: true)

      elsif event.formatted_text.starts_with? "add"
        contact_name = event.formatted_text.gsub( "add", "" ).strip
        # I've removed the add prefix and cleaned up the string
        # I now have a formatted name

        # I'm creating a new object in my database with two pieces of info
        contact = Contact.create(team_id: event.team_id, name: contact_name )
# Should this include a contact_id??? #################################
        # I'm  now storing/saving/updating it in the database
        contact.save

        client.chat_postMessage(channel: event.channel, text: "I've added _#{ contact.name }_ for you. ", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "What is _#{ contact.name }_'s gender? Are the a `male` or a `female`. ", as_user: true)

      elsif event.formatted_text.starts_with? "male"

        contact = Contact.all.last
        contact.gender = "male"
        contact.save!

        client.chat_postMessage(channel: event.channel, text: "So _#{ contact.name }_ is a man. I've updated that. ", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "What is his email? ", as_user: true)


      elsif event.formatted_text.starts_with? "female"

        contact = Contact.all.last
        contact.gender = "female"
        contact.save!

        client.chat_postMessage(channel: event.channel, text: "So _#{ contact.name }_ is a woman. I've updated that. ", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "What is her email? ", as_user: true)


      elsif is_email_address event.formatted_text

        contact = Contact.all.last
        contact.email = event.formatted_text
        contact.save!

        client.chat_postMessage(channel: event.channel, text: "I've associated the email `#{contact.email}` with _#{ contact.name }_. ", as_user: true)

        if contact.gender == "male"
          client.chat_postMessage(channel: event.channel, text: "What's his phone number? ", as_user: true)
        else
          client.chat_postMessage(channel: event.channel, text: "What's her phone number? ", as_user: true)
        end

       #  if event.formatted_text.is_a? Integer
      #        # if formatted_number { |b| event.formatted_text b }
      #
      #   contact = Contact.all.last
      #   contact.phone = event.formatted_text  #.convert_to_phone.format_phone
      #   contact.save!
      #
      #   client.chat_postMessage(channel: event.channel, text: "I've updated _#{ contact.name }_'s phone number as #{contact.phone}.", as_user: true)
      # end
      # add additional commands here...
      
      else
        # ERROR Commands
        # not understood or an error
        client.chat_postMessage(channel: event.channel, text: "I didn't get that. If you're stuck, type `help` to find my commands.", as_user: true)

      end

    end


    # ------------------------------------------------------------------------
    # =>   GETS USEFUL INFO FROM SLACK
    # ------------------------------------------------------------------------
# class String  # I don't really know how to use class
#     def convert_to_phone
#        number = self.gsub(/\D/, '').split(//)
#        #US 11-digit numbers
#        number = number.drop(1) if (number.count == 11 && number[0] == 1)
#        #US 10-digit numbers
#        number.to_s if (number.count == 10)
#      end
#      def format_phone
#        return "#{self[0,3]}-#{self[3,3]}-#{self[6,4]}"
#      end
#    end
    # def format_number(number)
    #     digits = number.gsub(/\D/, '').split(//)
    #
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

    def is_email_address str
      return str.match(/[a-zA-Z0-9._%]@(?:[a-zA-Z0-9]+\.)[a-zA-Z]{2,4}/)
    end

    def get_user_name client, event
      # calls users_info on slack
      info = client.users_info(user: event.user_id )
      info['user']['name']
    end

    def is_admin_or_owner client, event
      # calls users_info on slack
      info = client.users_info(user: event.user_id )
      info['user']['is_admin'] || info['user']['is_owner']
    end

  end

end