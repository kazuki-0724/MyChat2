//
//  TalkView.swift
//  MyChat2
//
//

import SwiftUI

struct TalkRoomView: View {
    
    // HomeViewから渡される値
    @State var roomId: String
    let apiClient: APIClient
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TalkViewModel
    @State var inputText: String = ""

    // 初期化時にメッセージをロード
    init(roomId: String, apiClient: APIClient) {
        self.roomId = roomId
        self.apiClient = apiClient
    }

    var body: some View {
        VStack {
            // ヘッダー部
            HStack {
                Button("<") { dismiss() }
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Text(self.roomId)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .background(.teal)
            .foregroundColor(.white)

            // メッセージ部
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        // 現在のルームで表示対象のメッセージをForEachで表示する
                        ForEach(viewModel.messagesInCurrentRoom, id: \.id) { msg in
                            // UI部品だから生成しておけば勝手に表示される
                            Message(message: msg, myDeviceID: viewModel.myDeviceID)
                        }
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding()
                }
                .background(Color.mint.opacity(0.3))
                .onChange(of: viewModel.messagesInCurrentRoom) {
                    withAnimation {
                        proxy.scrollTo(viewModel.messagesInCurrentRoom.last?.id, anchor: .bottom)
                    }
                }
            }

            // フッダー部
            HStack {
                TextField("メッセージを入力", text: $inputText)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                
                Button(action: {sendMessage()}) {
                    Image(systemName: "paperplane.fill").font(.title)
                }
            }
            .padding()
            .background(.white)
        }
        .onAppear {
            // このViewが表示されるタイミングで実行される処理
            Task {
                do {
                    // GASからメッセージを取得してくる
                    let messages = try await self.apiClient.getMessages()
                    // メッセージを読み込ませる
                    for message in messages {
                        self.viewModel.loadMessagesFromGAS(message: message)
                    }
                    // roomIdに基づいてメッセージをロード
                    self.viewModel.loadMessages(for: roomId)
                    
                } catch {
                    print("取得エラー:", error.localizedDescription)
                }
            }

        }
    }
    
    // APIに送信する＋DBに登録＋画面に反映させる
    func sendMessage(){
        // API通信
        self.apiClient.sendMessageToGAS(messageText: inputText, roomId: self.roomId) { status, error in
            if let status = status {
                print("送信成功: \(status)")
            } else if let error = error {
                print("送信失敗: \(error.localizedDescription)")
            }
        }
        // DB処理&&UI処理
        viewModel.send(roomId: self.roomId, text: self.inputText) {
            // completion
            inputText = ""
        }
    }
}

#Preview {
    TalkRoomView(roomId: "room1",apiClient: APIClient())
        .environmentObject(TalkViewModel())
}

