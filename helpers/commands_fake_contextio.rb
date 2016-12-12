module Sinatra
  module CommandsFakeContextio
  
    # ------------------------------------------------------------------------
    # =>   MAPS THE CURRENT EVENT TO AN ACTION
    # ------------------------------------------------------------------------
    
    def fake_contextio client, event
      
      puts event
      puts "Formatted Text: #{event.formatted_text}"
      
      return if event.formatted_text.nil?
      
      is_admin = is_admin_or_owner client, event
        
      if event.formatted_text.starts_with? "when"     #simulates a response to "When was the last time I contacted Alfred Pennyworth"
         client.chat_postMessage(channel: event.channel, text: "You last contacted Alfred on December 11. He has yet to respond. Type 'email' to email him now or you can ask me another question.", as_user: true)
       return true

      elsif event.formatted_text.starts_with? "how"   #simulates a response to "How long has it been since I contacted Jeeves"
          client.chat_postMessage(channel: event.channel, text: "It's been 1 day since you contacted Jeeves. His average response rate is every 3 days. Type 'set reminder' and I'll remind you to email him in 2 days.", as_user: true)
        return true
        
      elsif event.formatted_text.starts_with? "set"   #simulates a response to "set reminder"
          client.chat_postMessage(channel: event.channel, text: "Very well. I'll remind you to email Jeeves in 2 days", as_user: true)
          client.chat_postMessage(channel: event.channel, text: "You mentioned once he can be quite ornary, so be sure to use pleasantries.", as_user: true)
          client.chat_postMessage(channel: event.channel, text: "Anything else I can do for you today? If not, just say 'bye' and I'll leave you in peace.", as_user: true)
        return true
         

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