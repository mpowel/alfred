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
        client.chat_postMessage(channel: event.channel, text: "Hi I'm A Bot. I'm here to help.", as_user: true)

        # Handle the Help commands
      elsif event.formatted_text.include? "help"
        client.chat_postMessage(channel: event.channel, text: "I can do `x`, `y` and `z`", as_user: true)

      elsif event.formatted_text.starts_with? "thank"
        client.chat_postMessage(channel: event.channel, text: "You're very welcome.", as_user: true)

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