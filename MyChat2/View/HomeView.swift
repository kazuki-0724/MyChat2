//
//  HomeView.swift
//  MyChat2
//
//
import SwiftUI

struct HomeView: View {
    
    @State private var selectedRoomID: String = "room1"
    @EnvironmentObject var viewModel: TalkViewModel
    @Binding var isFullScreen: Bool
    //let apiClient: APIClient = APIClient()
    let apiClient: APIClient
    
    let room_items: [(id: String, value: String)] = [
        (id: "room1", value: "ルーム1"),
        (id: "room2", value: "ルーム2"),
        (id: "room3", value: "ルーム3")
    ]
    
    var body: some View {
        List(room_items, id: \.id) { room in
            TalkRoomHeaderView(roomName: room.value,roomId: room.id, selectedRoomID: $selectedRoomID, isFullScreen: $isFullScreen)
        }
        // List内の要素が変化するたびに、状態が更新される
        .fullScreenCover(isPresented: $isFullScreen) {
            TalkRoomContainerView(roomId: self.selectedRoomID,apiClient: self.apiClient)
                    .environmentObject(viewModel)
        }
    }
}

#Preview {
    ContentView()
}

