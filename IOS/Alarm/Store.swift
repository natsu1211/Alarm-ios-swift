import Foundation

final class Store {
    let alarms: Alarms = load()
    // singleton
    static let shared = Store()
    static let changedNotification = Notification.Name("StoreChanged")
    
    func save(_ data: Alarms, notifying: Alarm?, userInfo: [AnyHashable: Any]) {
        if let jsonData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(jsonData, forKey: .UserDefaultsKey)
        }
        NotificationCenter.default.post(name: Store.changedNotification, object: notifying, userInfo: userInfo)
    }

    static func load() -> Alarms{
        if let data = UserDefaults.standard.data(forKey: .UserDefaultsKey) {
            if let alarms = try? JSONDecoder().decode(Alarms.self, from: data) {
                return alarms
            }
        }
        return Alarms()
    }
    
    func clear() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

fileprivate extension String {
    static let UserDefaultsKey = "UserDefaultsData"
}
