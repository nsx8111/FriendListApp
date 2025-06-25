//
//  MoneyViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class MoneyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemIndigo
        view.backgroundColor = UIColor.systemGray

        let label = UILabel()
        label.text = "錢錢頁面"
        label.font = UIFont.pingFangTC(.semibold, size: 28)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
