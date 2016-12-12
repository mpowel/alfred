module Sinatra
  module CommandsEditContact

    # ------------------------------------------------------------------------
    # =>   MAPS THE CURRENT EVENT TO AN ACTION
    # ------------------------------------------------------------------------

    def view_and_edit client, event   #try changing this to a new definition

      puts event
      puts "Formatted Text: #{event.formatted_text}"

      return if event.formatted_text.nil?

      is_admin = is_admin_or_owner client, event

      if event.formatted_text.include? "help"
        client.chat_postMessage(channel: event.channel, text: "Nobody can help you now.", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "Just kidding! Try typing `add`, `view`, or `when did I last contact Alfred?`.", as_user: true)
        client.chat_postMessage(channel: event.channel, text: "If you've had enough of me, you can also `dismiss` me.", as_user: true)

       return true


     # View contacts
      elsif event.formatted_text.starts_with? "view"
     # print the list
            contact_list = Contact.all
            contact = ""
            contact_list.each_with_index do |item, index|
            contact += "#{ index+ 1 }. #{ item.name } \n"
            end
            
            client.chat_postMessage(channel: event.channel, text: "Here are all your contacts.\n" + contact  , as_user: true )
            client.chat_postMessage(channel: event.channel, text: "Type `delete contact` followed by a number to delete a contact from this list.\n"  , as_user: true )
       
        return true
        
    # Delete specific item
        elsif event.formatted_text.starts_with? "delete contact"
              contact_id = event.formatted_text.gsub( "delete contact", "" ).strip
              input_index = contact_id.to_i - 1
              all_contacts = Contact.order(:id)
              all_contacts[input_index].destroy
                
              client.chat_postMessage(channel: event.channel, text: "I have deleted #{all_contacts[input_index].name}. Type 'add' to create a new contact", as_user: true )
        return true

     # Delete all
     elsif event.formatted_text == "delete all"
         client.chat_postMessage(channel: event.channel, text: "Are you sure you want to delete all contacts? Type `yes delete all` to delete your entire contact list. Type `nooo` to cancel", as_user: true)

       return true
       
     elsif event.formatted_text == "yes delete all"
       Contact.destroy_all
       #create one step that's a warning and prompts yes
       client.chat_postMessage(channel: event.channel, text: "I have deleted your entire list of contacts.", as_user: true)

       return true

     elsif ["nooo", "no", "noo"].any? { |n| event.formatted_text.starts_with? n }   
       #event.formatted_text == "nooo"
         client.chat_postMessage(channel: event.channel, text: "Phew, that was a close one. Your database was left intact", as_user: true)

       return true


     #
     #  # Edit specific item

     else
       return false
     
         end
     
       
    end


    # ------------------------------------------------------------------------
    # =>   GETS USEFUL INFO FROM SLACK
    # ------------------------------------------------------------------------

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
 # =>   NOTES FROM ELIJAH ON ENABLING SESSIONS
 # ------------------------------------------------------------------------
 
    # session variable set to nil?
    # set session variable to editing mode
    # set session variable at end of elsif block, then it can be reused.
    
    # ------------------------------------------------------------------------
    # =>   SWARNA'S CODE
    # ------------------------------------------------------------------------
    
  # elsif event.formatted_text.starts_with? "edit"
  #   # we want to take the edit part away
  #   # and then the rest we want to use for editing
  #   input  = event.formatted_text.gsub( "edit", "" ).strip
  #   input_words = input.split
  #   input_index = input_words[0].to_i - 1
  #   input_words.shift
  #   input_words.shift
  #   grocery_string = input_words.join(" ")
  #   all_items = GroceryList.order(:id)
  #   all_items[input_index].item_name = grocery_string
  #   all_items[input_index].save
  #   #display edited list
  #   grocery_list = ""
  #   edited_list = GroceryList.order(:id)
  #   edited_list.each_with_index do |item, index|
  #   grocery_list += "#{ index+ 1 }. #{ item.item_name } \n"
  #   end
  #   client.chat_postMessage(channel: event.channel, text: "\nSure, I made the edit! *Your grocery list now looks like this:*\n" + grocery_list  , as_user: true )
  #
  # return true
  
  # ------------------------------------------------------------------------
  # =>   SWARNA'S CODE
  # ------------------------------------------------------------------------
  
#client.chat_postMessage(channel: event.channel, text: "You can also delete the entire list of contacts by typing `delete all`.", as_user: true)

# ------------------------------------------------------------------------
# =>   FAILED EDIT ATTEMPT
# ------------------------------------------------------------------------


       # client.chat_postMessage(channel: event.channel, text: "To edit a contact type something similar to: edit 1 change email to test@example.com. You can edit the 'name', 'email', 'gender', and 'phone'", as_user: true)
#client.chat_postMessage(channel: event.channel, text: "or you can type `add' followed by first and last name to add a new contact.", as_user: true)
      # client.chat_postMessage(channel: event.channel, text: "Who and what would you like to edit? To edit the first person's email type 'edit 1 change email to test@example.com'. You can edit the 'name', 'email', 'gender', and 'phone'", as_user: true)
      
      
       # elsif event.formatted_text == "edit"
       #   client.chat_postMessage(channel: event.channel, text: "I'd be happy to edit a contact. Type 'view' to see a complete list of contacts.", as_user: true)
       #   client.chat_postMessage(channel: event.channel, text: "Or if you already know the contact you'd like to update, type 'update contact' number then 'name', 'email', 'gender', or 'phone' followed by the new information.", as_user: true)
       #   client.chat_postMessage(channel: event.channel, text: "For example: 'Update contact 1 name with Alfred Botler'", as_user: true)
       #   return true
         
       # elsif event.formatted_text.starts_with? "edit"
       #   contact_id = event.formatted_text.gsub( "edit", "" ).strip
       #   input_index = contact_id.to_i - 1            #may need to be in parentheses (contact_id.to_i) - 1
       #   all_contacts = Contact.order(:id)
       #
       #   client.chat_postMessage(channel: event.channel, text: "I'd be happy to edit _#{all_contacts[input_index].name }_. Here's what I have stored\n Name: #{all_contacts[input_index].name }\n Gender: #{all_contacts[input_index].gender }\n Email: #{all_contacts[input_index].email }\n Phone: #{all_contacts[input_index].phone }\n", as_user: true)
       #   client.chat_postMessage(channel: event.channel, text: "Type 'update' then 'name', 'email', 'gender', or 'phone' followed by 'for contact' number the new information.", as_user: true)
       #   client.chat_postMessage(channel: event.channel, text: "For example: 'Update name for contact 1 with Alfred Botler'", as_user: true)
       #
       #   return true
       #
       #   all_items = GroceryList.order(:id)
       #   all_items[input_index].item_name = grocery_string  #item_name is a variable from the table, this updates that line item.
       #          #   all_items[input_index].save
       #
       # elsif event.formatted_text.include? "update name"
       #   contact_name = event.formatted_text.gsub( "name", "" ).strip
       #   # contact = Contact.create(team_id: event.team_id, name: contact_name )
       #   contact.save
       #
       #   client.chat_postMessage(channel: event.channel, text: "I've updated your contact name to #{ contact.name }. ", as_user: true)

       # elsif event.formatted_text.starts_with? "gender"
#          contact_gender = event.formatted_text.gsub( "add", "" ).strip
#          contact = Contact.create(team_id: event.team_id, name: contact_name )
#          contact.save
#
#          client.chat_postMessage(channel: event.channel, text: "I've added _#{ contact.name }_ for you. ", as_user: true)

       # elsif event.formatted_text.starts_with? "email"
       #   contact_email = event.formatted_text.gsub( "add", "" ).strip
       #   contact = Contact.create(team_id: event.team_id, name: contact_name )
       #   contact.save
       #
       #   client.chat_postMessage(channel: event.channel, text: "I've added _#{ contact.name }_ for you. ", as_user: true)

       # elsif event.formatted_text.starts_with? "phone"
       #   contact_phone = event.formatted_text.gsub( "add", "" ).strip
       #   contact = Contact.create(team_id: event.team_id, name: contact_name )
       #   contact.save
       #
       #   client.chat_postMessage(channel: event.channel, text: "I've added _#{ contact.name }_ for you. ", as_user: true)


       # ------------------------------------------------------------------------
       # =>   NOT NEEDED - MERGING WITH EDIT STEP
       # ------------------------------------------------------------------------
           
     # elsif event.formatted_text.starts_with? "update"
    #    contact_id = event.formatted_text.gsub( "update", "" ).strip
    #    input_index = contact_id[0].to_i - 1
    #    all_contacts = Contact.order(:id)
    #    # print the list
    #           # contact_list = Contact.all
    #           # contact = ""
    #           # contact_list.each_with_index do |item, index|
    #           # contact += "#{ index+ 1 }. #{ item.name } \n"
    #           # end
    #
    #    client.chat_postMessage(channel: event.channel, text: "I'd be happy to update _#{all_contacts[input_index].name }_.*\n Here's what I have stored*\n Name: _#{all_contacts[input_index].name }_*\n Gender: _#{all_contacts[input_index].gender }_*\n Email: _#{all_contacts[input_index].email }_*\n Phone: _#{all_contacts[input_index].phone }_*\n", as_user: true)
    #    client.chat_postMessage(channel: event.channel, text: "Type 'name', 'email', 'gender', or 'phone' followed by the new information and I'll make changes.", as_user: true)
    #    return true


# ------------------------------------------------------------------------
# =>   PSEUDO CODE
# ------------------------------------------------------------------------


# if event.formatted_text.include? == "view contacts"
#   contact = Contact.all.last
#   view_contact = contact.find_by(id: contact.id, )
#
#   client.chat_postMessage(channel: event.channel, text: "Here are all your contacts. Type 'update [contact_id] to edit an existing contact or `add [name]` to add a new contact.", as_user: true)
#      ####### How do I display the table in slack? Still looking into this.  #######
#      #  Starting to format a table:  %p %p #{Contact.all.contact_id}
#
#      # Updating existing contact
# elsif event.formatted_text.include? == "update #{contact.contact_id}"  #can I have a variable like this?
#   contact = Contact.contact_id
#   client.chat_postMessage(channel: event.channel, text: "Sure thing! I'd be happy to update #{contact.name}. Type 'update name' 'update email' 'update gender' 'update phone' or 'delete contact'.", as_user: true)
#
# elsif event.formatted_text == "update name"
#      # Look up existing contact based on the provided id
#   contact = Contact.contact_id
#   contact.name = event.formatted_text.gsub( "add", "" ).strip
#   contact.save!
#
# elsif event.formatted_text == "update email"
#
#      ####### How do I delete a contact?
#

