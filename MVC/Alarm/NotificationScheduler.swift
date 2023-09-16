import Foundation
import UIKit
import UserNotifications

class NotificationScheduler : NotificationSchedulerDelegate
{
    // we need to request user for notifiction permission first
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (authorized, _) in
            if authorized {
                print("notification authorized")
            } else {
                // may need to try other way to make user authorize your app
                print("not authorized")
            }
        }
    }
    
    
    func registerNotificationCategories() {
        // Define the custom actions
        let snoozeAction = UNNotificationAction(identifier: Identifier.snoozeActionIdentifier, title: "Snooze", options: [.foreground])
        let stopAction = UNNotificationAction(identifier: Identifier.stopActionIdentifier, title: "OK", options: [.foreground])
        
        let snoonzeActions = [snoozeAction, stopAction]
        let nonSnoozeActions = [stopAction]
        
        let snoozeAlarmCategory = UNNotificationCategory(identifier: Identifier.snoozeAlarmCategoryIndentifier,
                                                         actions: snoonzeActions,
                                                         intentIdentifiers: [],
                                                         hiddenPreviewsBodyPlaceholder: "",
                                                         options: .customDismissAction)

        let nonSnoozeAlarmCategroy = UNNotificationCategory(identifier: Identifier.alarmCategoryIndentifier,
                                                            actions: nonSnoozeActions,
                                                            intentIdentifiers: [],
                                                            hiddenPreviewsBodyPlaceholder: "",
                                                            options: .customDismissAction)
        // Register the notification category
        UNUserNotificationCenter.current().setNotificationCategories([snoozeAlarmCategory, nonSnoozeAlarmCategroy])
    }
    
    // sync alarm state to scheduled notifications for some situation (app in background and user didn't click notification to bring the app to foreground) that
    // alarm state is not updated correctly
    func syncAlarmStateWithNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            requests in
            print(requests)
            let alarms = Store.shared.alarms
            let uuidNotificationsSet = Set(requests.map({$0.content.userInfo["uuid"] as! String}))
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
        })
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
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Alarm"
            notificationContent.body = "Wake Up"
            notificationContent.categoryIdentifier = snoozeEnabled ? Identifier.snoozeAlarmCategoryIndentifier
                                                                   : Identifier.alarmCategoryIndentifier
            notificationContent.sound = UNNotificationSound(named: ringtoneName + ".mp3")
            notificationContent.userInfo = ["snooze" : snoozeEnabled, "uuid": uuid, "soundName": ringtoneName]
            //repeat weekly if repeat weekdays are selected
            //no repeat with snooze notification
            let repeats = !repeatWeekdays.isEmpty && !onSnooze
            // make dataComponents only contain [weekday, hour, minute] component to make it repeat weakly
            let dateComponents = Calendar.current.dateComponents([.weekday,.hour,.minute], from: d)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
            let request = UNNotificationRequest(identifier: uuid,
                                                content: notificationContent,
                                                trigger: trigger)

            // schedule notification by adding request to notification center
            UNUserNotificationCenter.current().add(request) { error in
                if let e = error {
                    print(e.localizedDescription)
                }
            }
        }
    }
    
    func setNotificationForSnooze(ringtoneName: String, snoozeMinute: Int, uuid: String) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let snoozeDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
        setNotification(date: snoozeDate, ringtoneName: ringtoneName, repeatWeekdays: [], snoozeEnabled: true, onSnooze: true, uuid: uuid)
    }
    
    func cancelNotification(ByUUIDStr uuid: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid])
    }
    
    func updateNotification(ByUUIDStr uuid: String, date: Date, ringtoneName: String, repeatWeekdays: [Int], snoonzeEnabled: Bool) {
        cancelNotification(ByUUIDStr: uuid)
        setNotification(date: date, ringtoneName: ringtoneName, repeatWeekdays: repeatWeekdays, snoozeEnabled: snoonzeEnabled, onSnooze: false, uuid: uuid)
    }
    
    enum weekdaysComparisonResult {
        case before
        case same
        case after
    }
    
    // 1 == Sunday, 2 == Monday and so on
    func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult
    {
        if w1 != 1 && (w1 < w2 || w2 == 1) {return .before}
        else if w1 == w2 {return .same}
        else {return .after}
    }
}
