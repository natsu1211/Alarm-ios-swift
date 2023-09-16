import XCTest
@testable import Alarm_ios_swift

final class SchedulerTests: XCTestCase {

    let scheduler = NotificationScheduler()
    
    func testCompareWeekdays() {
        XCTAssertEqual(scheduler.compare(weekday: 1, with: 1), NotificationScheduler.weekdaysComparisonResult.same)
        XCTAssertEqual(scheduler.compare(weekday: 2, with: 2), NotificationScheduler.weekdaysComparisonResult.same)
        XCTAssertEqual(scheduler.compare(weekday: 6, with: 1), NotificationScheduler.weekdaysComparisonResult.before)
        XCTAssertEqual(scheduler.compare(weekday: 2, with: 3), NotificationScheduler.weekdaysComparisonResult.before)
        XCTAssertEqual(scheduler.compare(weekday: 3, with: 2), NotificationScheduler.weekdaysComparisonResult.after)
        XCTAssertEqual(scheduler.compare(weekday: 1, with: 7), NotificationScheduler.weekdaysComparisonResult.after)
    }
    
    func testSetNotification() {
        let nc = UNUserNotificationCenter.current()
        nc.removeAllPendingNotificationRequests()
        nc.removeAllDeliveredNotifications()
        
        let now = Date()
        let ringtoneName = "bell"
        let uuid = UUID()
        scheduler.setNotification(date: now, ringtoneName: ringtoneName, repeatWeekdays: [], snoozeEnabled: false, onSnooze: false, uuid: uuid.uuidString)

        nc.getPendingNotificationRequests(completionHandler: {
            requests in
            XCTAssert(requests.count == 1)
            XCTAssert(requests[0].identifier == uuid.uuidString)
        })
        
        nc.getDeliveredNotifications(completionHandler: {
            requests in
            XCTAssert(requests.isEmpty)
        })

        scheduler.cancelNotification(ByUUIDStr: uuid.uuidString)
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {
            requests in
            XCTAssert(requests.isEmpty)
        })
        
        let uuid2 = UUID()
        let snoozeMinute = 9
        scheduler.setNotificationForSnooze(ringtoneName: ringtoneName, snoozeMinute: snoozeMinute, uuid: uuid2.uuidString)
        nc.getPendingNotificationRequests(completionHandler: {
            requests in
            print(requests.count)
            XCTAssert(requests.count == 1)
            XCTAssert(requests[0].identifier == uuid2.uuidString)
        })
        
        nc.getDeliveredNotifications(completionHandler: {
            requests in
            XCTAssert(requests.isEmpty)
        })
        
        let uuid3 = UUID()
        scheduler.updateNotification(ByUUIDStr: uuid3.uuidString, date: now, ringtoneName: ringtoneName, repeatWeekdays: [], snoonzeEnabled: false)
        nc.getPendingNotificationRequests(completionHandler: {
            requests in
            print(requests.count)
            XCTAssert(requests.count == 1)
            XCTAssert(requests[0].identifier == uuid3.uuidString)
        })
        
        nc.getDeliveredNotifications(completionHandler: {
            requests in
            XCTAssert(requests.isEmpty)
        })

    }
}
