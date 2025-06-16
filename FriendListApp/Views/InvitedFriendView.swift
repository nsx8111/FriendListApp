//
//  InvitedFriendView.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/11.
//

import Foundation
import UIKit

class InvitedFriendView: UIView {

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1) // 偏灰色
        view.layer.cornerRadius = 16.scalePt() // 依設計圖你圖看起來是大圓角
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search_icon")) // 你要準備 search_icon 圖片
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "想轉一筆給誰呢？"
        textField.font = .pingFangTC(.regular, size: 16.scalePt())
        textField.textColor = UIColor(red: 71/255.0, green: 71/255.0, blue: 71/255.0, alpha: 1)
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.isUserInteractionEnabled = false // 如果你目前只是展示用，不需要真的打字可關閉
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let addFriendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_btn_add_friends"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(backgroundView)
        addSubview(addFriendButton)

        backgroundView.addSubview(searchIconImageView)
        backgroundView.addSubview(searchTextField)

        NSLayoutConstraint.activate([
            // backgroundView 左右貼齊 superview，右側預留 addFriendButton 的空間
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scalePt()),
            backgroundView.trailingAnchor.constraint(equalTo: addFriendButton.leadingAnchor, constant: -12.scalePt()),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // addFriendButton 貼齊 superview 右側
            addFriendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scalePt()),
            addFriendButton.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 32.scalePt()), // 依你的圖大小設定
            addFriendButton.heightAnchor.constraint(equalToConstant: 32.scalePt()),

            // searchIconImageView
            searchIconImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12.scalePt()),
            searchIconImageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 20.scalePt()),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 20.scalePt()),

            // searchTextField
            searchTextField.leadingAnchor.constraint(equalTo: searchIconImageView.trailingAnchor, constant: 8.scalePt()),
            searchTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12.scalePt()),
            searchTextField.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 24.scalePt()) // 文字區高度
        ])
    }
}
