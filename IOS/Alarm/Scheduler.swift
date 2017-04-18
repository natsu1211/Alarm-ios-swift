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
        var snoozeEnabled: Bool = false
        if let n = UIApplication.shared.scheduledLocalNotifications {
            if let result = minFireDateWithIndex(notifications: n) {
                let i = result.1
                snoozeEnabled = alarmModel.alarms[i].snoozeEnabled
            }
        }
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
        
        let actionsArray = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UIUserNotificationAction](arrayLiteral: stopAction)
        let actionsArrayMinimal = snoozeEnabled ? [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UIUserNotificationAction](arrayLiteral: stopAction)
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
            if date < now {
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
                wdDate = Scheduler.correctSecondComponent(date: wdDate, calendar: calendar)
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
    }
    
    public static func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
        let second = calendar.component(.second, from: date)
        let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
        return d
    }
    
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify weekdays:[Int], snoozeEnabled:Bool,  onSnooze: Bool, soundName: String, index: Int) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        AlarmNotification.alertBody = "Wake Up!"
        AlarmNotification.alertAction = "Open App"
        AlarmNotification.category = "myAlarmCategory"
        AlarmNotification.soundName = soundName + ".mp3"
        AlarmNotification.timeZone = TimeZone.current
        let repeating: Bool = !weekdays.isEmpty
        AlarmNotification.userInfo = ["snooze" : snoozeEnabled, "index": index, "soundName": soundName, "repeating" : repeating]
        //repeat weekly if repeat weekdays are selected
        //no repeat with snooze notification
        if !weekdays.isEmpty && !onSnooze{
            AlarmNotification.repeatInterval = NSCalendar.Unit.weekOfYear
        }
        
        let datesForNotification = correctDate(date, onWeekdaysForNotify:weekdays)
        
        syncAlarmModel()
        for d in datesForNotification {
            if onSnooze {
                alarmModel.alarms[index].date = Scheduler.correctSecondComponent(date: alarmModel.alarms[index].date)
            }
            else {
                alarmModel.alarms[index].date = d
            }
            AlarmNotification.fireDate = d
            UIApplication.shared.scheduleLocalNotification(AlarmNotification)
        }
        setupNotificationSettings()
        
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
        syncAlarmModel()
        for i in 0..<alarmModel.count{
            let alarm = alarmModel.alarms[i]
            if alarm.enabled {
                setNotificationWithDate(alarm.date as Date, onWeekdaysForNotify: alarm.repeatWeekdays, snoozeEnabled: alarm.snoozeEnabled, onSnooze: false, soundName: alarm.mediaLabel, index: i)
            }
        }
    }
    
    // workaround for some situation that alarm model is not setting properly (when app on background or not launched)
    func checkNotification() {
        alarmModel = Alarms()
        let notifications = UIApplication.shared.scheduledLocalNotifications
        if notifications!.isEmpty {
            for i in 0..<alarmModel.count {
                alarmModel.alarms[i].enabled = false
            }
        }
        else {
            for (i, alarm) in alarmModel.alarms.enumerated() {
                var isOutDated = true
                if alarm.onSnooze {
                    isOutDated = false
                }
                for n in notifications! {
                    if alarm.date >= n.fireDate! {
                        isOutDated = false
                    }
                }
                if isOutDated {
                    alarmModel.alarms[i].enabled = false
                }
            }
        }
    }
    
    private func syncAlarmModel() {
        alarmModel = Alarms()
    }
    
    private enum weekdaysComparisonResult {
        case before
        case same
        case after
    }
    
    private func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult
    {
        if w1 != 1 && w2 == 1 {return .before}
        else if w1 == w2 {return .same}
        else {return .after}
    }
    
    private func minFireDateWithIndex(notifications: [UILocalNotification]) -> (Date, Int)? {
        if notifications.isEmpty {
            return nil
        }
        var minIndex = -1
        var minDate: Date = notifications.first!.fireDate!
        for n in notifications {
            let index = n.userInfo!["index"] as! Int
            if(n.fireDate! <= minDate) {
                minDate = n.fireDate!
                minIndex = index
            }
        }
        return (minDate, minIndex)
    }
}
