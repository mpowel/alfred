module Sinatra
  module CommandsEditContact
  
    # ------------------------------------------------------------------------
    # =>   MAPS THE CURRENT EVENT TO AN ACTION
    # ------------------------------------------------------------------------
    
    def event_to_action client, event
      
      puts event
      puts "Formatted Text: #{event.formatted_text}"
      
      return if event.formatted_text.nil?
      
      is_admin = is_admin_or_owner client, event
      
      
      if ["you", "always", "hate"].any? { |w| event.formatted_text.starts_with? w }
        client.chat_postMessage(channel: event.channel, text: "No no no!", as_user: true)
        
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









# ------------------------------------------------------------------------
# =>   VIEW CONTACTS
# ------------------------------------------------------------------------


# # View contacts
#      elsif event.formatted_text.include? == "view contacts"
#              contact = Contact.all
#              client.chat_postMessage(channel: event.channel, text: "Here are all your contacts. Type 'update [contact_id] to edit an existing contact or `add [name]` to add a new contact.", as_user: true)
#      ####### How do I display the table in slack? Still looking into this.  #######
#      #  Starting to format a table:  %p %p #{Contact.all.contact_id}
#
#      # Updating existing contact
#      elsif event.formatted_text.include? == "update #{contact.contact_id}"
#            client.chat_postMessage(channel: event.channel, text: "Sure thing! I'd be happy to update #{contact.name}. What would you like to edit first? Type 'update name' 'update email' 'update gender' 'update phone' or 'delete contact'.", as_user: true)
#
#      elsif event.formatted_text == "update name"
#      # Look up existing contact based on the provided id
#            contact = Contact.contact_id
#      # store name
#            contact.name = event.formatted_text.gsub( "add", "" ).strip
#            contact.save!
#
#      elsif event.formatted_text == "update email"
#
#      ####### How do I delete a contact?
#