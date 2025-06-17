//
//  StartViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/11.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
    }
    
    private func setupButtons() {
        let noFriendButton = makeButton(title: "無好友", tag: 0)
        let noInvitationsButton = makeButton(title: "好友列表無邀請", tag: 1)
        let invitedFriendButton = makeButton(title: "好友列表含邀請好友", tag: 2)
        
        let stackView = UIStackView(arrangedSubviews: [noFriendButton, noInvitationsButton, invitedFriendButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func makeButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 8
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 220).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let mainVC = MainViewController()
        mainVC.contentType = {
            switch sender.tag {
            case 1: return .noInvitations
            case 2: return .invitedFriend
            default: return .noFriend
            }
        }()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}
