//
//  TalkViewModel.swift
//  MyChat2
//
//

import Foundation
import UIKit

class TalkViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var rooms: [Room] = []
    // 最初の1回だけデバイスIDを取得する
    let myDeviceID = UIDevice.current.identifierForVendor?.uuidString ?? "simulator-device"
    
    
    init(){
//        messages.append(
//            MessageModel(text: "Welcome to Room 1", roomId: "room1", timeStamp: Date(),deviceID: myDeviceID)
//        )
        rooms.append(Room(roomName: "チャットルーム", roomId: "room1", lastMessage: "hogehoge", lastTimestamp: "fugafuga"))
        rooms.append(Room(roomName: "APIテストルーム", roomId: "room2", lastMessage: "fugafuga", lastTimestamp: "piyopiyo"))
    }

    func addMessage(roomId: String, text: String) {
        let message = Message(text: text, roomId: roomId, timeStamp: Date(), deviceID: self.myDeviceID)
        messages.append(message)
    }
    
    func addAPIResponseMessage(roomId: String, text: String) {
        let message = Message(text: text, roomId: roomId, timeStamp: Date(), deviceID: "hogefugapiyo")
        messages.append(message)
    }
    
    
    func loadMessagesFromGAS(message: Message) {
        // IDの代わりにタイムスタンプの一致で確認
        if messages.contains(where: { $0.timeStamp == message.timeStamp }) {
            return
        }
    
        let roomId: String = message.roomId
        let text: String = message.text
        let deviceID: String = message.deviceID
        
        //print("dateTime : \(dateTime)")
        let message = Message(text: text, roomId: roomId, timeStamp: message.timeStamp, deviceID: deviceID)
        messages.append(message)
    }
}
