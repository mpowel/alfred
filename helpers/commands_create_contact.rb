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
        client.chat_postMessage(channel: event.channel, text: "I'm Alfred, your personal contact management bot. I can keep track of your important contacts. You can 'view' your list of contacts or 'add' someone new. Would you like to create a new contact? Type 'yes' or 'not now'.", as_user: true)
        return true
        
      elsif event.formatted_text == "yes"
              client.chat_postMessage(channel: event.channel, text: "Who would you like to add? Type `add [name]` and I'll add them for you.", as_user: true)
              return true
      elsif event.formatted_text == "not now"
              client.chat_postMessage(channel: event.channel, text: "Ok, maybe later. You can type 'help' to see what else I can help with.", as_user: true)
        return true

      # Add New Commands 
      elsif event.formatted_text == "add"
        client.chat_postMessage(channel: event.channel, text: "Who would you like to add? Type `add [name]` and I'll add them for you.", as_user: true)

        return true
        
      elsif event.formatted_text.starts_with? "add"
        contact_name = event.formatted_text.gsub( "add", "" ).strip
        contact = Contact.create(team_id: event.team_id, name: contact_name )
        contact.save

        client.chat_postMessage(channel: event.channel, text: "I've added _#{ contact.name }_ for you. ", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "What is _#{ contact.name }_'s gender? Are the a `male` or a `female`. ", as_user: true)

        return true

      # Gender Commands  
      elsif event.formatted_text.starts_with? "male"

        contact = Contact.all.last
        contact.gender = "male"
        contact.save!

        client.chat_postMessage(channel: event.channel, text: "So _#{ contact.name }_ is a man. I've updated that. ", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "What is his email? ", as_user: true)

        return true
        
      elsif event.formatted_text.starts_with? "female"

        contact = Contact.all.last
        contact.gender = "female"
        contact.save!

        client.chat_postMessage(channel: event.channel, text: "So _#{ contact.name }_ is a woman. I've updated that. ", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "What is her email? ", as_user: true)

        return true
        
      # Email Commands     
      elsif is_email_address event.formatted_text

        contact = Contact.all.last
        contact.email = event.formatted_text
        contact.save!

        client.chat_postMessage(channel: event.channel, text: "I've associated the email `#{contact.email}` with _#{ contact.name }_. ", as_user: true)
        
        if contact.gender == "male"
          client.chat_postMessage(channel: event.channel, text: "What's his phone number? Type 'phone' followed by the 10 digit number.", as_user: true)
        else
          client.chat_postMessage(channel: event.channel, text: "What's her phone number? Type 'phone' followed by the 10 digit number.", as_user: true)
        end
        return true

        # Phone Commands 
        elsif event.formatted_text.starts_with? "phone"
          contact_number = event.formatted_text.gsub( "phone", "" ).strip  
          
          contact = Contact.all.last
          contact.phone = contact_number.to_i
          contact.save!

          client.chat_postMessage(channel: event.channel, text: "I've updated _#{ contact.name }_'s phone number as #{contact.phone}.", as_user: true)
          client.chat_postMessage(channel: event.channel, text: "What would you like to do next? To view your contacts, type 'view'. To add another contact, type 'add' and then the first and last name.", as_user: true)
          return true
#         # add additional commands here...
      
      else
        client.chat_postMessage(channel: event.channel, text: "I didn't get that. If you're stuck, type `help` to find my commands.", as_user: true)
       return true
      end

    end



    # ------------------------------------------------------------------------
    # =>   GETS USEFUL INFO FROM SLACK
    # ------------------------------------------------------------------------

  
    # def is_phone_number int
    #   return int.match( ((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4} )
    # end
  
    
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



