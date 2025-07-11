//
//  KOKOViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class KOKOViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.systemTeal
        view.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1)

        let label = UILabel()
        label.text = "KOKO頁面"
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
