// This is a JavaScript file

function GetJsonPath(event){
    var targetUrl="http://weather.livedoor.com/forecast/webservice/json/v1?city=" + event.target.id;
    
    var getUrl = 'http://pipes.yahoo.com/pipes/pipe.run?u=' + targetUrl + '&_id=332d9216d8910ba39e6c2577fd321a6a&_render=json&_callback=?'
        
    $.getJSON(getUrl,
    function(data){
        weatherNow = data.value.items[0].forecasts[0].telop;
        locationNow = data.value.items[0].location.area + " " + data.value.items[0].location.city;
        maxTemp = data.value.items[0].forecasts[0].temperature.max.celsius;
     });
    
    loc.popPage();
}

////////////////// 雨だった場合trueを返す。それ以外はfalse ////////////////////////
function judgeWeather() {
    if (weatherNow.match(/^雨/)) {
		return true;
	} else {
		return false;
	}
}
