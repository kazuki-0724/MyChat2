//
//  Zip.swift
//  MyChat2
//
//
import Foundation

// APIレスポンス全体の構造
struct ZipCloudResponse: Decodable {
    let results: [AddressResult]?
    let message: String?
    let status: Int
}

// 住所情報の構造
struct AddressResult: Decodable, Identifiable {
    // データの一意性を保証するために Identifiable プロトコルを採用
    var id: UUID { UUID() }
    let address1: String
    let address2: String
    let address3: String
    let kana1: String
    let kana2: String
    let kana3: String
    let zipcode: String
    let prefcode: String
}
