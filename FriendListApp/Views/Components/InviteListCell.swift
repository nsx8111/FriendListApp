//
//  InviteListCell.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/18.
//

import Foundation
import UIKit

class InviteListCell: UITableViewCell {
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let inviteLabel = UILabel()
    private let acceptButton = UIButton()
    private let rejectButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none

//        containerView.layer.cornerRadius = 6.scalePt()
//        containerView.layer.shadowRadius = 8.scalePt()
//        containerView.layer.shadowOpacity = 0.1
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOffset = .zero // 所有方向都有陰影
//        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false

        avatarImageView.image = UIImage(named: "avatar_placeholder")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 20.scalePt()
        avatarImageView.backgroundColor = UIColor.systemGray2
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = .pingFangTC(.regular, size: 16)
        nameLabel.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        inviteLabel.font = .pingFangTC(.regular, size: 13)
        inviteLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        inviteLabel.text = "邀請你成為好友：）"
        inviteLabel.translatesAutoresizingMaskIntoConstraints = false

        acceptButton.setImage(UIImage(named: "btn_friends_agree"), for: .normal)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false

        rejectButton.setImage(UIImage(named: "btn_friends_delet"), for: .normal)
        rejectButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        [avatarImageView, nameLabel, inviteLabel, acceptButton, rejectButton].forEach {
            containerView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scalePt()), // 行間距
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scalePt()),
            avatarImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40.scalePt()),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40.scalePt()),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15.scalePt()),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14.scalePt()),

            inviteLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            inviteLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2.scalePt()),

            rejectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.scalePt()),
            rejectButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 30.scalePt()),
            rejectButton.heightAnchor.constraint(equalToConstant: 30.scalePt()),

            acceptButton.trailingAnchor.constraint(equalTo: rejectButton.leadingAnchor, constant: -15.scalePt()),
            acceptButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 30.scalePt()),
            acceptButton.heightAnchor.constraint(equalToConstant: 30.scalePt())
        ])
    }

    func configure(with friend: Friend) {
        nameLabel.text = friend.name
        // 如果有 avatar URL，可用圖片加載庫載入圖像
        avatarImageView.image = UIImage(named: "avatar_placeholder")
    }
}
