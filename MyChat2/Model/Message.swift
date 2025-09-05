import Foundation
import SwiftData

@Model
final class Message {
    var id: UUID
    var text: String
    var roomId: String
    var deviceID: String
    var timeStamp: Date

    // アプリ内生成用
    init(text: String, roomId: String, timeStamp: Date, deviceID: String) {
        self.id = UUID()
        self.text = text
        self.roomId = roomId
        self.timeStamp = timeStamp
        self.deviceID = deviceID
    }
}
