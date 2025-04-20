//
//  MessageDto.swift
//  MyChat2
//
//
struct MessageDto: Codable,Hashable {
    let messageId: String
    let text: String
    let dateTime: String
    let deviceID: String
    let roomId: String
}
