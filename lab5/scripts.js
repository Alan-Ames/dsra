function getCurrentTemp(){
    //url="http://localhost:8080/sky/cloud/X9PRTrJEmodawmQ28CvXQW/sensor_profile/profile"
    //url="http://localhost:8080/sky/event/X9PRTrJEmodawmQ28CvXQW/1556/get/temps";

    url="http://localhost:8080/sky/cloud/X9PRTrJEmodawmQ28CvXQW/temperature_store/temperatures";
    fetch(url).then(function(response){
        return response.json();
    }).then(function(json){
        //tempsList=json.directives[0].options.something
        tempsList=json
        innerhtml="<p>"+tempsList[tempsList.length-1].temperature+"</p>";
        document.getElementById("current_temp").innerHTML=innerhtml
    })
    return NaN;
}
function getRecentTemps(){
    url="http://localhost:8080/sky/cloud/X9PRTrJEmodawmQ28CvXQW/temperature_store/temperatures";
    fetch(url).then(function(response){
        return response.json();
    }).then(function(json){
        //tempsList=json.directives[0].options.something
        tempsList=json
        innerhtml=""
        for(let i=0;(i<10 && i<tempsList.length);i+=1){
           
            innerhtml+="<p>"+tempsList[tempsList.length-1-i].timestamp+":  "+tempsList[tempsList.length-1-i].temperature+"</p>";
            //innerhtml+="<p>"+ moment(tempsList[i].timestamp).format('MMMM Do YYYY, h:mm:ss a') +":  "+tempsList[i].temperature+"</p>";
        }
        document.getElementById("recent_temps").innerHTML=innerhtml;
    })
    return NaN;
}
function getThreasholdViolations(){
    url="http://localhost:8080/sky/cloud/X9PRTrJEmodawmQ28CvXQW/temperature_store/threshold_violations"
    fetch(url).then(function(response){
        return response.json();
    }).then(function(json){
        console.log(json)
        //tempsList=json.directives[0].options.something
        tempsList=json
        //firstTemp=json.directives[0].options.something[0].temperature;
        innerhtml="";
        for(let i=tempsList.length-1; i>=0;i-=1){
            innerhtml+="<p>"+tempsList[i].timestamp+":  "+tempsList[i].temperature+"</p>";
        }
        document.getElementById("threshold_violations").innerHTML=innerhtml;
    });
    return NaN;
}
function main(){
    getCurrentTemp();
    getRecentTemps();
    getThreasholdViolations();
    
}
main();

document.getElementById("namef").addEventListener("click",function(event){
    event.preventDefault();
    main();
    return NAN
})