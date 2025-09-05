//
//  HomeView.swift
//  MyChat2
//
//
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: TalkViewModel
    @State private var selectedRoomID: String = "room1"
    @State private var isFullScreen = false
    private var apiClient = APIClient.shared
    
    var body: some View {
        List(viewModel.rooms, id: \.roomId) { room in
            TalkRoomHeaderView(selectedRoomID: $selectedRoomID, isFullScreen: $isFullScreen, room: room)
        }
//        .task {
//            do {
//                // GASからメッセージを取得してくる
//                let messages = try await self.apiClient.getMessages()
//                // メッセージを読み込ませる
//                for message in messages {
//                    self.viewModel.loadMessagesFromGAS(message: message)
//                }
//            } catch {
//                print("[HomeView] GASからのデータ取得エラー:", error.localizedDescription)
//            }
//        }
        // List内の要素が変化するたびに、状態が更新される
        .fullScreenCover(isPresented: $isFullScreen) {
            TalkRoomView(roomId: $selectedRoomID)
        }
    }
}

#Preview {
    ContentView()
}

