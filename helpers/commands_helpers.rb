module Sinatra
  module CommandsHelper
  
    # ------------------------------------------------------------------------
    # =>   MAPS THE CURRENT EVENT TO AN ACTION
    # ------------------------------------------------------------------------
    
    def event_to_action client, event
      
      puts event
      puts "Formatted Text: #{event.formatted_text}"
      
      return if event.formatted_text.nil?
      
      is_admin = is_admin_or_owner client, event
        
      # Hi Commands
      if ["hi", "hey", "hello"].any? { |w| event.formatted_text.starts_with? w }
        client.chat_postMessage(channel: event.channel, text: "I'm Alfred, your personal contact management bot. I can store contacts in my database and soon will be able to track any interaction with the email account etanproject.org@gmail.com. Would you like to create a new contact? Type 'yes' or no'.", as_user: true)

        # Handle the Help commands
      elsif event.formatted_text.include? "help"
        client.chat_postMessage(channel: event.channel, text: "I can store contacts in my database and soon will be able to track interactions with the email account etanproject.org@gmail.com. Would you like to create a new contact? Type 'yes' or no'.", as_user: true)
        
            # if event.formatted_text == "yes"
            #   client.chat_postMessage(channel: event.channel, text: "Who would you like to add? Type `add [name]` and i'll add them for you.", as_user: true)
            #
            # elsif event.formatted_text == "no"
            #   client.chat_postMessage(channel: event.channel, text: "Ok, maybe later. Type “View Contacts” to see a list of existing contacts, otherwise I’ll come back later.", as_user: true)
              
      elsif event.formatted_text.starts_with? "thank"
        client.chat_postMessage(channel: event.channel, text: "You're very welcome.", as_user: true)

      elsif event.formatted_text == "add"
        client.chat_postMessage(channel: event.channel, text: "Who would you like to add? Type `add [name]` and I'll add them for you."
        , as_user: true)
        
      elsif event.formatted_text.starts_with? "add"
        
        # assuming we get something like this: 
        # add joe bloggs
        
        contact_name = event.formatted_text.gsub( "add", "" ).strip
        # i've removeed the add prefix and cleaned up the string
        # i now have a formatted name 
        
        # i'm creating a new object in my database with two pieces of info 
        contact = Contact.create( team_id: event.team_id, name: contact_name )
        #...
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
      #   ... 
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