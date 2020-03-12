// click on a ruleset name to see its source here

ruleset twilio {
  meta {
    name "help"
    description <<
helper functions
>>
    use module twilio_keys
    provides send_sms, messages
  }
  global {
    account_sid=twilio_keys:account_sid;
    auth_token=twilio_keys:auth_token;
    send_sms = defaction(to, from, message){
      base_url = <<https://#{twilio_keys:account_sid}:#{twilio_keys:auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
      http:post(base_url + "Messages.json", form =
                {"From":from,
                 "To":to,
                 "Body":message
                })
    }
    
    messages=function(to, from, pagination,num_of_texts){
       base_url = <<https://#{twilio_keys:account_sid}:#{twilio_keys:auth_token}@api.twilio.com/2010-04-01/Accounts/#{twilio_keys:account_sid}/>>
       s = {}.put("To", to => to | null).put("From", from => from | null)
       a=http:get(base_url + "Messages.json",qs=s).klog()
    
      return a
    }
    
  }
}