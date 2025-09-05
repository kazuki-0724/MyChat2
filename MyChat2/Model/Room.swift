//
//  Room.swift
//  MyChat2
//
//

import Foundation

struct Room {

    var roomName: String
    var roomId: String
    var lastMessage: String
    var lastTimestamp: String
    
    init(roomName: String, roomId: String, lastMessage: String, lastTimestamp: String) {
        self.roomName = roomName
        self.roomId = roomId
        self.lastMessage = lastMessage
        self.lastTimestamp = lastTimestamp
    }
}
