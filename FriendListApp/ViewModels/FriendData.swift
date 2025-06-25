//
//  FriendData.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/17.
//

import Foundation

struct Friend: Codable {
    let name: String
    let status: Int
    let isTop: String
    let fid: String
    let updateDate: String

    var parsedDate: Date? {
        let formats = ["yyyyMMdd", "yyyy/MM/dd"]
        for format in formats {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            if let date = formatter.date(from: updateDate) {
                return date
            }
        }
        return nil
    }
}

struct FriendResponse: Codable {
    let response: [Friend]
}



struct UserResponse: Decodable {
    let response: [User]
}

struct User: Decodable {
    let name: String
    let kokoid: String
}
