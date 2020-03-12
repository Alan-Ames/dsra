// click on a ruleset name to see its source here

ruleset helper {
  meta {
    name "help"
    description <<
helper functions
>>
    use module twilio_keys
  }
  global {
    send_sms = defaction(to, from, message, account_sid, auth_token){
      base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
        http:post(base_url + "Messages.json", form =
                {"From":from,
                 "To":to,
                 "Body":message
                })
    }
  }
}