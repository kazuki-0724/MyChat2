//
//  TalkRoomView.swift
//  MyChat2
//
//
import SwiftUI

struct TalkRoomHeaderView: View {

    @Binding var selectedRoomID: String
    @Binding var isFullScreen: Bool
    let room: Room
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            
            VStack {
                HStack {
                    Button {
                        selectedRoomID = self.room.roomId
                        DispatchQueue.main.async {
                                isFullScreen = true
                        }
                    }label: {
                        Text(room.roomName)
                    }
                    Spacer()
                    Text(room.lastTimestamp)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Text(room.lastMessage)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(3)
    }
}

#Preview {
    //TalkRoomHeaderView( isFullScreen: .constant(false))
}

