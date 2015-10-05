//
//  Alarm.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import Foundation
import MediaPlayer

struct Alarm
{
    var title: String
    var timeStr: String
    var date: NSDate
    var enabled: Bool
    //var region:CLCircularRegion
    var media:MPMediaItem?
    
    /*
    init( title: String, timestr: String, date: NSDate, enabled: Bool, media: MPMediaItem?) {
        self.title = title
       // self.region = region
        
        self.timeStr = timestr
        self.date = date
        self.enabled = enabled
        self.media = media
     
    }
    */
}

//singleton
class Alarms
{
    private var alarms = [Alarm]()
    class var sharedInstance: Alarms
    {
        struct Singleton
        {
            static let instance: Alarms = Alarms()
        }
        return Singleton.instance
    }
    
    func append(alarm: Alarm)
    {
        alarms.append(alarm)
    }
    
    var count:Int
    {
        return alarms.count
    }
    
    subscript(index: Int) -> Alarm{
        return alarms[index]
    }
}
