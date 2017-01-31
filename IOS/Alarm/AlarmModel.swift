//
//  AlarmModel.swift
//  WeatherAlarm
//
//  Created by longyutao on 15-2-28.
//  Updated on 17-01-24
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import Foundation
import MediaPlayer

struct Alarm: PropertyReflectable
{
    var date: Date = Date()
    var enabled: Bool = false
    var snoozeEnabled: Bool = false
    var repeatWeekdays: [Int] = []
    var uuid: String = ""
    var mediaID: String = ""
    var mediaLabel: String = ""
    var label: String = ""
    
    //init(){}
    
    init(date:Date, enabled:Bool, snoozeEnabled:Bool, repeatWeekdays:[Int], uuid:String, mediaID:String, mediaLabel:String, label:String){
        self.date = date
        self.enabled = enabled
        self.snoozeEnabled = snoozeEnabled
        self.repeatWeekdays = repeatWeekdays
        self.uuid = uuid
        self.mediaID = mediaID
        self.mediaLabel = mediaLabel
        self.label = label
    }
    
    init(_ dict: PropertyReflectable.RepresentationType){
        date = dict[String(describing: date)] as! Date
        enabled = dict[String(describing: enabled)] as! Bool
        snoozeEnabled = dict[String(describing: snoozeEnabled)] as! Bool
        repeatWeekdays = dict[String(describing: repeatWeekdays)] as! [Int]
        uuid = dict[String(describing: uuid)] as! String
        mediaID = dict[String(describing: mediaID)] as! String
        mediaLabel = dict[String(describing: mediaLabel)] as! String
        label = dict[String(describing: label)] as! String
    }
}

class Alarms: Persistable
{
    let ud: UserDefaults = UserDefaults.standard
    let persistKey: String = "myAlarmKey"
    var alarms: [Alarm] = []
    lazy fileprivate var alarmsDictRepresentation: [PropertyReflectable.RepresentationType] = {
        [unowned self] in
        return self.alarms.map {$0.propertyDictRepresentation}
    }()
    
    init() {
        alarms = getAlarms()
    }
    
    func persist() {
        ud.set(alarmsDictRepresentation, forKey: persistKey)
        ud.synchronize()
    }
    
    func unpersist() {
        for key in ud.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    func insert(_ alarm: Alarm, at index: Int)
    {
        alarms.insert(alarm, at: index)
        alarmsDictRepresentation.insert(alarm.propertyDictRepresentation, at: index)
        persist()
    }
    
    func remove(at index: Int)
    {
        alarms.remove(at: index)
        alarmsDictRepresentation.remove(at: index)
        persist()
    }
    
    var count: Int
    {
        return alarms.count
    }
    
    
    //helper, get all alarms from Userdefaults
    fileprivate func getAlarms() -> [Alarm]
    {
        let array = UserDefaults.standard.array(forKey: persistKey)
        guard let alarmArray = array else{
            return [Alarm]()
        }
        //since switch-case statement not support generic downcast
        guard let dicts = alarmArray as? [PropertyReflectable.RepresentationType] else{
            //restore alarm failed, clean up uncompatible Userdefaults
            unpersist()
            return [Alarm]()
        }
        return dicts.map{Alarm($0)}
    }
}
