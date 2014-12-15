$(function(){
    //mcnbのAPIキー
    NCMB.initialize("4d311bb1cd6fa884acd3dd4f0f79a2fc84dd3d1419b9b3a04cf22c0b9835c3c9","54fa9eff912ab5278c6d3ad8729d50d33887cf55b21ed276597fb0cb0c58e10d");
});


function addTime(){
    var setTime = $('#settime').val();

    var tt = setTime.split(':');
    
    //今回はパースしないのでコメントアウト．もしパースするなら
    tt[0] = parseInt(tt[0]);
    tt[1] = parseInt(tt[1]);
    
    var TimeDb = NCMB.Object.extend("TimeDb");
    var timeDb = new TimeDb();
    
    timeDb.set("hour",tt[0]);
    timeDb.set("min",tt[1]);
    
    timeDb.save(null, {
        success: function(){
            findTime_ToAlm();
        },
        error: function(obj, error){
            alert(error.message);
        } 
    });
    
}

function findTime_ToAlm(){

    var TimeDb = NCMB.Object.extend("TimeDb");
    var queryDb = new NCMB.Query(TimeDb);
    
    //クエリを昇順に
    //queryDb.ascending("hour");
    queryDb.limit(100);
    queryDb.find({
        success: function (results){
            //スコープの問題でグローバルに移す
            TimeFromDb = results.concat();
            initAlarm();
        },
        error: function (error){
            console.log("error:" + error.message);
        }
    });
}

function addRainTime(){
    var setRainTime = $('#setRaintime').val();

    rainDelay = setRainTime.split(':');
    
    //今回はパースしないのでコメントアウト．もしパースするなら
    rainDelay[0] = parseInt(rainDelay[0]);
    rainDelay[1] = parseInt(rainDelay[1]);
}

