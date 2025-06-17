//
//  FriendTableViewCell.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/17.
//

// MARK: - Custom Table View Cell
import UIKit

class FriendTableViewCell: UITableViewCell {

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20.scalePt()
        imageView.backgroundColor = UIColor.systemGray4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_friends_star")
        imageView.tintColor = UIColor.systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTC(.regular, size: 16.scalePt())
        label.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let transferButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("轉帳", for: .normal)
        button.setTitleColor(UIColor(red: 236/255, green: 0/255, blue: 140/255, alpha: 1.0), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 2.scalePt()
        button.layer.borderColor = UIColor(red: 236/255, green: 0/255, blue: 140/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 1.scalePt()
        button.titleLabel?.font = .pingFangTC(.regular, size: 14.scalePt())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let invitingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("邀請中", for: .normal)
        button.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 2.scalePt()
        button.layer.borderColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0).cgColor
        button.layer.borderWidth = 1.scalePt()
        button.titleLabel?.font = .pingFangTC(.regular, size: 14.scalePt())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor.systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
//        selectionStyle = .none
        setupSelectionStyle()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
//        selectionStyle = .none
        setupSelectionStyle()
        setupCell()
    }
    
    private func setupSelectionStyle() {
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = UIColor(white: 0, alpha: 0.05) // 淡淡的灰色
        selectedBackgroundView = selectedBgView
    }
    
    private func setupCell() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(starImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(transferButton)
        contentView.addSubview(invitingButton)
        contentView.addSubview(moreButton)

        NSLayoutConstraint.activate([
            starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.scalePt()),
            starImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 14.scalePt()),
            starImageView.heightAnchor.constraint(equalToConstant: 14.scalePt()),

            avatarImageView.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 6.scalePt()),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40.scalePt()),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40.scalePt()),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15.scalePt()),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(with friend: Friend) {
        nameLabel.text = friend.name
        avatarImageView.image = UIImage(named: "avatar_placeholder")
        starImageView.isHidden = friend.isTop != "1"

        transferButton.removeFromSuperview()
        invitingButton.removeFromSuperview()
        moreButton.removeFromSuperview()

        contentView.addSubview(transferButton)
        var constraints: [NSLayoutConstraint] = []

        if friend.status == 2 {
            invitingButton.isHidden = false
            moreButton.isHidden = true
            contentView.addSubview(invitingButton)

            constraints += [
                invitingButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.scalePt()),
                invitingButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                invitingButton.widthAnchor.constraint(equalToConstant: 60.scalePt()),
                invitingButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),

                transferButton.trailingAnchor.constraint(equalTo: invitingButton.leadingAnchor, constant: -10.scalePt()),
                transferButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                transferButton.widthAnchor.constraint(equalToConstant: 47.scalePt()),
                transferButton.heightAnchor.constraint(equalToConstant: 24.scalePt())
            ]
        } else {
            invitingButton.isHidden = true
            moreButton.isHidden = false
            contentView.addSubview(moreButton)

            constraints += [
                moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.scalePt()),
                moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                moreButton.widthAnchor.constraint(equalToConstant: 18.scalePt()),
                moreButton.heightAnchor.constraint(equalToConstant: 4.scalePt()),

                transferButton.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -25.scalePt()),
                transferButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                transferButton.widthAnchor.constraint(equalToConstant: 47.scalePt()),
                transferButton.heightAnchor.constraint(equalToConstant: 24.scalePt())
            ]
        }

        NSLayoutConstraint.activate(constraints)
    }
}
