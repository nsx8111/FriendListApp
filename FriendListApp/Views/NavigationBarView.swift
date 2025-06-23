//
//  NavigationBarView.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/21.
//

import UIKit

class NavigationBarView: UIView {
    
    private let atmButton = UIButton()
    private let transferButton = UIButton()
    private let qrButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1)
        
        // 圖片設定
        atmButton.setImage(UIImage(named: "atm"), for: .normal)
        transferButton.setImage(UIImage(named: "$"), for: .normal)
        qrButton.setImage(UIImage(named: "qr"), for: .normal)
        
        // 加入 subviews
        [atmButton, transferButton, qrButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 設定 constraints - 所有按鈕底部貼齊 superview 底部
        NSLayoutConstraint.activate([
            // ATM Button
            atmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scalePt()),
            atmButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            atmButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            atmButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),
            
            // Transfer Button
            transferButton.leadingAnchor.constraint(equalTo: atmButton.trailingAnchor, constant: 24.scalePt()),
            transferButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            transferButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            transferButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),
            
            // QR Button
            qrButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scalePt()),
            qrButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            qrButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            qrButton.heightAnchor.constraint(equalToConstant: 24.scalePt())
        ])
    }
}
