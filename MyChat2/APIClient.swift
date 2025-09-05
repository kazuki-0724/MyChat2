//
//  NetworkEngine.swift
//  MyChat2
//

import Foundation
import UIKit

// GASへの導線
let END_POINT = "https://script.google.com/macros/s/AKfycbwjzp0YBOqhDxiLY9pcSN84nHH4FtLYMCOmORHehsCa3XdCBpkoj9WAV19f5Cy0_tqH/exec"

class APIClient {
    
    static let shared = APIClient()
            
    // APIの状態を公開
    @Published private(set) var addresses: [AddressResult] = []

    // APIリクエストを実行する非同期関数
    func fetchAddresses(zipcode: String) async  -> [AddressResult]{
        
        addresses = []
            
        guard let url = URL(string: "https://zipcloud.ibsnet.co.jp/api/search?zipcode=\(zipcode)") else {
            return []
        }
            
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(ZipCloudResponse.self, from: data)
                
            // メインスレッドでUIを更新
            await MainActor.run {
                if decodedResponse.status == 200, let results = decodedResponse.results {
                    self.addresses = results
                } else {
                    let error = NSError(domain: "ZipCloud", code: decodedResponse.status, userInfo: [NSLocalizedDescriptionKey: decodedResponse.message ?? "不明なエラー"])
                }
            }
        } catch {
            
        }
        return addresses
    }
    
    
    
    // Date型を先頭に「D」を付与して文字列に変換する（スプレッドシートで勝手に変換されるのを防ぐため）
//    private func dateToString(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//        return "D" + formatter.string(from: date)
//    }

    // GASへのPOSTリクエスト
    // completionは成功時のハンドラー
//    func sendMessageToGAS(messageText: String, roomId: String, completion: ((String?, Error?) -> Void)? = nil) {
//        // リクエストURLの正当性の確認）
//        guard let url = URL(string: END_POINT) else {
//            completion?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
//            return
//        }
//        
//        // リクエストの生成
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // リクエストパラメータの生成
//        let now = Date()
//        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
//        let body: [String: Any] = [
//            "text": messageText,
//            "dateTime": dateToString(now),
//            "uuid": uuid,
//            "roomId": roomId
//        ]
//        
//        // リクエストパラメータのJSON化及び設定
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
//            request.httpBody = jsonData
//        } catch {
//            completion?(nil, error)
//            return
//        }
//
//        // POSTリクエストの実施
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    completion?(nil, error)
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No response data"]))
//                }
//                return
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
//                   let status = json["status"] as? String {
//                    DispatchQueue.main.async {
//                        completion?(status, nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]))
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion?(nil, error)
//                }
//            }
//        }.resume()
//    }
    
    // GETリクエスト
//    func getMessages() async throws -> [Message] {
//        do {
//            // キャッシュを回避するためのクエリパラメータを追加
//            guard var urlComponents = URLComponents(string: END_POINT) else {
//                throw URLError(.badURL)
//            }
//            urlComponents.queryItems = [
//                URLQueryItem(name: "cacheBuster", value: UUID().uuidString)
//            ]
//            
//            guard let url = urlComponents.url else {
//                throw URLError(.badURL)
//            }
//
//            let (data, _) = try await URLSession.shared.data(from: url)
//            
//            let decoder = JSONDecoder()
//            // 受け取ったJSONをMessageモデルにデコード
//            let messages = try decoder.decode([Message].self, from: data)
//            return messages
//        } catch {
//            print("[getMessages()] catch error: \(error)")
//            throw error // エラーを再スローして、呼び出し元で処理させる
//        }
//    }
}
