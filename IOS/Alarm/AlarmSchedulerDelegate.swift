import Foundation
import UIKit

protocol AlarmSchedulerDelegate {
    func setNotification(date: Date, ringtoneName: String, repeatWeekdays: [Int], snoozeEnabled: Bool, onSnooze: Bool, uuid: String)
    func setNotificationForSnooze(ringtoneName: String, snoozeMinute: Int, uuid: String)
    func cancelNotification(ByUUIDStr uuid: String)
    func updateNotification(ByUUIDStr uuid: String, date: Date, ringtoneName: String, repeatWeekdays: [Int], snoonzeEnabled: Bool)
    func setupNotificationSettings()
}

