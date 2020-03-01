manager_eci="5CC8fUN2DV4KUmjEfoVASR"
url1="http://localhost:8080/sky/event/5CC8fUN2DV4KUmjEfoVASR/1556/sensor/new_sensor?name=bob"
url2="http://localhost:8080/sky/event/5CC8fUN2DV4KUmjEfoVASR/1556/sensor/new_sensor?name=bo"
let bobUCI=""
let boUCI=""

fetch(url1).then(
    fetch(url2).then(
        fetch(url1).then(
            fetch("http://192.168.1.200:8080/sky/cloud/5CC8fUN2DV4KUmjEfoVASR/manage_sensors/sensors").then(
                function(response){
                    console.log(response)
                    return response.json()
                }
            ).then(
                //testing duplicitay
                //finding eci
                function(json){
                    console.log(json)
                    if(json.length!=2){
                        console.log("failed duplicality")
                    }else{
                        console.log("passed duplicality ")
                    }
                    bobUCI=json.bob
                    boUCI=json.bo
                    //checking profile
                    let profileurl="http://localhost:8080/sky/cloud/"+bobUCI+"/sensor_profile/profile"
                    fetch(profileurl).then(
                        function(response){
                            console.log(response)
                            return response.json()
                        }
                    ).then(
                        function(json){
                            if(json=={"name":"bob","phone":6053509672,"location":"apt99","threshold":78}){
                                console.log("passed profile update")
                            }else{
                                console.log("failed profile update ")
                                console.log(json)
                            }
                        }
                    )
                    //sending new temps
                    let newtempurl1="http://localhost:8080/sky/event/"+bobUCI+"/1/wovyn/new_temperature_reading?temperature=99&timespamp=1"
                    let newtempurl2="http://localhost:8080/sky/event/"+bobUCI+"/1/wovyn/new_temperature_reading?temperature=8&timespamp=2"
                    let newtempurl3="http://localhost:8080/sky/event/"+boUCI+"/1/wovyn/new_temperature_reading?temperature=100&timespamp=3"
                    let newtempurl4="http://localhost:8080/sky/event/"+boUCI+"/1/wovyn/new_temperature_reading?temperature=7&timespamp=4"
                    fetch(newtempurl1).then(
                        fetch(newtempurl2).then(
                            fetch(newtempurl3).then(
                                fetch(newtempurl4).then(
                                    function(response){
                                        //checking to see if temps are registered
                                        let tempsurl="http://localhost:8080/sky/cloud/"+bobUCI+"/temperature_store/temperatures"
                                        fetch(tempsurl).then(
                                            function(response){
                                                return response.json()
                                            }
                                        ).then(
                                            function(json){
                                                if(json.length!=2){
                                                    console.log("new temps failed"+json)
                                                }else{
                                                    console.log("new temps passed")
                                                }
                                            }
                                        )
                                        //checking to see if threshold stuff works
                                        let tempsurlt="http://localhost:8080/sky/cloud/"+bobUCI+"/temperature_store/threshold_violations"
                                        fetch(tempsurlt).then(
                                            function(response){
                                                return response.json()
                                            }
                                        ).then(
                                            function(json){
                                                if(json.length!=1){
                                                    console.log("new temps failed"+json)
                                                }else{
                                                    console.log("new temps passed")
                                                }
                                            }
                                        )
                                        //checking to see if all temps function workd
                                        let alltempsurl="http://localhost:8080/sky/cloud/5CC8fUN2DV4KUmjEfoVASR/manage_sensors/temperatures"
                                        fetch(alltempsurl).then(
                                            function(response){
                                                return response.json()
                                            }
                                        ).then(
                                            function(json){
                                                if(json.length!=4){
                                                    console.log("all temps Failed"+json)
                                                }else{
                                                    console.log("all temps Passed")
                                                }
                                            }
                                        )
                                    }
                                )
                            )
                        )
                    )
                }
            ).then(
                function(response){
                    //deleteing bob test
                    url="http://localhost:8080/sky/event/5CC8fUN2DV4KUmjEfoVASR/1556/sensor/unneeded?name=bob"
                    fetch(url).then(
                        fetch("http://localhost:8080/sky/cloud/5CC8fUN2DV4KUmjEfoVASR/manage_sensors/sensors").then(
                            function(response){
                                return response.json()
                            }
                        ).then(
                            function(json){
                                if(json.length!=1){
                                    console.log("deletion failed "+json)
                                }else{
                                    console.log("deletion passed")
                                }
                            }
                        )
                    ).then(
                        function(resonse){
                            url="http://localhost:8080/sky/event/5CC8fUN2DV4KUmjEfoVASR/1556/sensor/unneeded?name=bo"
                            fetch(url)
                        }
                    )
                }
            )
        )
    )
)

