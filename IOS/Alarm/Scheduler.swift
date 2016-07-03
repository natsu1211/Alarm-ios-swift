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
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify:[Int], snooze: Bool, soundName: String, index: Int)
    func setupNotificationSettings()
    func reSchedule()
}


class Scheduler : AlarmSchedulerDelegate
{
    func setupNotificationSettings() {
        
        // Specify the notification types.
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        
        
        // Specify the notification actions.
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = "myStop"
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.Background
        stopAction.destructive = false
        stopAction.authenticationRequired = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "mySnooze"
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background
        snoozeAction.destructive = false
        snoozeAction.authenticationRequired = false
        
        
        let actionsArray = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
        let actionsArrayMinimal = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
        // Specify the category related to the above actions.
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "myAlarmCategory"
        alarmCategory.setActions(actionsArray, forContext: .Default)
        alarmCategory.setActions(actionsArrayMinimal, forContext: .Minimal)
        
        
        let categoriesForSettings = Set(arrayLiteral: alarmCategory)
        
        
        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
        UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        //}
    }
    
    private func correctDate(date: NSDate, onWeekdaysForNotify weekdays:[Int]) -> [NSDate]
    {
        var correctedDate: [NSDate] = [NSDate]()
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let now = NSDate()
        
        let flags: NSCalendarUnit = [NSCalendarUnit.Weekday, NSCalendarUnit.WeekdayOrdinal, NSCalendarUnit.Day]
        let dateComponents = calendar.components(flags, fromDate: date)
        //var nowComponents = calendar.components(flags, fromDate: now)
        let weekday:Int = dateComponents.weekday
        
        if weekdays.isEmpty{
            //date is eariler than current time
            if date.compare(now) == NSComparisonResult.OrderedAscending
            {
                
                correctedDate.append(calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: date, options:.MatchStrictly)!)
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
            correctedDate.removeAll(keepCapacity: true)
            for wd in weekdays
            {
                
                var wdDate: NSDate!
                //if date.compare(now) == NSComparisonResult.OrderedAscending
                if wd < weekday
                {
                    
                    wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.Day, value: wd+daysInWeek-weekday, toDate: date, options:.MatchStrictly)!
                    
                }
                else if wd == weekday
                {
                    if date.compare(now) == NSComparisonResult.OrderedAscending
                    {
                        wdDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: daysInWeek, toDate: date, options:.MatchStrictly)!
                    }
                    //later
                    wdDate = date
                    
                }
                else
                {
                    wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.Day, value: wd-weekday, toDate: date, options:.MatchStrictly)!
                }
                
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
        
        
    }
    
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify weekdays:[Int], snooze: Bool, soundName: String, index: Int) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        AlarmNotification.alertBody = "Wake Up!"
        AlarmNotification.alertAction = "Open App"
        AlarmNotification.category = "myAlarmCategory"
        //AlarmNotification.applicationIconBadgeNumber = 0
        //AlarmNotification.repeatCalendar = calendar
        //TODO, not working
        //AlarmNotification.repeatInterval = NSCalendarUnit.CalendarUnitWeekOfYear
        AlarmNotification.soundName = soundName + ".mp3"
        AlarmNotification.timeZone = NSTimeZone.defaultTimeZone()
        AlarmNotification.userInfo = ["snooze" : snooze, "index": index, "soundName": soundName]
        
        let datesForNotification = correctDate(date, onWeekdaysForNotify:weekdays)
        
        for d in datesForNotification
        {
            AlarmNotification.fireDate = d
            UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
        }
        
    }
    
    func reSchedule() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        for i in 0..<Alarms.sharedInstance.count{
            let alarm = Alarms.sharedInstance[i]
            if alarm.enabled{
                setNotificationWithDate(alarm.date, onWeekdaysForNotify: alarm.repeatWeekdays, snooze: alarm.snoozeEnabled, soundName: alarm.mediaLabel, index: i)
            }
        }
    }

}
