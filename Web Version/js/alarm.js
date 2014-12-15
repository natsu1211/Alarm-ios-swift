//データベースから取得してきた時刻を，スコープの都合でグローバルにしました
//以下仕様
//データーベースから取得してきたアラーム時刻配列
//TimeFromDb
//使い方　(i番目の時間(hour)を取る例)
//TimeFromDb[i].get("hour")


onload = function() {
    findTime_ToAlm();
};

$(function (){
    //page1の初期化処理
    $(document.body).on("pageinit", "#page-conf", function(){initPageConf();});
});


function timeCheck () {
    var now = new Date();
    
    var targetHour = 0;
    var targetMin = 0;

    if(judgeWeather()){
        for(var i = 0; i < TimeFromDb.length; i++){
            //繰り下がり
            if(TimeFromDb[i].get("min") < rainDelay[1]){
                targetMin = TimeFromDb[i].get("min") - rainDelay[1] + 60;
                targetHour = TimeFromDb[i].get("hour") - rainDelay[0] - 1;
                if(targetHour < 0){
                    targetHour += 24;
                }
            }else{
                targetMin = TimeFromDb[i].get("min") - rainDelay[1];
                targetHour = TimeFromDb[i].get("hour") - rainDelay[0];
            }
            
            if(targetHour == now.getHours() && targetMin == now.getMinutes()) {
                myaudio.src = "http://mkmead.tk/rainy.mp3";
                myaudio.play();
                
                alert("時間だよ：雨");
                
                clearInterval(timer);
            }
        }
    }else{
        for(var i = 0; i < TimeFromDb.length; i++){
            if(TimeFromDb[i].get("hour") == now.getHours() && TimeFromDb[i].get("min") == now.getMinutes()) {
                myaudio.src = "http://mkmead.tk/sunny.mp3";
                myaudio.play();
                
                alert("時間だよ：晴れ");
                
                clearInterval(timer);
            }
        }  
    }
}

function initAlarm(){
    
    //雨に遅らせる時間の初期値
    var setRainTime = '0:30';
    rainDelay = setRainTime.split(':');
    rainDelay[0] = parseInt(rainDelay[0]);
    rainDelay[1] = parseInt(rainDelay[1]);
    //JsonPathの初期値
    weatherNow = "雨";
    locationNow = "東京都 新宿区";
    maxTemp = "25";
    
    
    displayTime();
    myaudio = new Audio();
    
    InitAlarm();
    startAlarm();
}

function startAlarm(){
    if(typeof timer === "undefined"){
        timer = setInterval("timeCheck()", 5000);
  
    }else{
        clearInterval(timer);
        timer = setInterval("timeCheck()", 5000);
    }
}

function displayTime(){
        $("#Hour_test").text("");
    for (var i = 0; i < TimeFromDb.length; i++){
        $("#Hour_test").append((i+1) + "hour:" + TimeFromDb[i].get("hour") + ", min:" + TimeFromDb[i].get("min") + "<br/>");
    }
}


function initPageConf(){    
    $('#getUpTime').append(rainDelay[0] + ' : ' + rainDelay[1]);
    $('#locationNow').append(locationNow);  
}

function inittest(){
    alert('ok');
}
