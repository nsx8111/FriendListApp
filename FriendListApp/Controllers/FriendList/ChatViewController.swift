//
//  ChatViewController.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {

    var viewModel = ChatViewModel()
    var chatListView: ChatListView!
    
    // 添加回調屬性，供父視圖監聽
    var onRequestRefresh: (() -> Void)?
    
    // 搜索狀態變化回調
    var onSearchStateChanged: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupEvent()
        loadChatData()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        chatListView = ChatListView()
        view = chatListView
    }
    
    private func setupEvent() {
        chatListView.onRequestRefresh = { [weak self] in
            self?.loadChatData()
            self?.onRequestRefresh?()
        }
        
        // 設置搜索狀態變化回調
        chatListView.onSearchStateChanged = { [weak self] isSearching in
            self?.onSearchStateChanged?(isSearching)
        }
    }
    
    // MARK: - Public Methods
    
    func loadChatData() {
        viewModel.fetchChatList { [weak self] chatList in
            DispatchQueue.main.async {
                self?.chatListView.updateChatList(chatList)
                self?.chatListView.endRefreshing()
            }
        }
    }
}

// MARK: - ChatViewModel
class ChatViewModel {
    
    func fetchChatList(completion: @escaping ([Chat]) -> Void) {
        // 模擬網路請求
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // 這裡應該是實際的 API 調用
            let mockData = self.createMockChatData()
            completion(mockData)
        }
    }
    
    private func createMockChatData() -> [Chat] {
        return [
            Chat(id: "1", name: "張志明", lastMessage: "早上好", timestamp: Date(), unreadCount: 2),
            Chat(id: "2", name: "紫晽", lastMessage: "晚上一起吃飯嗎？", timestamp: Date().addingTimeInterval(-3600), unreadCount: 0),
            Chat(id: "3", name: "工作群組", lastMessage: "明天的會議記得參加", timestamp: Date().addingTimeInterval(-7200), unreadCount: 5)
        ]
    }
}

// MARK: - Chat Model
struct Chat {
    let id: String
    let name: String
    let lastMessage: String
    let timestamp: Date
    let unreadCount: Int
}

// MARK: - ChatListView
class ChatListView: UIView {
    
    // MARK: - UI Components
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "搜尋聊天室",
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
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = UIColor.systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.systemGray5
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 85.scalePt(), bottom: 0, right: 10)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // 無聊天記錄時的空狀態視圖
    private let emptyChatImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "message.circle"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "還沒有聊天記錄"
        label.font = .pingFangTC(.medium, size: 21.scalePt())
        label.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyDescLabel: UILabel = {
        let label = UILabel()
        label.text = "開始與好友聊天吧！"
        label.font = .pingFangTC(.regular, size: 14.scalePt())
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - State
    private var allChats: [Chat] = []
    private var filteredChats: [Chat] = []
    
    var onRequestRefresh: (() -> Void)?
    var onSearchStateChanged: ((Bool) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        
        [searchTextField, searchIcon, chatTableView,
         emptyChatImageView, emptyTitleLabel, emptyDescLabel].forEach {
            addSubview($0)
            $0.isHidden = true
        }
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            // 搜尋列
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scalePt()),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scalePt()),
            searchTextField.heightAnchor.constraint(equalToConstant: 36.scalePt()),
            
            searchIcon.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 12.scalePt()),
            searchIcon.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20.scalePt()),
            searchIcon.heightAnchor.constraint(equalToConstant: 20.scalePt()),
            
            chatTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10.scalePt()),
            chatTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scalePt()),
            chatTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scalePt()),
            chatTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 空狀態視圖
            emptyChatImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyChatImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50.scalePt()),
            emptyChatImageView.widthAnchor.constraint(equalToConstant: 100.scalePt()),
            emptyChatImageView.heightAnchor.constraint(equalToConstant: 100.scalePt()),
            
            emptyTitleLabel.topAnchor.constraint(equalTo: emptyChatImageView.bottomAnchor, constant: 20.scalePt()),
            emptyTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            emptyDescLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 8.scalePt()),
            emptyDescLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(ChatListCell.self, forCellReuseIdentifier: "ChatCell")
        refreshControl.addTarget(self, action: #selector(refreshChatList), for: .valueChanged)
        chatTableView.refreshControl = refreshControl
    }
    
    // MARK: - Public Methods
    func updateChatList(_ chats: [Chat]) {
        allChats = chats
        filteredChats = chats
        chatTableView.reloadData()
        updateVisibility()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    // MARK: - UI Updates
    private func updateVisibility() {
        let hasData = !filteredChats.isEmpty
        searchTextField.isHidden = !hasData
        searchIcon.isHidden = !hasData
        chatTableView.isHidden = false
        emptyChatImageView.isHidden = hasData
        emptyTitleLabel.isHidden = hasData
        emptyDescLabel.isHidden = hasData
    }
    
    // MARK: - Actions
    @objc private func searchTextChanged(_ sender: UITextField) {
        let keyword = sender.text?.lowercased() ?? ""
        filteredChats = keyword.isEmpty ? allChats : allChats.filter {
            $0.name.lowercased().contains(keyword) || $0.lastMessage.lowercased().contains(keyword)
        }
        chatTableView.reloadData()
    }
    
    @objc private func refreshChatList() {
        onRequestRefresh?()
    }
}

// MARK: - Table Delegate/DataSource
extension ChatListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatListCell
        cell.configure(with: filteredChats[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.scalePt()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected chat: \(filteredChats[indexPath.row].name)")
    }
}

// MARK: - UITextFieldDelegate
extension ChatListView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onSearchStateChanged?(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onSearchStateChanged?(false)
    }
}

// MARK: - ChatListCell
class ChatListCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.systemGray5
        iv.layer.cornerRadius = 25.scalePt()
        iv.clipsToBounds = true
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
        label.font = .pingFangTC(.regular, size: 14.scalePt())
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTC(.regular, size: 12.scalePt())
        label.textColor = UIColor.systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTC(.medium, size: 12.scalePt())
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        label.layer.cornerRadius = 8.scalePt()
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [avatarImageView, nameLabel, messageLabel, timeLabel, badgeLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scalePt()),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50.scalePt()),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50.scalePt()),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scalePt()),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15.scalePt()),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -10.scalePt()),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scalePt()),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: badgeLabel.leadingAnchor, constant: -10.scalePt()),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scalePt()),
            
            badgeLabel.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            badgeLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 16.scalePt()),
            badgeLabel.heightAnchor.constraint(equalToConstant: 16.scalePt())
        ])
    }
    
    func configure(with chat: Chat) {
        nameLabel.text = chat.name
        messageLabel.text = chat.lastMessage
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: chat.timestamp)
        
        if chat.unreadCount > 0 {
            badgeLabel.text = "\(chat.unreadCount)"
            badgeLabel.isHidden = false
        } else {
            badgeLabel.isHidden = true
        }
        
        // 設置頭像（這裡使用默認圖片或顏色）
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = UIColor.systemBlue
    }
}
