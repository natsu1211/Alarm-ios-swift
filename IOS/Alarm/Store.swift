import Foundation

final class Store {
    // singleton
    static let shared = Store()
    static let changedNotification = Notification.Name("StoreChanged")
    private let userDefault = UserDefaults.standard
    
    func save(_ notifying: Alarm, userInfo: [AnyHashable: Any]) {
        if let jsonData = try? JSONEncoder().encode(notifying) {
            userDefault.set(jsonData, forKey: notifying.uuid.uuidString)
        }
        NotificationCenter.default.post(name: Store.changedNotification, object: notifying, userInfo: userInfo)
    }
    
    func remove(_ alarm: Alarm, userInfo: [AnyHashable: Any]) {
        // TODO
    }
    
    func removeAll() {
        for key in userDefault.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
}
