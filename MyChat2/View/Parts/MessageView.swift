//
//  Message.swift
//  MyChat2
//
//

import SwiftUI

struct MessageView: View {
    let message: Message
    let alignment: HorizontalAlignment
    let timeStamp: Date

    init(message: Message, myDeviceID: String) {
        self.message = message
        self.alignment = message.deviceID == myDeviceID ? .trailing : .leading
        self.timeStamp = message.timeStamp
    }
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(message.text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: alignment == .trailing ? .trailing : .leading)

            Text(format(date: timeStamp))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }

    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }
}



