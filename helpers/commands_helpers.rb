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
  
      elsif ["dismiss", "dismissed", "bye", "goodbye", "good bye"].any? { |gb| event.formatted_text.starts_with? gb }   
        #event.formatted_text.include? "bye"
          client.chat_postMessage(channel: event.channel, text: good_bye, as_user: true)
        return true

        elsif event.formatted_text.include? "mother"
          client.chat_postMessage(channel: event.channel, text: get_image, as_user: true)
#           client.chat_postMessage(channel: event.channel, text: "http://www2.pictures.zimbio.com/mp/GWnfFL2ID3Fl.jpg", unfurl_link: true, as_user: true)
           client.chat_postMessage(channel: event.channel, text: "Oh nothing... I said nothing. Bye now!", as_user: true)
        # client.chat_postMessage(channel: event.channel, text: "You're very welcome.", as_user: true)
         return true

      else
       return false
      end
      
    end


    # ------------------------------------------------------------------------
    # =>   GETS USEFUL INFO FROM SLACK
    # ------------------------------------------------------------------------

    def get_image
      {
          "attachments": [
              {
                  "fallback": "Alex Trabek and Sean Connery.",
                  "color": "#36a64f",
                  "pretext": "",
                  "author_name": "Trabek",
                  "text": "",
                  "image_url": "http://www2.pictures.zimbio.com/mp/GWnfFL2ID3Fl.jpg",
                  "ts": 123456789
              }
          ]
      }.to_json
    end

    THANKS = ["You’re quite welcome.", "My pleasure.", "Happy to help.", "Anytime.", "That’s what I’m here for."]
    
    def get_thanks
        return THANKS.sample
    end
    
    TOODLES = ["Cheerio.", "Tata for now.", "Hasta la vista, baby", "Take care, dollface. Send your mother my regards."]
    
    def good_bye
        return TOODLES.sample
    end

    # BYE = ["Adios motha sucka.", "Cheerio.", "Farewell then.", "Ciao bella.", "Toodles!", "Tata for now, sweetheart.","Hasta la vista, baby", "Take care, dollface. Send your mother my regards."]
        
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
# =>   CODE NOT USED
# ------------------------------------------------------------------------

# elsif event.formatted_text.starts_with? "team"
#   team_list = Contact.all
#   show_teams = ""
#   team_list.each_with_index do |i, index|
#   show_teams += "#{ index+ 1 }. #{ i.team_id } \n"
#   end
#
#   client.chat_postMessage(channel: event.channel, text: show_teams , as_user: true)
#  # client.chat_postMessage(channel: event.channel, text: "You're very welcome.", as_user: true)
#   return true
  
  #Later I want to add  "and soon will be able to track interactions with the email account etanproject.org@gmail.com"

# # add additional commands here...
                       
# else
#   # ERROR Commands
#   # not understood or an error
#   client.chat_postMessage(channel: event.channel, text: "I didn't get that. If you're stuck, type `help` to find my commands.", as_user: true)
#