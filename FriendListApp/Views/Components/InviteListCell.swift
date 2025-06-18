//
//  InviteListCell.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/18.
//

import Foundation
import UIKit

class InviteListCell: UITableViewCell {
    
    private let avatarView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22.scalePt()
        iv.image = UIImage(named: "avatar_placeholder")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTC(.medium, size: 16.scalePt())
        label.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTC(.regular, size: 13.scalePt())
        label.textColor = .lightGray
        label.text = "邀請你成為好友：）"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let acceptButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "check_icon"), for: .normal)
        btn.tintColor = UIColor(red: 236/255, green: 0, blue: 140/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let rejectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "close_icon"), for: .normal)
        btn.tintColor = UIColor.lightGray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = .clear

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12.scalePt()
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.masksToBounds = false

        [avatarView, nameLabel, messageLabel, acceptButton, rejectButton].forEach {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scalePt()),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 44.scalePt()),
            avatarView.heightAnchor.constraint(equalToConstant: 44.scalePt()),

            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12.scalePt()),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14.scalePt()),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: acceptButton.leadingAnchor, constant: -16.scalePt()),

            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.scalePt()),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: acceptButton.leadingAnchor, constant: -16.scalePt()),

            rejectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scalePt()),
            rejectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 30.scalePt()),
            rejectButton.heightAnchor.constraint(equalToConstant: 30.scalePt()),

            acceptButton.trailingAnchor.constraint(equalTo: rejectButton.leadingAnchor, constant: -12.scalePt()),
            acceptButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 30.scalePt()),
            acceptButton.heightAnchor.constraint(equalToConstant: 30.scalePt())
        ])
    }
    
    func configure(with invite: Friend) {
        nameLabel.text = invite.name
        avatarView.image = UIImage(named: "avatar_placeholder")
    }
}
