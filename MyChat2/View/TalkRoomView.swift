import SwiftUI
import SwiftData

struct TalkRoomView: View {
    
    @EnvironmentObject var viewModel: TalkViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var inputText: String = ""
    @Binding var roomId: String
    @Query(sort: \Message.timeStamp) var messages: [Message]
    @State private var showModal: Bool = false
    
    let apiClient = APIClient.shared
    var roomName: String {
        viewModel.rooms.filter { $0.roomId == roomId }.first?.roomName ?? "部屋名なし"
    }
    let myDeviceID = UIDevice.current.identifierForVendor?.uuidString ?? "simulator-device"
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // ヘッダー部
                HStack {
                    Button("<") { dismiss() }
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    Text(self.roomName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        showModal = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 20))
                            .padding(.trailing, 10)
                    }
                }
                .background(.teal)
                .foregroundColor(.white)

                // メッセージ部
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            // 現在のルームで表示対象のメッセージをForEachで表示する
                            ForEach(messages) { msg in
                                if msg.roomId == self.roomId {
                                    // UI部品だから生成しておけば勝手に表示される
                                    MessageView(message: msg, myDeviceID: viewModel.myDeviceID)
                                }
                            }
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .padding()
                    }
                    .background(Color.mint.opacity(0.3))
                    .onChange(of: viewModel.messages) {
                        withAnimation {
                            // 現在のルームの最後のメッセージidを取得
                            let lastMsg = viewModel.messages.filter { $0.roomId == self.roomId }.last
                                if let lastId = lastMsg?.id {
                                    withAnimation {
                                        print("[onChange] scroll to bottom")
                                        proxy.scrollTo(lastId, anchor: .bottom)
                                    }
                                }
                        }
                    }
                    .onAppear {
                        withAnimation {
                            // 現在のルームの最後のメッセージidを取得
                            let lastMsg = viewModel.messages.filter { $0.roomId == self.roomId }.last
                                if let lastId = lastMsg?.id {
                                    withAnimation {
                                        print("[onAppear] scroll to bottom")
                                        proxy.scrollTo(lastId, anchor: .bottom)
                                    }
                                }
                        }
                    }
                }

                // フッダー部
                HStack {
                    TextField("メッセージを入力", text: $inputText)
                        .frame(height: 40)
                        .padding(.leading, 10)
                        .background(.white)
                        .cornerRadius(5)
                    
                    Button {
                        sendMessage()
                    } label : {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 30))
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 20)
                .padding(.top, 10)
                .background(.gray.opacity(0.15))
            }
            // モーダル
            if showModal {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showModal = false
                    }
            }
            if showModal {
                VStack {
                    Text("メッセージを全て削除しますか？")
                        .font(.system(size: 20))
                        .foregroundStyle(.blue)
                        .padding()
                    
                    Button {
                        do {
                            // `@Binding`から実際の値を取り出す
                            let currentRoomId = $roomId.wrappedValue
                            try modelContext.delete(model: Message.self, where: #Predicate<Message> { $0.roomId == currentRoomId })
                        } catch {
                            print("Failed to delete messages: \(error)")
                            }
                        showModal = false
                    } label: {
                        Text("削除")
                            .padding(10)
                            .background(.blue)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                }
                .background(.white)
                .cornerRadius(5)
            }
        }

    }
    
    // APIに送信する＋DBに登録＋画面に反映させる
    func sendMessage() {
        // 空入力をはじく
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        // 入力フィールドの初期化
        let text = self.inputText
        inputText = ""
        
        if self.roomId == "room2" {
            Task {
                let newMessage = Message(
                    text: text,
                    roomId: self.roomId,
                    timeStamp: Date(),
                    deviceID: myDeviceID
                )
                modelContext.insert(newMessage)
                
                let addresses = await apiClient.fetchAddresses(zipcode: text)
                // DB処理&&UI処理
                viewModel.addMessage(roomId: self.roomId, text: text)
                let address1 = addresses.first?.address1 ?? "error"
                let address2 = addresses.first?.address2 ?? "error"
                let address3 = addresses.first?.address3 ?? "error"
                let address = address1 + " " + address2 + " " + address3
                var result: String = ""
                
                if address.contains("error") {
                    result = "該当の住所が見つかりません。"
                } else {
                    result = "「\(text)」の住所は以下の通りです。\n" + address
                }
                //viewModel.addAPIResponseMessage(roomId: self.roomId, text: result)
                let apiResult = Message(
                    text: result,
                    roomId: self.roomId,
                    timeStamp: Date(),
                    deviceID: "hogefugapiyo"
                )
                modelContext.insert(apiResult)
            }
        } else {
            let newMessage = Message(
                text: text,
                roomId: self.roomId,
                timeStamp: Date(),
                deviceID: myDeviceID
            )
            modelContext.insert(newMessage)
        }
    }
}

#Preview {
//    TalkRoomView(roomId: "room1")
//        .environmentObject(TalkViewModel())
}

