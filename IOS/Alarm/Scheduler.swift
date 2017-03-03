//
//  Scheduler.swift
//  Alarm-ios-swift
//
//  Created by longyutao on 16/1/15.
//  Copyright (c) 2016年 LongGames. All rights reserved.
//

import Foundation
import UIKit


class Scheduler : AlarmSchedulerDelegate
{
    var alarmModel: Alarms = Alarms()
    func setupNotificationSettings() {
        
        // Specify the notification types.
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound]
        
        // Specify the notification actions.
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = Id.stopIdentifier
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.background
        stopAction.isDestructive = false
        stopAction.isAuthenticationRequired = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = Id.snoozeIdentifier
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.background
        snoozeAction.isDestructive = false
        snoozeAction.isAuthenticationRequired = false
        
        let actionsArray = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
        let actionsArrayMinimal = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
        
        // Specify the category related to the above actions.
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "myAlarmCategory"
        alarmCategory.setActions(actionsArray, for: .default)
        alarmCategory.setActions(actionsArrayMinimal, for: .minimal)
        
        
        let categoriesForSettings = Set(arrayLiteral: alarmCategory)
        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings)
        UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
    }
    
    fileprivate func correctDate(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
    {
        var correctedDate: [Date] = [Date]()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
        let dateComponents = (calendar as NSCalendar).components(flags, from: date)
        let weekday:Int = dateComponents.weekday!
        
        //no repeat
        if weekdays.isEmpty{
            //scheduling date is eariler than current date
            if date.compare(now) == ComparisonResult.orderedAscending {
                //plus one day, otherwise the notification will be fired righton
                correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            }
            else { //later
                correctedDate.append(date)
            }
            return correctedDate
        }
        //repeat
        else {
            let daysInWeek = 7
            correctedDate.removeAll(keepingCapacity: true)
            for wd in weekdays {
                
                var wdDate: Date!
                //schedule on next week
                if compare(weekday: wd, with: weekday) == .before {
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
                }
                //schedule on today or next week
                else if compare(weekday: wd, with: weekday) == .same {
                    //scheduling date is eariler than current date, then schedule on next week
                    if date.compare(now) == ComparisonResult.orderedAscending {
                        wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: daysInWeek, to: date, options:.matchStrictly)!
                    }
                    else { //later
                        wdDate = date
                    }
                }
                //schedule on next days of this week
                else { //after
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
                }
                
                //fix second component to 0
                let second = calendar.component(.second, from: wdDate)
                wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: wdDate, options:.matchStrictly)!
                
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
    }
    
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify weekdays:[Int], snoozeEnabled:Bool,  onSnooze: Bool, soundName: String, index: Int) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        AlarmNotification.alertBody = "Wake Up!"
        AlarmNotification.alertAction = "Open App"
        AlarmNotification.category = "myAlarmCategory"
        AlarmNotification.soundName = soundName + ".mp3"
        AlarmNotification.timeZone = TimeZone.current
        AlarmNotification.userInfo = ["snooze" : snoozeEnabled, "index": index, "soundName": soundName]
        //repeat weekly if repeat weekdays are selected
        //no repeat with snooze notification
        if !weekdays.isEmpty && !onSnooze{
            AlarmNotification.repeatInterval = NSCalendar.Unit.weekOfYear
        }
        
        let datesForNotification = correctDate(date, onWeekdaysForNotify:weekdays)
        
        for d in datesForNotification {
            AlarmNotification.fireDate = d
            UIApplication.shared.scheduleLocalNotification(AlarmNotification)
        }
        
    }
    
    func setNotificationForSnooze(snoozeMinute: Int, soundName: String, index: Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
        setNotificationWithDate(snoozeTime, onWeekdaysForNotify: [Int](), snoozeEnabled: true, onSnooze:true, soundName: soundName, index: index)
    }
    
    func reSchedule() {
        //cancel all and register all is often more convenient
        UIApplication.shared.cancelAllLocalNotifications()
        alarmModel = Alarms()
        for i in 0..<alarmModel.count{
            let alarm = alarmModel.alarms[i]
            if alarm.enabled {
                setNotificationWithDate(alarm.date as Date, onWeekdaysForNotify: alarm.repeatWeekdays, snoozeEnabled: alarm.snoozeEnabled, onSnooze: false, soundName: alarm.mediaLabel, index: i)
            }
        }
    }
    
    private enum weekdaysCompareResult {
        case before
        case same
        case after
    }
    
    private func compare(weekday w1: Int, with w2: Int) -> weekdaysCompareResult
    {
        if w1 != 1 && w2 == 1 {return .before}
        else if w1 == w2 {return .same}
        else {return .after}
    }
}
