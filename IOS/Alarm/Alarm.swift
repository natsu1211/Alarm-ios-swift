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
    //using memberwise initializer for struct
    var label: String
    var timeStr: String
    var date: NSDate
    var enabled: Bool
    var snoozeEnabled: Bool
    var UUID: String
    //var index: Int
    var mediaID: String
    var mediaLabel: String
    var repeatWeekdays: [Int]
    
    /*init(title: String, timeStr: String, date: NSDate, enabled: Bool,UUID: String, mediaID: String)
    {
        self.title = title
        self.timeStr = timeStr
        self.date = date
        self.enabled = enabled
        self.UUID = UUID
        self.mediaID = mediaID
    }*/

}

//singleton, for-in loop supporting
class Alarms: SequenceType
{
    private let ud:NSUserDefaults
    private let alarmKey:String
    private var alarms:[Alarm] = [Alarm]()
    
    //ensure can not be instantiated outside
    private init()
    {
        ud = NSUserDefaults.standardUserDefaults()
//      for key in ud.dictionaryRepresentation().keys {
//            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
//        }
        alarmKey = "myAlarmKey"
        alarms = getAllAlarm()
    }
    
    //above swift 1.2
    static let sharedInstance = Alarms()
    
    //setObject only support "property list objects",so we cannot persist alarms directly
    func append(alarm: Alarm)
    {
        alarms.append(alarm)
        
        PersistAlarm(alarm, index: alarms.count-1)
        
    }
    
    func PersistAlarm(alarm: Alarm, index: Int)
    {
        var alarmArray = ud.arrayForKey(alarmKey) ?? []
        //var alarmDict = ud.dictionaryForKey(alarmKey) ?? [:]
        
        //alarmDict[alarm.UUID] = ["label": alarm.label, "timeStr": alarm.timeStr, "date": alarm.date, "enabled": alarm.enabled, "UUID": alarm.UUID, "mediaID": alarm.mediaID, "repeatWeekdays": alarm.repeatWeekdays]
        //ud.setObject(alarmDict, forKey: alarmKey)
       
            alarmArray.append(["label": alarm.label, "timeStr": alarm.timeStr, "date": alarm.date, "enabled": alarm.enabled, "snoozeEnabled": alarm.snoozeEnabled, "UUID": alarm.UUID, "mediaID": alarm.mediaID, "mediaLabel": Alarms.sharedInstance[index].mediaLabel, "repeatWeekdays": alarm.repeatWeekdays])
        
        ud.setObject(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    
    func PersistAlarm(index: Int)
    {
        var alarmArray = ud.arrayForKey(alarmKey) ?? []
        //var alarmDict = ud.dictionaryForKey(alarmKey) ?? [:]
        
        //alarmDict[alarm.UUID] = ["label": alarm.label, "timeStr": alarm.timeStr, "date": alarm.date, "enabled": alarm.enabled, "UUID": alarm.UUID, "mediaID": alarm.mediaID, "repeatWeekdays": alarm.repeatWeekdays]
        //ud.setObject(alarmDict, forKey: alarmKey)
        alarmArray[index] = ["label": Alarms.sharedInstance[index].label, "timeStr": Alarms.sharedInstance[index].timeStr, "date": Alarms.sharedInstance[index].date, "enabled": Alarms.sharedInstance[index].enabled, "snoozeEnabled": Alarms.sharedInstance[index].snoozeEnabled, "UUID": Alarms.sharedInstance[index].UUID, "mediaID": Alarms.sharedInstance[index].mediaID, "mediaLabel": Alarms.sharedInstance[index].mediaLabel, "repeatWeekdays": Alarms.sharedInstance[index].repeatWeekdays]
        ud.setObject(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    
    func deleteAlarm(index: Int)
    {
        var alarmArray = ud.arrayForKey(alarmKey) ?? []
        alarmArray.removeAtIndex(index)
        ud.setObject(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    
    //helper, convert dictionary to [Alarm]
    //better if we can get the property name as a string, but Swift does not have any reflection feature now...
    private func getAllAlarm() -> [Alarm]
    {
//        var alarmDict = NSUserDefaults.standardUserDefaults().dictionaryForKey(alarmKey)
//        if alarmDict != nil
//        {
//            let items = Array(alarmDict!.values)
//            return (items as! Array<Dictionary<String, AnyObject>>).map(){item in Alarm(label: item["label"] as! String, timeStr: item["timeStr"] as! String, date: item["date"] as! NSDate, enabled: item["enabled"] as! Bool, UUID: item["UUID"] as! String, mediaID: item["mediaID"] as! String, repeatWeekdays: item["repeatWeekdays"] as! [Int])}
//            
//        }
//        else
//        {
//            return [Alarm]()
//        }
        
        var alarmArray = NSUserDefaults.standardUserDefaults().arrayForKey(alarmKey)
        if alarmArray != nil{
            let items = alarmArray!
            return (items as! Array<Dictionary<String, AnyObject>>).map(){item in Alarm(label: item["label"] as! String, timeStr: item["timeStr"] as! String, date: item["date"] as! NSDate, enabled: item["enabled"] as! Bool, snoozeEnabled: item["snoozeEnabled"] as! Bool, UUID: item["UUID"] as! String, mediaID: item["mediaID"] as! String, mediaLabel: item["mediaLabel"] as! String, repeatWeekdays: item["repeatWeekdays"] as! [Int])}
        }
        else
        {
            return [Alarm]()
        }
        
        
    }
    
    var count:Int
    {
        return alarms.count
    }
    
    func removeAtIndex(index: Int)
    {
        alarms.removeAtIndex(index)
    }
    
    subscript(index: Int) -> Alarm{
        get{
            assert((index < alarms.count && index >= 0), "Index out of range")
            return alarms[index]
        }
        set{
            assert((index < alarms.count && index >= 0), "Index out of range")
            alarms[index] = newValue
        }

    }
    //helpers for alarm edit. maybe not a good design
    func labelAtIndex(index: Int) -> String
    {
        return alarms[index].label
    }
    
    func timeStrAtIndex(index: Int) -> String
    {
        return alarms[index].timeStr
    }
    
    func dateAtIndex(index: Int) -> NSDate
    {
        return alarms[index].date
    }
    
    func UUIDAtIndex(index: Int) -> String
    {
        return alarms[index].UUID
    }
    
    func enabledAtIndex(index: Int) -> Bool
    {
        return alarms[index].enabled
    }
    
    func mediaIDAtIndex(index: Int) -> String
    {
        return alarms[index].mediaID
    }
    
    func setLabel(label: String, AtIndex index: Int)
    {
        alarms[index].label = label
    }
    
    func setDate(date: NSDate, AtIndex index: Int)
    {
        alarms[index].date = date
    }
    
    func setTimeStr(timeStr: String, AtIndex index: Int)
    {
        alarms[index].timeStr = timeStr
    }
    
    func setMediaID(mediaID: String, AtIndex index: Int)
    {
        alarms[index].mediaID = mediaID
    }
    
    func setMediaLabel(mediaLabel: String, AtIndex index: Int)
    {
        alarms[index].mediaLabel = mediaLabel
    }
    
    func setEnabled(enabled: Bool, AtIndex index: Int)
    {
        alarms[index].enabled = enabled
    }
    
    func setSnooze(snoozeEnabled: Bool, AtIndex index: Int)
    {
        alarms[index].snoozeEnabled = snoozeEnabled
    }
    
    func setWeekdays(weekdays: [Int], AtIndex index: Int)
    {
        alarms[index].repeatWeekdays = weekdays
    }
    
    var isEmpty: Bool
    {
        return alarms.isEmpty
    }
    
    //SequenceType Protocol
    private var currentIndex = 0
    func generate() -> GeneratorOf<Alarm> {
        let next: () -> Alarm? = {
            if self.currentIndex < self.alarms.count{
                return self.alarms[self.currentIndex++]
            }
            return nil
        }
        return GeneratorOf<Alarm>(next)
    }
    
    
}
