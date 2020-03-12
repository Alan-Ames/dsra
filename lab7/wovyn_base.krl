ruleset wovyn_base {
  meta {
    shares __testing
    use module sensor_profile
    use module io.picolabs.subscription alias Subscriptions
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
    //temperature_threshold=72.4
  }
  rule process_heartbeat{
    select when wovyn heartbeat
    pre{
      genericThing=event:attr("genericThing").defaultsTo(null).klog("yeah!!!!!!!")
      
      d=genericThing["data"].klog("got data")
      tt=d["temperature"].klog("tt")
      ttt=tt[0].klog("ttt")
      temperature=ttt["temperatureF"].klog("t")
      times=time:now().klog("time")
    }
    if(genericThing) then 
      send_directive("say",{"something":"directives from process"})
    fired{
      raise wovyn event "new_temperature_reading"
       attributes { "temperature": temperature, "timestamp": times }
    }
  }
  rule find_high_temps{
    select when wovyn new_temperature_reading
    pre{
      temperature=event:attr("temperature")
      timestamp=event:attr("timestamp")
      threshold=sensor_profile:profile()["threshold"].klog("threshold is")
      
      message=(temperature<threshold=>"violation NOT raised"|"Violation Raised")
      raised=(temperature<threshold=>false|true)
    }
      send_directive("say",{"something":message})
      always{
        raise wovyn event "threshold_violation" 
          attributes { "temperature": temperature, "timestamp": timestamp } if raised
      }
  }
  rule threshold_notification{
    select when wovyn threshold_violation
    pre{
      bob="bob".klog("threshold_notif pre")
      v=Subscriptions:established("Tx_role","sensor")[0]["Tx"].klog("manager eci")
    }
    event:send(
      { "eci": v, "eid": "subscription",
        "domain": "wovyn", "type": "threshold_violation",
        "attrs": { "name": "no name"} } )
    //send_directive("say",{"something":"threshold_notification directives"})
    // always{
    //   raise text event "send"
    //     attributes{"message":"threashold temperature violation"}
    // }
  }
}
