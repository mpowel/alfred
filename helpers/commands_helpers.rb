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
        
      if event.formatted_text.starts_with? "thank"
         client.chat_postMessage(channel: event.channel, text: get_thanks, as_user: true)
      # client.chat_postMessage(channel: event.channel, text: "You're very welcome.", as_user: true)
       return true

      elsif event.formatted_text.starts_with? "team"
          client.chat_postMessage(channel: event.channel, text: "#{contact.team_id}" , as_user: true)
       # client.chat_postMessage(channel: event.channel, text: "You're very welcome.", as_user: true)
        return true

#Later I want to add  "and soon will be able to track interactions with the email account etanproject.org@gmail.com"

      # # add additional commands here...
                             
      # else
      #   # ERROR Commands
      #   # not understood or an error
      #   client.chat_postMessage(channel: event.channel, text: "I didn't get that. If you're stuck, type `help` to find my commands.", as_user: true)
      #
      else
       return false
      end
      
    end


    # ------------------------------------------------------------------------
    # =>   GETS USEFUL INFO FROM SLACK
    # ------------------------------------------------------------------------
    
    THANKS = ["You’re quite welcome.", "My pleasure.", "Happy to help.", "Anytime.", "That’s what I’m here for."]

    def get_thanks
        return THANKS.sample
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