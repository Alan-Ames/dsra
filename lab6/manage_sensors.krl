ruleset manage_sensors {
  meta {
    shares __testing
    use module io.picolabs.wrangler alias wrangler
    provides  sensors
    shares sensors
    shares temperatures
  }
  global {
    // __testing = { "queries":
    //   [ { "name": "__testing" }
    //   //, { "name": "entry", "args": [ "key" ] }
    //   ] , "events":
    //   [ //{ "domain": "d1", "type": "t1" }
    //   //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
    //   ]
    // }
    __tesing={"events":[{"domain":"sensor","type":"new_sensor","attrs":["name"]}]}
    // showChildren = function() {
    //   wrangler:children()
    // }
    sensors=function(){
      return ent:sensors
    }
    temperatures=function(){
      v=ent:sensors.values()
      temps=v.reduce( function(a,b){a.append(wrangler:skyQuery(b,"temperature_store","temperatures",null))} ,[])
      return temps
    }
    threshold=78
    
  }
  rule sensor_exists{
    select when sensor new_sensor
    pre{
      sensor_name=event:attr("name")
      exists=ent:sensors><sensor_name;
    }
    if exists then
      send_directive("sensor_ready",{"name":sensor_name})
  }
  
  rule sensor_doesnt_exist{
    select when sensor new_sensor
    pre{
      sensor_name=event:attr("name")
      exists=ent:sensors><sensor_name;
    }
    if not exists then
      noop()
    fired{
        raise wrangler event "child_creation"
          attributes {"name":sensor_name,"rids":["temperature_store","wovyn_base","sensor_profile"]}
    }
  }
  rule collection_empty {
    select when sensor clear
    always {
      ent:sensors := {}
    }
  }
  rule store_new_sensor {
    select when wrangler child_initialized
    pre {
      the_sensor_eci = event:attr("eci")//{"id": event:attr("id"), "eci": event:attr("eci")}
      name = event:attr("name")
    }
    if name.klog("found section_id")
    then
      noop();
      // event:send(
      // { "eci": the_sensor_eci, "eid": "install-ruleset",
      //   "domain": "wrangler", "type": "install_rulesets_requested",
      //   "attrs": { "rids": ["temperature_store","wovyn_base","sensor_profile" } } )
    fired {
      ent:sensors := ent:sensors.defaultsTo({});
      ent:sensors{[name]} := the_sensor_eci
    }
  }
  rule manager_update_profile{
    select when wrangler child_initialized
    pre{
      name=event:attr("name")
      location="apt99"
      thresh=threshold
      phone=+6053509672
      eci=event:attr("eci")
    }
      event:send(
        {
          "eci":eci,
          "domain":"sensor",
          "type":"profile_updated",
          "attrs":{"name":name,"location":location,"threshold":threshold,"phone":phone}
        })
  }
  rule delete_sensor {
    select when sensor unneeded
    pre {
      name = event:attr("name")
      exists = ent:sensors >< name
    }
    if exists then
      send_directive("deleting_sensor", {"name":name})
    fired {
      raise wrangler event "child_deletion"
        attributes {"name": name};
      clear ent:sensors{[name]}
    }
  }
}

