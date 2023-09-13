import Foundation
import UIKit


class AlarmScheduler : AlarmSchedulerDelegate
{
    private var alarms: Alarms? = Store.shared.load()
    
    func setupNotificationSettings() {
        var snoozeEnabled = false
        if let notifications = UIApplication.shared.scheduledLocalNotifications {
            if let alarm = mostRecentFireDateAlarm(notifications: notifications, alarms: alarms) {
                snoozeEnabled = alarm.snoozeEnabled
            }
        }
        
        // Specify the notification actions.
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = Identifier.stopIdentifier
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.background
        stopAction.isDestructive = false
        stopAction.isAuthenticationRequired = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = Identifier.snoozeIdentifier
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.background
        snoozeAction.isDestructive = false
        snoozeAction.isAuthenticationRequired = false
        
        let actionsArray = snoozeEnabled ? [snoozeAction, stopAction] : [stopAction]
        let actionsArrayMinimal = snoozeEnabled ? [snoozeAction, stopAction] : [stopAction]
        // Specify the category related to the above actions.
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "AlarmCategory"
        alarmCategory.setActions(actionsArray, for: .default)
        alarmCategory.setActions(actionsArrayMinimal, for: .minimal)
        
        
        let categoriesForSettings = Set(arrayLiteral: alarmCategory)
        // Register the notification settings.
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: categoriesForSettings)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    
    //get the alarm with most recently fire date
    private func mostRecentFireDateAlarm(notifications: [UILocalNotification], alarms: Alarms?) -> Alarm? {
        if notifications.isEmpty {
            return nil
        }

        guard var mostRecentDate = notifications.first?.fireDate else {return nil}
        var mostRecentDateAlarmUUIDStr = ""
        for n in notifications {
            if
                let uuidStr = n.userInfo?["uuid"] as? String,
                let fireDate = n.fireDate
            {
                if fireDate < mostRecentDate {
                    mostRecentDate = fireDate
                    mostRecentDateAlarmUUIDStr = uuidStr
                }
            }
            
        }
        return alarms?.getAlarm(ByUUIDStr: mostRecentDateAlarmUUIDStr)
    }
    
    private func correctDate(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
    {
        var correctedDates: [Date] = [Date]()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
        let dateComponents = (calendar as NSCalendar).components(flags, from: date)
        let weekday = dateComponents.weekday ?? 0
        
        //no repeat
        if weekdays.isEmpty {
            //scheduling date is eariler than current date
            if date < now {
                //plus one day, otherwise the notification will be fired righton
                correctedDates.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            }
            else {
                correctedDates.append(date)
            }
            return correctedDates
        }
        else {
            let daysInWeek = 7
            for wd in weekdays {
                var wdDate: Date?
                //schedule on next week
                if compare(weekday: wd, with: weekday) == .before {
                    wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd + daysInWeek - weekday, to: date, options:.matchStrictly)
                }
                //schedule on today or next week
                else if compare(weekday: wd, with: weekday) == .same {
                    //scheduling date is eariler than current date, then schedule on next week
                    if date.compare(now) == .orderedAscending {
                        wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: daysInWeek, to: date, options:.matchStrictly)
                    }
                    else {
                        wdDate = date
                    }
                }
                //schedule on next days of this week
                else {
                    wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd - weekday, to: date, options:.matchStrictly)
                }
                
                //fix second component to 0
                if let date = wdDate {
                    let correctedDate = AlarmScheduler.correctSecondComponent(date: date, calendar: calendar)
                    correctedDates.append(correctedDate)
                }
            }
            return correctedDates
        }
    }
    
    static func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Date {
        let second = calendar.component(.second, from: date)
        let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
        return d
    }
    
    func setNotification(ByUUIDStr uuid: String, onSnooze: Bool = false, snoozeDate: Date? = nil) {
        if let alarm = alarms?.getAlarm(ByUUIDStr: uuid) {
            setNotification(ByAlarm: alarm, onSnooze: onSnooze, snoozeDate: snoozeDate)
        }
    }
    
    func setNotification(ByAlarm alarm: Alarm, onSnooze: Bool = false, snoozeDate: Date? = nil) {
        // will ask for user's permission of local notification when this function be called first time,
        // if notification is not permitted, then this app actually cannot work
        setupNotificationSettings()
        var date = snoozeDate ?? alarm.date
        let datesForNotification = correctDate(date, onWeekdaysForNotify: alarm.repeatWeekdays)
        
        for d in datesForNotification {
            let alarmNotification = UILocalNotification()
            alarmNotification.alertBody = "Wake Up!"
            alarmNotification.alertAction = "Open App"
            alarmNotification.category = "AlarmCategory"
            let soundName = alarm.mediaLabel
            alarmNotification.soundName = soundName
            alarmNotification.timeZone = TimeZone.current
            let repeating = !alarm.repeatWeekdays.isEmpty
            alarmNotification.userInfo = ["snooze" : alarm.snoozeEnabled, "uuid": alarm.uuid.uuidString, "soundName": soundName, "repeating" : repeating]
            
            //repeat weekly if repeat weekdays are selected
            //no repeat with snooze notification
            if repeating && !onSnooze{
                alarmNotification.repeatInterval = NSCalendar.Unit.weekOfYear
            }
            
            if onSnooze {
                alarm.date = AlarmScheduler.correctSecondComponent(date: alarm.date)
            }
            else {
                alarm.date = d
            }
            alarmNotification.fireDate = d
            UIApplication.shared.scheduleLocalNotification(alarmNotification)
        }
    }
    
    func setNotificationForSnooze(ByUUIDStr uuid: String, snoozeMinute: Int) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let snoozeDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
        setNotification(ByUUIDStr: uuid, onSnooze: true, snoozeDate: snoozeDate)
    }
    
    func cancelNotification(ByUUIDStr uuid: String) {
        let notifacations = UIApplication.shared.scheduledLocalNotifications
        let notification = notifacations?.first(where: {$0.userInfo?["uuid"] as? String == uuid})
        if let n = notification {
            UIApplication.shared.cancelLocalNotification(n)
            setupNotificationSettings()
        }
    }
    
    func updateNotification(ByUUIDStr uuid: String) {
        cancelNotification(ByUUIDStr: uuid)
        if let alarm = alarms?.getAlarm(ByUUIDStr: uuid) {
            setNotification(ByAlarm: alarm, onSnooze: false)
        }
        setupNotificationSettings()
    }
    
    private enum weekdaysComparisonResult {
        case before
        case same
        case after
    }
    
    // 0 == Sunday, 1 == Monday and so on
    private func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult
    {
        if (w1 != 0 && w2 == 0) || w1 < w2 {return .before}
        else if w1 == w2 {return .same}
        else {return .after}
    }
}
