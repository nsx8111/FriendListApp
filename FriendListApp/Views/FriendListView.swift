//
//  FriendListView.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/11.
//

import UIKit

class FriendListView: UIView {
    // MARK: - UI Components
    
    // === NoInvitationsView InvitedFriendView UI ===
    private let searchTextField: UITextField = {
        let textField = UITextField()
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
        textField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
    // 將 clearButton 設定移到 setupUI 方法中
    private func setupClearButton() {
        let clearImageView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        clearImageView.tintColor = .lightGray
        clearImageView.contentMode = .scaleAspectFit
        clearImageView.isUserInteractionEnabled = true
        clearImageView.frame = CGRect(x: 0, y: 0, width: 20.scalePt(), height: 20.scalePt())
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clearSearchText))
        clearImageView.addGestureRecognizer(tapGesture)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30.scalePt(), height: 36.scalePt()))
        clearImageView.center = CGPoint(x: 10.scalePt(), y: containerView.frame.height / 2)
        containerView.addSubview(clearImageView)
        containerView.addGestureRecognizer(tapGesture)

        searchTextField.rightView = containerView
        searchTextField.rightViewMode = .whileEditing
    }
    
    private let searchIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = UIColor.systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let addFriendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_btn_add_friends"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.systemGray5
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 71.scalePt(), bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let refreshControl = UIRefreshControl()

    // === NoFriendView UI ===
    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "add_friend_illustration"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "就從加好友開始吧：）"
        label.font = .pingFangTC(.medium, size: 21.scalePt())
        label.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        label.font = .pingFangTC(.regular, size: 14.scalePt())
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        // 文字
        button.setTitle("加好友", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pingFangTC(.medium, size: 16.scalePt())
        button.layer.cornerRadius = 20.scalePt()
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Gradient 背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 86/255, green: 179/255, blue: 11/255, alpha: 1).cgColor,
            UIColor(red: 166/255, green: 204/255, blue: 66/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 20.scalePt()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 192.scalePt(), height: 40.scalePt())
        button.layer.insertSublayer(gradientLayer, at: 0)

        // 加入 Icon
        let iconImageView = UIImageView(image: UIImage(named: "add_friend_icon"))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        button.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8.scalePt()),
            iconImageView.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            iconImageView.heightAnchor.constraint(equalToConstant: 24.scalePt())
        ])
        
        return button
    }()

    private let helpContainerView = UIView()

    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "幫助好友更快找到你？"
        label.font = .pingFangTC(.regular, size: 13.scalePt())
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let setKokoIdLabel: UILabel = {
        let label = UILabel()
        let text = "設定 KOKO ID"
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttributes([
            .foregroundColor: UIColor(red: 236/255, green: 0, blue: 140/255, alpha: 1),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: NSRange(location: 0, length: text.count))
        label.attributedText = attributed
        label.font = .pingFangTC(.regular, size: 13.scalePt())
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - State
    private var allFriends: [Friend] = []
    private var filteredFriends: [Friend] = []
    private var isPreventingResign = false // 新增標記

    var onRequestRefresh: ((MainContentType) -> Void)?
    
    // 新增：搜索狀態變化回調
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

        [searchTextField, searchIcon, addFriendButton, tableView,
         imageView, titleLabel, descLabel, addButton, helpContainerView].forEach { addSubview($0)
            $0.isHidden = true
        }
        
        setupClearButton()

        helpContainerView.addSubview(helpLabel)
        helpContainerView.addSubview(setKokoIdLabel)
        helpContainerView.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        setKokoIdLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self

        NSLayoutConstraint.activate([
            // 搜尋列
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20.scalePt()),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            searchTextField.widthAnchor.constraint(equalToConstant: 276.scalePt()),
            searchTextField.heightAnchor.constraint(equalToConstant: 36.scalePt()),

            searchIcon.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 12.scalePt()),
            searchIcon.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20.scalePt()),
            searchIcon.heightAnchor.constraint(equalToConstant: 20.scalePt()),

            addFriendButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 15.scalePt()),
            addFriendButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            addFriendButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),
            addFriendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scalePt()),

            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10.scalePt()),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scalePt()),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scalePt()),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // 無好友畫面
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 30.scalePt()),
            imageView.widthAnchor.constraint(equalToConstant: 245.scalePt()),
            imageView.heightAnchor.constraint(equalToConstant: 172.scalePt()),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 41.scalePt()),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scalePt()),
            descLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            addButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 25.scalePt()),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 192.scalePt()),
            addButton.heightAnchor.constraint(equalToConstant: 40.scalePt()),

            helpContainerView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 37.scalePt()),
            helpContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),

            helpLabel.leadingAnchor.constraint(equalTo: helpContainerView.leadingAnchor),
            helpLabel.trailingAnchor.constraint(equalTo: setKokoIdLabel.leadingAnchor),
            helpLabel.topAnchor.constraint(equalTo: helpContainerView.topAnchor),
            helpLabel.bottomAnchor.constraint(equalTo: helpContainerView.bottomAnchor),

            setKokoIdLabel.trailingAnchor.constraint(equalTo: helpContainerView.trailingAnchor),
            setKokoIdLabel.topAnchor.constraint(equalTo: helpContainerView.topAnchor),
            setKokoIdLabel.bottomAnchor.constraint(equalTo: helpContainerView.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendListCell.self, forCellReuseIdentifier: "FriendCell")
        refreshControl.addTarget(self, action: #selector(refreshFriendList), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // MARK: - Public Methods
    func updateFriendList(_ friends: [Friend]) {
        allFriends = friends.filter { $0.status == 0 || $0.status == 1 }
        filteredFriends = friends.filter { $0.status == 0 || $0.status == 1 }
        tableView.reloadData()
        updateVisibility()
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    // MARK: - UI Updates
    private func updateVisibility() {
        let hasData = !filteredFriends.isEmpty
        searchTextField.isHidden = !hasData
        searchIcon.isHidden = !hasData
        addFriendButton.isHidden = !hasData
        tableView.isHidden = false
        imageView.isHidden = hasData
        titleLabel.isHidden = hasData
        descLabel.isHidden = hasData
        addButton.isHidden = hasData
        helpContainerView.isHidden = hasData
    }
    
    // MARK: - Actions
    @objc private func searchTextChanged(_ sender: UITextField) {
        let keyword = sender.text?.lowercased() ?? ""
        filteredFriends = keyword.isEmpty ? allFriends : allFriends.filter { $0.name.contains(keyword) }
        tableView.reloadData()
    }
    
    // 按下清除按鈕時執行
    @objc private func clearButtonTouchDown() {
        isPreventingResign = true
        // 保證焦點
        searchTextField.becomeFirstResponder()
    }

    @objc private func clearSearchText() {
        searchTextField.text = ""
        searchTextChanged(searchTextField)
        // 保持鍵盤活著
        searchTextField.becomeFirstResponder()
    }
    
    @objc private func refreshFriendList() {
        let type = MainContentManager.shared.currentType
        onRequestRefresh?(type)
    }
}

// MARK: - Table Delegate/DataSource
extension FriendListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendListCell
        cell.configure(with: filteredFriends[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.scalePt()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected friend: \(filteredFriends[indexPath.row].name)")
    }
}

// MARK: - UITextFieldDelegate
extension FriendListView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 防止在點擊清除按鈕時失去焦點
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return !isPreventingResign
    }
    
    // 新增：當開始編輯時通知父視圖
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onSearchStateChanged?(true)
    }
    
    // 新增：當結束編輯時通知父視圖
    func textFieldDidEndEditing(_ textField: UITextField) {
        onSearchStateChanged?(false)
    }
}
