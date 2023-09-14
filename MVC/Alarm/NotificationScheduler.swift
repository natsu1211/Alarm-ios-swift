import Foundation
import UIKit


class NotificationScheduler : NotificationSchedulerDelegate
{
    func registerNotificationCategories() {
        // Specify the notification actions.
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = Identifier.stopActionIdentifier
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.foreground
        stopAction.isDestructive = false
        stopAction.isAuthenticationRequired = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = Identifier.snoozeActionIdentifier
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.foreground
        snoozeAction.isDestructive = false
        snoozeAction.isAuthenticationRequired = false
        
        let snoozeActionsArray = [snoozeAction, stopAction]
        let nonSnoozeActionArray = [stopAction]

        let snoozeAlarmCategory = UIMutableUserNotificationCategory()
        snoozeAlarmCategory.identifier = Identifier.snoozeAlarmCategoryIndentifier
        snoozeAlarmCategory.setActions(snoozeActionsArray, for: .default)
        snoozeAlarmCategory.setActions(snoozeActionsArray, for: .minimal)
        
        let nonSnoozeAlarmCategory = UIMutableUserNotificationCategory()
        nonSnoozeAlarmCategory.identifier = Identifier.alarmCategoryIndentifier
        nonSnoozeAlarmCategory.setActions(snoozeActionsArray, for: .default)
        nonSnoozeAlarmCategory.setActions(snoozeActionsArray, for: .minimal)
        
        let categoriesForSettings = Set(arrayLiteral: snoozeAlarmCategory, nonSnoozeAlarmCategory)
        // Register the notification settings.
        let notificationSettings = UIUserNotificationSettings(types: [.alert,.sound], categories: categoriesForSettings)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    // sync alarm state to scheduled notifications for some situation (app in background and user didn't click notification to bring the app to foreground) that
    // alarm state is not updated correctly
    func syncAlarmStateWithNotification() {
        let alarms = Store.shared.alarms
        guard let notifacations = UIApplication.shared.scheduledLocalNotifications else {return}
        let uuidNotificationsSet = Set(notifacations.map({$0.userInfo!["uuid"] as! String}))
        let uuidAlarmsSet = alarms.uuids
        let uuidDeltaSet = uuidAlarmsSet.subtracting(uuidNotificationsSet)
        print(uuidDeltaSet)
        for uuid in uuidDeltaSet {
            if let alarm = alarms.getAlarm(ByUUIDStr: uuid) {
                if alarm.enabled {
                    alarm.enabled = false
                    // since this method will cause UI change, make sure run on main thread
                    DispatchQueue.main.async {
                        alarms.update(alarm)
                    }
                }
            }
        }
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
            for wdIndex in weekdays {
                // weekdays index start from 1 (Sunday)
                let wd = wdIndex + 1
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
                    let correctedDate = NotificationScheduler.correctSecondComponent(date: date, calendar: calendar)
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

        let datesForNotification = getNotificationDates(baseDate: date, onWeekdaysForNotify: repeatWeekdays)
        
        for d in datesForNotification {
            let alarmNotification = UILocalNotification()
            alarmNotification.alertBody = "Wake Up!"
            alarmNotification.alertAction = "Open App"
            alarmNotification.category = snoozeEnabled ? Identifier.snoozeAlarmCategoryIndentifier : Identifier.alarmCategoryIndentifier
            alarmNotification.soundName = ringtoneName + ".mp3"
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
        if let ns = notifacations?.filter({$0.userInfo?["uuid"] as? String == uuid}) {
            for n in ns {
                UIApplication.shared.cancelLocalNotification(n)
            }
        }
    }
    
    func updateNotification(ByUUIDStr uuid: String, date: Date, ringtoneName: String, repeatWeekdays: [Int], snoonzeEnabled: Bool) {
        cancelNotification(ByUUIDStr: uuid)
        setNotification(date: date, ringtoneName: ringtoneName, repeatWeekdays: repeatWeekdays, snoozeEnabled: snoonzeEnabled, onSnooze: false, uuid: uuid)
    }
    
    private enum weekdaysComparisonResult {
        case before
        case same
        case after
    }
    
    // 1 == Sunday, 2 == Monday and so on
    private func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult
    {
        if (w1 != 1 && w2 == 1) || w1 < w2 {return .before}
        else if w1 == w2 {return .same}
        else {return .after}
    }
}
