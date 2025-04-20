//
//  NetworkEngine.swift
//  MyChat2
//

import Foundation
import UIKit

// GASへの導線
let END_POINT = "https://script.google.com/macros/s/AKfycbwXTGpnPk5E-id6NmEEWLS5oVpNdaj8UgUY95Ss4XPzB1aYO4cd2vLUV6iMuMHrmxKL/exec"

class APIClient {
    
    // Date型を先頭に「D」を付与して文字列に変換する（スプレッドシートで勝手に変換されるのを防ぐため）
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return "D" + formatter.string(from: date)
    }

    // GASへのPOSTリクエスト
    // completionは成功時のハンドラー
    func sendMessageToGAS(messageText: String, roomId: String, completion: ((String?, Error?) -> Void)? = nil) {
        // リクエストURLの正当性の確認）
        guard let url = URL(string: END_POINT) else {
            completion?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // リクエストの生成
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // リクエストパラメータの生成
        let now = Date()
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        let body: [String: Any] = [
            "text": messageText,
            "dateTime": dateToString(now),
            "uuid": uuid,
            "roomId": roomId
        ]
        
        // リクエストパラメータのJSON化及び設定
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            completion?(nil, error)
            return
        }

        // POSTリクエストの実施
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No response data"]))
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["status"] as? String {
                    DispatchQueue.main.async {
                        completion?(status, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion?(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
            }
        }.resume()
    }
    
    // GETリクエスト
    func getMessages() async throws -> [MessageDto] {
        guard let url = URL(string: END_POINT) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        var messages: [MessageDto] = []
        do{
            messages = try decoder.decode([MessageDto].self, from: data)
        
        } catch let error as DecodingError {
            switch error {
                case .dataCorrupted(let context):
                    print("データ破損エラー: \(context)")
                case .keyNotFound(let key, let context):
                    print("キーが見つかりません: \(key), コンテキスト: \(context)")
                case .typeMismatch(let type, let context):
                    print("型の不一致: \(type), コンテキスト: \(context)")
                case .valueNotFound(let value, let context):
                print("値が見つかりません: \(value), コンテキスト: \(context)")
                @unknown default:
                print("未知のエラー: \(error)")
            }
            throw error
        }
        return messages
    }
}

