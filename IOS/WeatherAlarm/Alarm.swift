//
//  Alarm.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit
import CoreLocation
import MediaPlayer

class Alarm: NSObject {
    
   
    var title:String
    var time:String
    //var region:CLCircularRegion
    //var media:MPMediaItem
    
    init( title:String, time:String) {
        self.title = title
       // self.region = region
       // self.media = media
        self.time = time
     
        
    }
}
