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
}
