ruleset sensor_profile {
  meta {
    shares __testing
    provides profile
    shares profile
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
    profile=function(){
      return {"name":ent:name,"phone":ent:phone,"location": ent:location,"threshold": ent:threshold }
    }
        //return {"name": ent:name,"phone":ent:phone,"location": ent:location,"threshold": ent:threshold }
  }
  rule update_profile_updated{
    select when sensor profile_updated
    pre{
      ename=event:attr("name").defaultsTo(ent:name)
      ephone=event:attr("phone").defaultsTo(ent:phone)
      elocation=event:attr("location").defaultsTo(ent:location)
      ethreshold=event:attr("threshold").defaultsTo(ent:threshold)
      
    }
     send_directive("say",{"something":"directives from collect temperatures"})
     always{
       ent:name:=ename
       ent:phone:=ephone
       ent:location:=elocation
       ent:threshold:=ethreshold
     }
  }
}
