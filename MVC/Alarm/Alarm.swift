import Foundation

class Alarm: Codable {
    let uuid: UUID
    var date: Date
    var enabled: Bool
    var snoozeEnabled: Bool
    var repeatWeekdays: [Int]
    var mediaID: String
    var mediaLabel: String
    var label: String
    
    convenience init() {
        self.init(uuid: UUID(), date: Date(), enabled: true, snoozeEnabled: false, repeatWeekdays: [], mediaID: "", mediaLabel: "bell", label: "Alarm")
    }
    
    init(uuid: UUID, date: Date, enabled: Bool, snoozeEnabled: Bool, repeatWeekdays: [Int], mediaID: String, mediaLabel: String, label: String) {
        self.uuid = uuid
        self.date = date
        self.enabled = enabled
        self.snoozeEnabled = snoozeEnabled
        self.repeatWeekdays = repeatWeekdays
        self.mediaID = mediaID
        self.mediaLabel = mediaLabel
        self.label = label
    }
    
    enum CodingKeys: CodingKey {
        case uuid
        case date
        case enabled
        case snoozeEnabled
        case repeatWeekdays
        case mediaID
        case mediaLabel
        case label
    }
    
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Alarm.CodingKeys> = try decoder.container(keyedBy: Alarm.CodingKeys.self)
        
        self.uuid = try container.decode(UUID.self, forKey: Alarm.CodingKeys.uuid)
        self.date = try container.decode(Date.self, forKey: Alarm.CodingKeys.date)
        self.enabled = try container.decode(Bool.self, forKey: Alarm.CodingKeys.enabled)
        self.snoozeEnabled = try container.decode(Bool.self, forKey: Alarm.CodingKeys.snoozeEnabled)
        self.repeatWeekdays = try container.decode([Int].self, forKey: Alarm.CodingKeys.repeatWeekdays)
        self.mediaID = try container.decode(String.self, forKey: Alarm.CodingKeys.mediaID)
        self.mediaLabel = try container.decode(String.self, forKey: Alarm.CodingKeys.mediaLabel)
        self.label = try container.decode(String.self, forKey: Alarm.CodingKeys.label)
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Alarm.CodingKeys> = encoder.container(keyedBy: Alarm.CodingKeys.self)
        
        try container.encode(self.uuid, forKey: Alarm.CodingKeys.uuid)
        try container.encode(self.date, forKey: Alarm.CodingKeys.date)
        try container.encode(self.enabled, forKey: Alarm.CodingKeys.enabled)
        try container.encode(self.snoozeEnabled, forKey: Alarm.CodingKeys.snoozeEnabled)
        try container.encode(self.repeatWeekdays, forKey: Alarm.CodingKeys.repeatWeekdays)
        try container.encode(self.mediaID, forKey: Alarm.CodingKeys.mediaID)
        try container.encode(self.mediaLabel, forKey: Alarm.CodingKeys.mediaLabel)
        try container.encode(self.label, forKey: Alarm.CodingKeys.label)
    }
}

extension Alarm {
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self.date)
    }
}

extension Alarm {
    static let changeReasonKey = "reason"
    static let newValueKey = "newValue"
    static let oldValueKey = "oldValue"
    static let updated = "updated"
    static let added = "added"
    static let removed = "removed"
}
