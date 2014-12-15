alarmCounter_ = 0;// global state

function InitAlarm(){
    //alert("a");


    for (var i in TimeFromDb){
        var hourText = TimeFromDb[i].get("hour");
        var minText = TimeFromDb[i].get("min");
        if(parseInt(TimeFromDb[i].get("hour")) < 10){
        hourText = "0" +  TimeFromDb[i].get("hour");
    }

    if(parseInt(TimeFromDb[i].get("min")) < 10){
        minText = "0" +  TimeFromDb[i].get("min");
    }
        var time = hourText + ":" + minText;
        switch(weatherNow){

    case"晴れ":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"晴時々曇":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"晴のち曇":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇時々晴":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇り":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Mostly Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Mostly Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇時々雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Thunderstroms.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Thunderstroms.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇のち雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"雨時々曇":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"霧":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Haze.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Haze.png\" alt=\"\" width=\"55px\" height=\"55px\">"
    + maxTemp + "度"
    +"</a></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    default:
    if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">"
    + maxTemp + "度"
    +"</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + time
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">"
    + maxTemp + "度"
    + "</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }
    break;

    ++alarmCounter_;
        }
    }
}

function AddAlarm(){

        var time = TimeFromDb[TimeFromDb.length-1].get("hour") + ":" + TimeFromDb[TimeFromDb.length-1 ].get("min");
        switch(weatherNow){

    case"晴れ":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"晴時々曇":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Sunny.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"晴のち曇":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇時々晴":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇り":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Mostly Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Mostly Cloudy.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇時々雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Thunderstroms.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Thunderstroms.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"曇のち雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"雨時々曇":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Drizzle.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"雨":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    case"霧":
        if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Haze.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Haze.png\" alt=\"\" width=\"55px\" height=\"55px\">"
    + maxTemp + "度"
    +"</a></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">60%</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }

    break;

    default:
    if(alarmCounter_%2 === 0){
            var text1 = "<div style=\"background-color: #FFFFFF; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">"
    + maxTemp + "度"
    +"</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text1);
    }
        else{
            var text2 = "<div style=\"background-color: #F6F6F6; border-bottom: solid 1px\"><ons-row class=\"row ons-row-inner\"><ons-col width=\"45%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 45%; max-width: 45%;\"><div style=\"font-size: 50px\">"
    + setTime
    + "</div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"padding-top: 5px\"><img src=\"images/Snow.png\" alt=\"\" width=\"55px\" height=\"55px\"></div></ons-col>"
    + "<ons-col width=\"15%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 15%; max-width: 15%;\"><div style=\"text-align: center; padding-top: 6px\"><a style=\"font-size: 10px\">最高気温</a><a style=\"font-size: 20px\">"
    + maxTemp + "度"
    + "</a></div></ons-col>"
    + "<ons-col width=\"25%\" class=\"col ons-col-inner\" style=\"-webkit-box-flex: 0; flex: 0 0 25%; max-width: 25%;\"><div style=\"padding-top: 7px\"><ons-switch modifier=\"list-item\" class=\"ng-scope\"><label class=\"switch switch--list-item\"><input type=\"checkbox\" class=\"switch__input switch--list-item__input\" ng-model=\"model\"><div class=\"switch__toggle switch--list-item__toggle\"></div></label></ons-switch></div></ons-col>"
    + "</ons-row></div>";
        $(".alarmbar").append(text2);
    }
    break;

    ++alarmCounter_;

    }

}




