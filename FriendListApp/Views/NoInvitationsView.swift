//
//  NoInvitationsView.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/11.
//

import UIKit

class NoInvitationsView: UIView {
    // MARK: - UI Components
    private let searchTextField: UITextField = {
        let textField = UITextField()
//        textField.placeholder = "想轉一筆給誰呢？"
        textField.attributedPlaceholder = NSAttributedString(
            string: "想轉一筆給誰呢？",
            attributes: [
                .foregroundColor: UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0),
                .font: UIFont.pingFangTC(.regular, size: 14.scalePt())
            ]
        )
        
        textField.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        textField.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 0.12)
        textField.layer.cornerRadius = 10.scalePt()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40.scalePt(), height: 36.scalePt()))
        textField.leftViewMode = .always
        textField.font = .pingFangTC(.regular, size: 16.scalePt())
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
//        imageView.image = UIImage(named: "ic_search")
        imageView.tintColor = UIColor.systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let addFriendButton: UIButton = {
        let addFriendButton = UIButton(type: .custom)
        addFriendButton.setImage(UIImage(named: "ic_btn_add_friends"), for: .normal)
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        return addFriendButton
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.systemGray5
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 71.scalePt(), bottom: 0, right: 0) // 16 + 40 + 15 = 71
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel = FriendViewModel()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableView()
        viewModel.fetchFriends {
            self.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupTableView()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = UIColor.white
        
        addSubview(searchTextField)
        addSubview(searchIcon)
        addSubview(addFriendButton)
        addSubview(tableView)
        
        searchTextField.delegate = self

        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            // Search TextField
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scalePt()),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            searchTextField.widthAnchor.constraint(equalToConstant: 276.scalePt()),
            searchTextField.heightAnchor.constraint(equalToConstant: 36.scalePt()),
            
            // Add Friend Button
            addFriendButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 15.scalePt()),
            addFriendButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            addFriendButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),
            addFriendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scalePt()),
            
            // Search Icon
            searchIcon.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 12.scalePt()),
            searchIcon.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20.scalePt()),
            searchIcon.heightAnchor.constraint(equalToConstant: 20.scalePt()),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10.scalePt()),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scalePt()),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scalePt()),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")
    }
}

// MARK: - UITableViewDataSource
extension NoInvitationsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        let friend = viewModel.friends[indexPath.row]
        cell.configure(with: friend)
        return cell
    }}

// MARK: - UITableViewDelegate
extension NoInvitationsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.scalePt()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let friend = viewModel.friends[indexPath.row]
        // Handle friend selection
        print("Selected friend: \(friend.name)")
    }
}


extension NoInvitationsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
