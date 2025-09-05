import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let onMessage: (Any) -> Void
    
    // JS 実行のためのクロージャを外部に公開
    let onJavaScriptEvaluator: (@escaping (String, @escaping (Result<Any, Error>) -> Void) -> Void) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onMessage: onMessage)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "bridge")
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        
        // Coordinator を通じて、外部に JS 実行メソッドを公開
        self.onJavaScriptEvaluator { script, completion in
            webView.evaluateJavaScript(script) { result, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(result ?? ()))
                }
            }
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        let onMessage: (Any) -> Void
        
        init(onMessage: @escaping (Any) -> Void) {
            self.onMessage = onMessage
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "bridge" {
                onMessage(message.body)
            }
        }
    }
}
