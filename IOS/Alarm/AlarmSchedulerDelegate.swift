import Foundation
import UIKit

protocol AlarmSchedulerDelegate {
    func setNotification(ByUUIDStr uuid: String, onSnooze: Bool, snoozeDate: Date?)
    func setNotification(ByAlarm alarm: Alarm, onSnooze: Bool, snoozeDate: Date?)
    func setNotificationForSnooze(ByUUIDStr uuid: String, snoozeMinute: Int)
    func cancelNotification(ByUUIDStr uuid: String)
    func updateNotification(ByUUIDStr uuid: String)
    func setupNotificationSettings()
    
}

