getprofile=function(){
    url="http://localhost:8080/sky/cloud/X9PRTrJEmodawmQ28CvXQW/sensor_profile/profile"
    fetch(url).then(function(response){
        return response.json();
    }).then(function(json){
        console.log(json);
        innerhtml="<p>name: "+json.name+" phone number: "+json.phone+" location: "+json.location+" threshold: "+json.threshold+"</p>"
        document.getElementById("current_profile").innerHTML=innerhtml;
    })
    return NaN
}
getprofile();


document.getElementById("names").addEventListener("click",function(event){
    event.preventDefault();
    const value=document.getElementById("namei").value
    url="http://localhost:8080/sky/event/X9PRTrJEmodawmQ28CvXQW/1556/sensor/profile_updated"
    url+="?name="+value;
    fetch(url).then(function(response){
        getprofile();
        return NaN
    })
    return NaN;
});
document.getElementById("phones").addEventListener("click",function(event){
    event.preventDefault();
    const value=document.getElementById("phonei").value
    url="http://localhost:8080/sky/event/X9PRTrJEmodawmQ28CvXQW/1556/sensor/profile_updated"
    url+="?phone="+value;
    fetch(url).then(function(response){
        getprofile();
        return NaN
    })
    return NaN;
});
document.getElementById("locations").addEventListener("click",function(event){
    event.preventDefault();
    const value=document.getElementById("locationi").value
    url="http://localhost:8080/sky/event/X9PRTrJEmodawmQ28CvXQW/1556/sensor/profile_updated"
    url+="?location="+value;
    fetch(url).then(function(response){
        getprofile();
        return NaN
    })
    return NaN;
});
document.getElementById("thresholds").addEventListener("click",function(event){
    event.preventDefault();
    const value=document.getElementById("thresholdi").value
    url="http://localhost:8080/sky/event/X9PRTrJEmodawmQ28CvXQW/1556/sensor/profile_updated"
    url+="?threshold="+value;
    fetch(url).then(function(response){
        getprofile();
        return NaN
    })
    return NaN;
});

