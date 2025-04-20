//
//  TalkViewModel.swift
//  MyChat2
//
//

import Foundation
import UIKit

class TalkViewModel: ObservableObject {
    
    @Published var messagesInCurrentRoom: [MessageModel] = []
    // 最初の1回だけデバイスIDを取得する
    let myDeviceID = UIDevice.current.identifierForVendor?.uuidString ?? "simulator-device"
    @Published var messages: [MessageModel] = []
    
    init(){
        messages.append(
        MessageModel(text: "Welcome to Room 1", roomId: "room1", timeStamp: Date(),deviceID: myDeviceID)
        )
    }


    // roomIdに基づいてメッセージを読み込む
    func loadMessages(for roomId: String) {
        self.messagesInCurrentRoom = self.filterMessages(by: roomId)
    }

    func send(roomId: String, text: String, completion: @escaping () -> Void) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let message = MessageModel(text: text, roomId: roomId, timeStamp: Date(), deviceID: self.myDeviceID)
        messages.append(message)
        loadMessages(for: roomId)
        // 呼び出し元で定義したcompletionを呼び出す
        completion()
    }
    
    func loadMessagesFromGAS(message: MessageDto) {
        
        let timeStamp: String = message.dateTime
        // 先頭の "D" を取り除く
        let trimmedString = String(timeStamp.dropFirst())
        //print("trimmedString : \(trimmedString)")
        // フォーマッター
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone.current
        // Dateに変換
        let dateTime: Date
        if let d = formatter.date(from: trimmedString) {
            dateTime = d
        } else {
            print("変換失敗")
            dateTime = Date()
        }
        
        // IDの代わりにタイムスタンプの一致で確認
        if messages.contains(where: { $0.timeStamp == dateTime }) {
            return
        }
    
        let roomId: String = message.roomId
        let text: String = message.text
        let deviceID: String = message.deviceID
        
        //print("dateTime : \(dateTime)")
        let message = MessageModel(text: text, roomId: roomId, timeStamp:dateTime, deviceID: deviceID)
        messages.append(message)
    }
    
    func filterMessages(by roomId: String) -> [MessageModel] {
        return messages.filter { $0.roomId == roomId }
    }
}
