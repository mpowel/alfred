# module Sinatra
#   module CommandsEditContact
#
#     # ------------------------------------------------------------------------
#     # =>   MAPS THE CURRENT EVENT TO AN ACTION
#     # ------------------------------------------------------------------------
#
#     def view_and_edit client, event   #try changing this to a new definition
#
#       puts event
#       puts "Formatted Text: #{event.formatted_text}"
#
#       return if event.formatted_text.nil?
#
#       is_admin = is_admin_or_owner client, event
#
#
#       # View contacts
#       if event.formatted_text.starts_with? "view"
#            # print the list
#            all_contacts = Contact.all
#            contact_list = ""
#            all_contacts.each_with_index do |item, index|
#            contact_list += "#{ index+ 1 }. #{ contact.name } \n"
#            end
#            # client.chat_postMessage(channel: event.channel, text: "*Your grocery list :*\n" + grocery_list  , as_user: true )
#            client.chat_postMessage(channel: event.channel, text: "Here are all your contacts." + contact_list  , as_user: true )
#            # client.chat_postMessage(channel: event.channel, text: "Type 'update [number] to edit an existing contact or `add [name]` to add a new contact.", as_user: true)
#          end
#
#       end
#
#     end
#
#       # if event.formatted_text.include? == "view contacts"
#       #   contact = Contact.all.last
#       #   view_contact = contact.find_by(id: contact.id, )
#       #
#       #   client.chat_postMessage(channel: event.channel, text: "Here are all your contacts. Type 'update [contact_id] to edit an existing contact or `add [name]` to add a new contact.", as_user: true)
#       #      ####### How do I display the table in slack? Still looking into this.  #######
#       #      #  Starting to format a table:  %p %p #{Contact.all.contact_id}
#       #
#       #      # Updating existing contact
#       # elsif event.formatted_text.include? == "update #{contact.contact_id}"  #can I have a variable like this?
#       #   contact = Contact.contact_id
#       #   client.chat_postMessage(channel: event.channel, text: "Sure thing! I'd be happy to update #{contact.name}. Type 'update name' 'update email' 'update gender' 'update phone' or 'delete contact'.", as_user: true)
#       #
#       # elsif event.formatted_text == "update name"
#       #      # Look up existing contact based on the provided id
#       #   contact = Contact.contact_id
#       #   contact.name = event.formatted_text.gsub( "add", "" ).strip
#       #   contact.save!
#       #
#       # elsif event.formatted_text == "update email"
#       #
#       #      ####### How do I delete a contact?
#       #
#
#
#
#     # ------------------------------------------------------------------------
#     # =>   GETS USEFUL INFO FROM SLACK
#     # ------------------------------------------------------------------------
#
#     def is_email_address str
#       return str.match(/[a-zA-Z0-9._%]@(?:[a-zA-Z0-9]+\.)[a-zA-Z]{2,4}/)
#     end
#
#     def get_user_name client, event
#       # calls users_info on slack
#       info = client.users_info(user: event.user_id )
#       info['user']['name']
#     end
#
#     def is_admin_or_owner client, event
#       # calls users_info on slack
#       info = client.users_info(user: event.user_id )
#       info['user']['is_admin'] || info['user']['is_owner']
#     end
#
#   end
#
# end








# ------------------------------------------------------------------------
# =>   SET UP / DUMMY TEXT
# ------------------------------------------------------------------------
#
# def you_always_do_this client, event   #try changing this to a new definition
#
#   puts event
#   puts "Formatted Text: #{event.formatted_text}"
#
#   return if event.formatted_text.nil?
#
#   is_admin = is_admin_or_owner client, event
#     if ["you", "always"].any? { |z| event.formatted_text.starts_with? z }  #try using another letter besides w
#       client.chat_postMessage(channel: event.channel, text: "No no no!", as_user: true)
#
#     elsif event.formatted_text.include? "hate"
#       client.chat_postMessage(channel: event.channel, text: "No no no!", as_user: true)
#
#     # else
# #       # ERROR Commands
# #       # not understood or an error
# #       client.chat_postMessage(channel: event.channel, text: "I didn't get that. If you're stuck, type `help` to find my commands.", as_user: true)
# #
#     end