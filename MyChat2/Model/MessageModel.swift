//
//  MessageModel.swift
//  MyChat2
//
//

import Foundation

import Foundation

struct MessageModel: Codable, Identifiable, Equatable {
    var id: UUID
    var text: String
    var roomId: String
    var timeStamp: Date
    var deviceID: String
    //var messageID: String

    enum CodingKeys: String, CodingKey {
        case text, dateTime, deviceID, roomId, messageID
    }

    init(text: String, roomId: String, timeStamp: Date, deviceID: String) {
        self.text = text
        self.roomId = roomId
        self.timeStamp = timeStamp
        self.deviceID = deviceID
        self.id = UUID()
        //self.messageID = messageID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.text = try container.decode(String.self, forKey: .text)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.deviceID = try container.decode(String.self, forKey: .deviceID)
        self.id = UUID()
        //self.messageID = try container.decode(String.self, forKey: .messageID)

        let rawDate = try container.decode(String.self, forKey: .dateTime)
        let dateString = String(rawDate.dropFirst())

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .dateTime,
                                                    in: container,
                                                    debugDescription: "日付フォーマットが不正です: \(dateString)")
        }
        self.timeStamp = date
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(roomId, forKey: .roomId)
        try container.encode(deviceID, forKey: .deviceID)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString = "D" + formatter.string(from: timeStamp)
        try container.encode(dateString, forKey: .dateTime)
    }
}
