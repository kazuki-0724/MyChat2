//
//  TalkRoomView.swift
//  MyChat2
//
//
import SwiftUI

struct TalkRoomHeaderView: View {
    
    let roomName: String
    let roomId: String
    @Binding var selectedRoomID: String
    @Binding var isFullScreen: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            
            VStack {
                HStack {
                    Button(action: {
                        selectedRoomID = self.roomId
                        DispatchQueue.main.async {
                                isFullScreen = true
                        }
                    }) {
                        Text(roomName)
                    }
                    Spacer()
                    Text("last date")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                Text("last message")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(3)
        //.background(.black)
        
    }
}

#Preview {
    //TalkRoomHeaderView( isFullScreen: .constant(false))
}

