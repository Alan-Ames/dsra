ruleset twilio_send {
  meta {
    shares __testing
    use module twilio_keys 
    use module twilio
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      //, { "name": "entry", "args": [ "key" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    myphone=+16053509672
    twiliophone=+12028662256
  }
  rule send_text{
    select when text send
    twilio:send_sms(myphone,+12028662256,"i ate cheese for breakfast")
    //send_directive("say", {"something": "Hello World"})
    
  }
  rule mess{
    select when text recieve
    pre{
      to=event:attr("to")//.defaultsTo(+12028662256)
      from=event:attr("from")//.defaultsTo(+16053509672)
      //   base_url = <<https://#{twilio_keys:account_sid}:#{twilio_keys:auth_token}@api.twilio.com/2010-04-01/Accounts/#{twilio_keys:account_sid}/>>
       
      // a=http:get(base_url + "Messages.json",qs={"To":to,"From":from} ).klog()
       //,qs={"To":to,"From":from}
      a=twilio:messages(to,from)
    }
    //("say", {"something": "Hello World"})
    //twilio:messages(+16053509672,+12028662256,null,null)
   
      send_directive("say",a)
  }
}
