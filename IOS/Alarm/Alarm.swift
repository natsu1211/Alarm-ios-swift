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
    var date: Date
    var enabled: Bool
    var snoozeEnabled: Bool
    var UUID: String
    var mediaID: String
    var mediaLabel: String
    var repeatWeekdays: [Int]

}

//singleton, for-in loop supporting
class Alarms: Sequence
{
    fileprivate let ud:UserDefaults
    fileprivate let alarmKey:String
    fileprivate var alarms:[Alarm] = [Alarm]()
    
    //ensure can not be instantiated outside
    fileprivate init()
    {
        ud = UserDefaults.standard
//      for key in ud.dictionaryRepresentation().keys {
//            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
//        }
        alarmKey = "myAlarmKey"
        alarms = getAllAlarm()
    }
    
    //above swift 1.2
    static let sharedInstance = Alarms()
    
    //setObject only support "property list objects",so we cannot persist alarms directly
    func append(_ alarm: Alarm)
    {
        alarms.append(alarm)
        PersistAlarm(alarm, index: alarms.count-1)
    }
    
    func PersistAlarm(_ alarm: Alarm, index: Int)
    {
        var alarmArray = ud.array(forKey: alarmKey) ?? []
            alarmArray.append(["label": alarm.label, "timeStr": alarm.timeStr, "date": alarm.date, "enabled": alarm.enabled, "snoozeEnabled": alarm.snoozeEnabled, "UUID": alarm.UUID, "mediaID": alarm.mediaID, "mediaLabel": Alarms.sharedInstance[index].mediaLabel, "repeatWeekdays": alarm.repeatWeekdays])
        
        ud.set(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    
    func PersistAlarm(_ index: Int)
    {
        var alarmArray = ud.array(forKey: alarmKey) ?? []
        alarmArray[index] = ["label": Alarms.sharedInstance[index].label, "timeStr": Alarms.sharedInstance[index].timeStr, "date": Alarms.sharedInstance[index].date, "enabled": Alarms.sharedInstance[index].enabled, "snoozeEnabled": Alarms.sharedInstance[index].snoozeEnabled, "UUID": Alarms.sharedInstance[index].UUID, "mediaID": Alarms.sharedInstance[index].mediaID, "mediaLabel": Alarms.sharedInstance[index].mediaLabel, "repeatWeekdays": Alarms.sharedInstance[index].repeatWeekdays]
        ud.set(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    
    func deleteAlarm(_ index: Int)
    {
        var alarmArray = ud.array(forKey: alarmKey) ?? []
        alarmArray.remove(at: index)
        ud.set(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    
    //helper, convert dictionary to [Alarm]
    //better if we can get the property name as a string, but Swift does not have any reflection feature now...
    fileprivate func getAllAlarm() -> [Alarm]
    {
        let alarmArray = UserDefaults.standard.array(forKey: alarmKey)
        
        if alarmArray != nil{
            let items = alarmArray!
            return (items as! Array<Dictionary<String, AnyObject>>).map(){item in Alarm(label: item["label"] as! String, timeStr: item["timeStr"] as! String, date: item["date"] as! Date, enabled: item["enabled"] as! Bool, snoozeEnabled: item["snoozeEnabled"] as! Bool, UUID: item["UUID"] as! String, mediaID: item["mediaID"] as! String, mediaLabel: item["mediaLabel"] as! String, repeatWeekdays: item["repeatWeekdays"] as! [Int])}
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
    
    func removeAtIndex(_ index: Int)
    {
        alarms.remove(at: index)
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
    func labelAtIndex(_ index: Int) -> String
    {
        return alarms[index].label
    }
    
    func timeStrAtIndex(_ index: Int) -> String
    {
        return alarms[index].timeStr
    }
    
    func dateAtIndex(_ index: Int) -> Date
    {
        return alarms[index].date
    }
    
    func UUIDAtIndex(_ index: Int) -> String
    {
        return alarms[index].UUID
    }
    
    func enabledAtIndex(_ index: Int) -> Bool
    {
        return alarms[index].enabled
    }
    
    func mediaIDAtIndex(_ index: Int) -> String
    {
        return alarms[index].mediaID
    }
    
    func setLabel(_ label: String, AtIndex index: Int)
    {
        alarms[index].label = label
    }
    
    func setDate(_ date: Date, AtIndex index: Int)
    {
        alarms[index].date = date
    }
    
    func setTimeStr(_ timeStr: String, AtIndex index: Int)
    {
        alarms[index].timeStr = timeStr
    }
    
    func setMediaID(_ mediaID: String, AtIndex index: Int)
    {
        alarms[index].mediaID = mediaID
    }
    
    func setMediaLabel(_ mediaLabel: String, AtIndex index: Int)
    {
        alarms[index].mediaLabel = mediaLabel
    }
    
    func setEnabled(_ enabled: Bool, AtIndex index: Int)
    {
        alarms[index].enabled = enabled
    }
    
    func setSnooze(_ snoozeEnabled: Bool, AtIndex index: Int)
    {
        alarms[index].snoozeEnabled = snoozeEnabled
    }
    
    func setWeekdays(_ weekdays: [Int], AtIndex index: Int)
    {
        alarms[index].repeatWeekdays = weekdays
    }
    
    var isEmpty: Bool
    {
        return alarms.isEmpty
    }
    
    //SequenceType Protocol
    fileprivate var currentIndex = 0
    func makeIterator() -> AnyIterator<Alarm> {
        let anyIter = AnyIterator(){self.currentIndex < self.alarms.count ? self.alarms[self.currentIndex] : nil}
        self.currentIndex = self.currentIndex + 1
        return anyIter
    }
    
    
}
