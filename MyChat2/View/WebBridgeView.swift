import SwiftUI

struct WebBridgeView: View {
    @State private var showSheet = false
    @State private var textFromJS = ""
    @State private var evaluateJS: ((String, @escaping (Result<Any, Error>) -> Void) -> Void)?
    @State private var showModal: Bool = false
    private var text: String = "hogehoge"
    
    var body: some View {
        NavigationStack {
            ZStack {
                WebView(
                    url: URL(string: "https://kazuki-0724.github.io/WebViewBridge/")!,
                    onMessage: { message in
                        // JS からのメッセージを処理
                        if let dict = message as? [String: Any], let type = dict["type"] as? String {
                            DispatchQueue.main.async {
                                if type == "modal" {
                                    showModal = true
                                } else {
                                    self.showSheet = true
                                }
                            }
                        }
                    },
                    onJavaScriptEvaluator: { evaluator in
                        self.evaluateJS = evaluator
                    }
                )
                
                VStack {
                    Spacer()
                    HStack {
                        Button("ネイティブ→WebView1") {
                            // 保存したクロージャを呼び出して JS を実行
                            if let evaluateJS = self.evaluateJS {
                                evaluateJS("changeLog();") { result in
                                    switch result {
                                    case .success(let value):
                                        print("JS 実行成功: \(value)")
                                    case .failure(let error):
                                        print("JS 実行失敗: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                print("WebView がまだ準備できていません")
                            }
                        }
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        
                        Button("ネイティブ→WebView2") {
                            // 保存したクロージャを呼び出して JS を実行
                            if let evaluateJS = self.evaluateJS {
                                evaluateJS("changeLogWithMsg('\(text)');") { result in
                                    switch result {
                                    case .success(let value):
                                        print("JS 実行成功: \(text)を渡しました")
                                    case .failure(let error):
                                        print("JS 実行失敗: \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                print("WebView がまだ準備できていません")
                            }
                        }
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        
                    }
                    .padding(.bottom, 20)
                }
                
                // モーダル
                if showModal {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                }
                
                if showModal {
                    VStack {
                        Text("WebViewから起動されたモーダルです")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                            .padding()
                        
                        Button {
                            showModal = false
                        } label: {
                            Text("閉じる")
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
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                Text("WebViewからネイティブへの通知")
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("閉じる") {
                                showSheet = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    WebBridgeView()
}
