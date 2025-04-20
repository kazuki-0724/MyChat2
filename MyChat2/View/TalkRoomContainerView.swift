//
//  TalkRoomContainerView.swift
//  MyChat2
//
//
import SwiftUI

// TalkRoomのラッパー
struct TalkRoomContainerView: View {
    let roomId: String
    let apiClient: APIClient
    @EnvironmentObject var viewModel: TalkViewModel

    var body: some View {
        TalkRoomView(roomId: roomId, apiClient: apiClient)
            .environmentObject(viewModel)
    }
}
