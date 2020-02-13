ruleset temperature_store {
  meta {
    shares __testing
    provides temperatures, threshold_violations, inrange_temperatures
    shares temperatures, threshold_violations, inrange_temperatures
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
    emptyset={}
    emptyarray=[]
    temperatures=function(){
      return ent:temps
    }
    threshold_violations=function(){
      return ent:threshold_temps
    }
    inrange_temperatures=function(){
      t=ent:temps
      tt=ent:threshold_temps
      a=t.filter(function(x){not (tt><x)})
      return a
    }
    
   }
  
  rule collect_temperatures{
    select when wovyn new_temperature_reading
    pre{
      temp=event:attr("temperature")
      times=event:attr("timestamp")
    }
    send_directive("say",{"something":"directives from collect temperatures"})
    always{
       ent:temps:=ent:temps.append({"timestamp":times,"temperature":temp})
       //ent:temps{times}:=temp
    }
  }
  rule collect_threshold_violations{
    select when wovyn threshold_violation
    pre{
      temp=event:attr("temperature")
      time=event:attr("timestamp")
    }
    send_directive("say",{"something":"directives from collect threshold violations"})
    always{
      ent:threshold_temps:=ent:threshold_temps.append({"timestamp":time,"temperature":temp})
    }
  }
  rule clear_temperatures{
    select when sensor reading_reset
    
    send_directive("say",{"something":"directives from clear temperatures"})
    always{
      ent:temps:=emptyarray
      ent:threshold_temps:=emptyarray
    }
  }
  
}
