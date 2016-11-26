//
//  Scheduler.swift
//  Alarm-ios8-swift
//
//  Created by longyutao on 16/1/15.
//  Copyright (c) 2016年 LongGames. All rights reserved.
//

import Foundation
import UIKit

protocol AlarmSchedulerDelegate
{
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify:[Int], snooze: Bool, soundName: String, index: Int)
    func setupNotificationSettings()
    func reSchedule()
}


class Scheduler : AlarmSchedulerDelegate
{
    func setupNotificationSettings() {
        
        // Specify the notification types.
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound]
        
        
        // Specify the notification actions.
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = "myStop"
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.background
        stopAction.isDestructive = false
        stopAction.isAuthenticationRequired = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "mySnooze"
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
        //}
    }
    
    fileprivate func correctDate(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
    {
        var correctedDate: [Date] = [Date]()
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        
        let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
        let dateComponents = (calendar as NSCalendar).components(flags, from: date)
        //var nowComponents = calendar.components(flags, fromDate: now)
        let weekday:Int = dateComponents.weekday!
        
        if weekdays.isEmpty{
            //date is eariler than current time
            if date.compare(now) == ComparisonResult.orderedAscending
            {
                
                correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            }
                //later
            else
            {
                correctedDate.append(date)
            }
            return correctedDate
        }
        else
        {
            let daysInWeek = 7
            correctedDate.removeAll(keepingCapacity: true)
            for wd in weekdays
            {
                
                var wdDate: Date!
                //if date.compare(now) == NSComparisonResult.OrderedAscending
                if wd < weekday
                {
                    
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
                    
                }
                else if wd == weekday
                {
                    if date.compare(now) == ComparisonResult.orderedAscending
                    {
                        wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: daysInWeek, to: date, options:.matchStrictly)!
                    }
                    //later
                    wdDate = date
                    
                }
                else
                {
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
                }
                
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
        
        
    }
    
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify weekdays:[Int], snooze: Bool, soundName: String, index: Int) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        AlarmNotification.alertBody = "Wake Up!"
        AlarmNotification.alertAction = "Open App"
        AlarmNotification.category = "myAlarmCategory"
        //AlarmNotification.applicationIconBadgeNumber = 0
        //AlarmNotification.repeatCalendar = calendar
        //TODO, not working
        //AlarmNotification.repeatInterval = NSCalendarUnit.CalendarUnitWeekOfYear
        AlarmNotification.soundName = soundName + ".mp3"
        AlarmNotification.timeZone = TimeZone.current
        AlarmNotification.userInfo = ["snooze" : snooze, "index": index, "soundName": soundName]
        
        let datesForNotification = correctDate(date, onWeekdaysForNotify:weekdays)
        
        for d in datesForNotification
        {
            AlarmNotification.fireDate = d
            UIApplication.shared.scheduleLocalNotification(AlarmNotification)
        }
        
    }
    
    func reSchedule() {
        UIApplication.shared.cancelAllLocalNotifications()
        for i in 0..<Alarms.sharedInstance.count{
            let alarm = Alarms.sharedInstance[i]
            if alarm.enabled{
                setNotificationWithDate(alarm.date as Date, onWeekdaysForNotify: alarm.repeatWeekdays, snooze: alarm.snoozeEnabled, soundName: alarm.mediaLabel, index: i)
            }
        }
    }

}
