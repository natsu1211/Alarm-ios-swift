import Foundation

final class Store {
    // singleton
    static let shared = Store()
    static let changedNotification = Notification.Name("StoreChanged")
    private let userDefault = UserDefaults.standard
    
    func save(_ data: Alarms, notifying: Alarm?, userInfo: [AnyHashable: Any]) {
        if let jsonData = try? JSONEncoder().encode(data) {
            userDefault.set(jsonData, forKey: .UserDefaultsKey)
        }
        NotificationCenter.default.post(name: Store.changedNotification, object: notifying, userInfo: userInfo)
    }

    
    func load() -> Alarms?{
        if let data = userDefault.data(forKey: .UserDefaultsKey) {
            if let alarms = try? JSONDecoder().decode(Alarms.self, from: data) {
                return alarms
            }
        }
        return nil
    }
    
    func clear() {
        for key in userDefault.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}

fileprivate extension String {
    static let UserDefaultsKey = "UserDefaultsData"
}
