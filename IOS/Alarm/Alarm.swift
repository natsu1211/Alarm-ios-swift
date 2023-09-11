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
    var onSnooze: Bool
    
    convenience init() {
        self.init(uuid: UUID(), date: Date(), enabled: false, snoozeEnabled: false, repeatWeekdays: [], mediaID: "", mediaLabel: "", label: "", onSnooze: false)
    }
    
    init(uuid: UUID, date: Date, enabled: Bool, snoozeEnabled: Bool, repeatWeekdays: [Int], mediaID: String, mediaLabel: String, label: String, onSnooze: Bool) {
        self.uuid = uuid
        self.date = date
        self.enabled = enabled
        self.snoozeEnabled = snoozeEnabled
        self.repeatWeekdays = repeatWeekdays
        self.mediaID = mediaID
        self.mediaLabel = mediaLabel
        self.label = label
        self.onSnooze = onSnooze
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
        case onSnooze
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
        self.onSnooze = try container.decode(Bool.self, forKey: Alarm.CodingKeys.onSnooze)
        
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
        try container.encode(self.onSnooze, forKey: Alarm.CodingKeys.onSnooze)
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
    static let renamed = "renamed"
    static let added = "added"
    static let removed = "removed"
}
