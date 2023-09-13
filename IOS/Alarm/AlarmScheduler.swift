import Foundation
import UIKit


class AlarmScheduler : AlarmSchedulerDelegate
{
    weak var alarms: Alarms?
    
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
    
    private func getNotificationDates(baseDate date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
    {
        var notificationDates: [Date] = [Date]()
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
                notificationDates.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            } else {
                notificationDates.append(date)
            }
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
                    notificationDates.append(correctedDate)
                }
            }
        }
        return notificationDates
    }
    
    static func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) -> Date {
        let second = calendar.component(.second, from: date)
        let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
        return d
    }
    
    func setNotification(date: Date, ringtoneName: String, repeatWeekdays: [Int], snoozeEnabled: Bool, onSnooze: Bool, uuid: String) {
        // will ask for user's permission of local notification when this function be called first time,
        // if notification is not permitted, then this app actually cannot work
        setupNotificationSettings()
        let datesForNotification = getNotificationDates(baseDate: date, onWeekdaysForNotify: repeatWeekdays)
        
        for d in datesForNotification {
            let alarmNotification = UILocalNotification()
            alarmNotification.alertBody = "Wake Up!"
            alarmNotification.alertAction = "Open App"
            alarmNotification.category = "AlarmCategory"
            alarmNotification.soundName = ringtoneName
            alarmNotification.soundName = ringtoneName
            alarmNotification.timeZone = TimeZone.current
            alarmNotification.userInfo = ["snooze" : snoozeEnabled, "uuid": uuid, "soundName": ringtoneName]
            //repeat weekly if repeat weekdays are selected
            //no repeat with snooze notification
            if repeatWeekdays.count > 0 && !onSnooze{
                alarmNotification.repeatInterval = NSCalendar.Unit.weekOfYear
            }
            
            alarmNotification.fireDate = d
            UIApplication.shared.scheduleLocalNotification(alarmNotification)
        }
    }
    
    func setNotificationForSnooze(ringtoneName: String, snoozeMinute: Int, uuid: String) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let snoozeDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
        setNotification(date: snoozeDate, ringtoneName: ringtoneName, repeatWeekdays: [], snoozeEnabled: true, onSnooze: true, uuid: uuid)
    }
    
    func cancelNotification(ByUUIDStr uuid: String) {
        let notifacations = UIApplication.shared.scheduledLocalNotifications
        if let n = notifacations?.first(where: {$0.userInfo?["uuid"] as? String == uuid}) {
            UIApplication.shared.cancelLocalNotification(n)
        }
        setupNotificationSettings()
    }
    
    func updateNotification(ByUUIDStr uuid: String, date: Date, ringtoneName: String, repeatWeekdays: [Int], snoonzeEnabled: Bool) {
        cancelNotification(ByUUIDStr: uuid)
        setNotification(date: date, ringtoneName: ringtoneName, repeatWeekdays: repeatWeekdays, snoozeEnabled: snoonzeEnabled, onSnooze: false, uuid: uuid)
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
