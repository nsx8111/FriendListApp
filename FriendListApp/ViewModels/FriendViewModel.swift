//
//  FriendViewModel.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/18.
//

import Foundation
import UIKit

class FriendViewModel {

    var friends: [Friend] = []

    func fetchFriends(urls: [String], completion: @escaping ([Friend]) -> Void) {

        var allFriends: [Friend] = []
        let dispatchGroup = DispatchGroup()

        for urlString in urls {
            guard let url = URL(string: urlString) else { continue }
            dispatchGroup.enter()

            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { dispatchGroup.leave() }

                if let error = error {
                    print("❌ 請求失敗（\(urlString)）：", error)
                    return
                }

                guard let data = data else { return }

                do {
                    let decoded = try JSONDecoder().decode(FriendResponse.self, from: data)
                    allFriends.append(contentsOf: decoded.response)
                } catch {
                    print("❌ 解碼錯誤（\(urlString)）：", error)
                }
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            // 合併重複 fid，以 updateDate 新的為主
            let mergedFriends = Dictionary(grouping: allFriends, by: { $0.fid }).compactMap { (_, group) -> Friend? in
                return group.max(by: { ($0.parsedDate ?? .distantPast) < ($1.parsedDate ?? .distantPast) })
            }

            self.friends = mergedFriends.sorted(by: { $0.fid < $1.fid })
            print("mergedFriends",self.friends)
            completion(self.friends)
        }
    }
    
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        guard let url = URL(string: apiDatasource1) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ 請求失敗：", error)
                completion([])
                return
            }
            
            guard let data = data else {
                print("❌ 沒有取得資料")
                completion([])
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.response)
                }
            } catch {
                print("❌ 解碼錯誤：", error)
                completion([])
            }
        }.resume()
    }
}
