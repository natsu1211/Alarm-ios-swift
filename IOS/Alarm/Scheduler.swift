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
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify:[Int], snooze: Bool)
    func setupNotificationSettings()
    func reSchedule()
}


class Scheduler : AlarmSchedulerDelegate
{
    func setupNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        //if (notificationSettings.types == UIUserNotificationType.None){
        // Specify the notification types.
        var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        
        
        // Specify the notification actions.
        var stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = "myStop"
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.Background
        stopAction.destructive = false
        stopAction.authenticationRequired = false
        
        var snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "mySnooze"
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background
        snoozeAction.destructive = false
        snoozeAction.authenticationRequired = false
        
        
        let actionsArray = [UIUserNotificationAction](arrayLiteral: stopAction, snoozeAction)
        let actionsArrayMinimal = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
        // Specify the category related to the above actions.
        var alarmCategory = UIMutableUserNotificationCategory()
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
        
        let flags = NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitWeekdayOrdinal | NSCalendarUnit.CalendarUnitDay
        var dateComponents = calendar.components(flags, fromDate: date)
        //var nowComponents = calendar.components(flags, fromDate: now)
        var weekday:Int = dateComponents.weekday
        
        if weekdays.isEmpty{
            //date is eariler than current time
            if date.compare(now) == NSComparisonResult.OrderedAscending
            {
                
                correctedDate.append(calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: 1, toDate: date, options:.MatchStrictly)!)
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
                    
                    wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: wd+daysInWeek-weekday, toDate: date, options:.MatchStrictly)!
                    
                }
                else if wd == weekday
                {
                    if date.compare(now) == NSComparisonResult.OrderedAscending
                    {
                        wdDate = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: daysInWeek, toDate: date, options:.MatchStrictly)!
                    }
                    //later
                    wdDate = date
                    
                }
                else
                {
                    wdDate =  calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: wd-weekday, toDate: date, options:.MatchStrictly)!
                }
                
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
        
        
    }
    
    func setNotificationWithDate(date: NSDate, onWeekdaysForNotify weekdays:[Int], snooze: Bool) {
        let AlarmNotification: UILocalNotification = UILocalNotification()
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        AlarmNotification.alertBody = "Wake Up!"
        AlarmNotification.alertAction = "Open App"
        AlarmNotification.category = "myAlarmCategory"
        //AlarmNotification.applicationIconBadgeNumber = 0
        //AlarmNotification.repeatCalendar = calendar
        //TODO, not working
        //AlarmNotification.repeatInterval = NSCalendarUnit.CalendarUnitWeekOfYear
        AlarmNotification.soundName = "bell.mp3"
        AlarmNotification.timeZone = NSTimeZone.defaultTimeZone()
        AlarmNotification.userInfo = ["snooze" : snooze]
        
        let datesForNotification = correctDate(date, onWeekdaysForNotify:weekdays)
        if datesForNotification.isEmpty
        {
            AlarmNotification.fireDate = date
            UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
        }
        else
        {
            for d in datesForNotification
            {
                AlarmNotification.fireDate = d
                UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
            }
        }
        
        
    }
    
    func reSchedule() {
        UIApplication.sharedApplication().scheduledLocalNotifications = nil
        for alarm in Alarms.sharedInstance{
            if alarm.enabled{
                setNotificationWithDate(alarm.date, onWeekdaysForNotify: alarm.repeatWeekdays, snooze: alarm.snoozeEnabled)
            }
        }
    }

}
