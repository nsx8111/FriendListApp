//
//  InviteListView.swift
//  FriendListApp
//

import UIKit

class InviteListView: UIView {
    private var friendTabTopConstraintToInviteTableView: NSLayoutConstraint!
    private var friendTabTopConstraintToSetIdLabel: NSLayoutConstraint!
    private var inviteTableViewHeightConstraint: NSLayoutConstraint!
    private var indicatorCenterXConstraint: NSLayoutConstraint!
    private var indicatorBottomConstraint: NSLayoutConstraint!
    
    let friendTabButton = UIButton()
    let chatTabButton = UIButton()
    private let indicatorView = UIView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let setIdLabel = UILabel()
    private let bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        return line
    }()
    
    private let inviteTableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // 添加堆疊效果的背景層
    private let stackedBackgroundView1 = UIView()
    private let stackedBackgroundView2 = UIView()
    
    // 控制展開狀態的變數
    private var isInviteListExpanded = false
    private let collapsedDisplayCount = 1 // 縮合時只顯示1個邀請
    
    // 修改：移除 didSet，改為手動控制更新
    private var allInvitesFriends: [Friend] = []
    
    // 高度變化回調
    var heightDidChange: ((CGFloat) -> Void)?
    
    var userName: String = "" {
        didSet {
            nameLabel.text = userName
            // 強制更新布局
            setNeedsLayout()
        }
    }
    
    var kokoID: String = "" {
        didSet {
            setIdLabel.text = "KOKO ID：\(kokoID) >"
            // 強制更新布局
            setNeedsLayout()
        }
    }
    
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
        avatarView.image = UIImage(named: "avatar")
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 52.scalePt() / 2
        avatarView.contentMode = .scaleAspectFill

        // 文字設定 - 增加更明確的約束優先級
        nameLabel.text = userName
        nameLabel.font = .pingFangTC(.medium, size: 17.scalePt())
        nameLabel.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        nameLabel.numberOfLines = 1
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        setIdLabel.text = "KOKO ID：\(kokoID) >"
        setIdLabel.font = .pingFangTC(.regular, size: 13.scalePt())
        setIdLabel.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)
        setIdLabel.numberOfLines = 1
        setIdLabel.setContentHuggingPriority(.required, for: .vertical)
        setIdLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        // Tab 按鈕設定
        friendTabButton.setTitle("好友", for: .normal)
        chatTabButton.setTitle("聊天", for: .normal)

        [friendTabButton, chatTabButton].forEach {
            $0.setTitleColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0), for: .normal)
            $0.titleLabel?.font = .pingFangTC(.medium, size: 13.scalePt())
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        friendTabButton.setTitleColor(.systemPink, for: .normal)

        indicatorView.backgroundColor = .systemPink
        indicatorView.layer.cornerRadius = 2.scalePt()

        // 設置堆疊背景層的樣式
        [stackedBackgroundView1, stackedBackgroundView2].forEach { view in
            view.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1)
            view.layer.cornerRadius = 6.scalePt()
            view.layer.shadowRadius = 8.scalePt()
            view.layer.shadowOpacity = 0.1
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = .zero
            view.layer.masksToBounds = false
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isHidden = true // 初始隱藏
        }

        // 加入 subviews - 注意順序，背景層要在 tableView 之前
        [avatarView, nameLabel, setIdLabel, stackedBackgroundView2, stackedBackgroundView1, inviteTableView, friendTabButton, chatTabButton, indicatorView, bottomLine].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 初始化約束變數
        friendTabTopConstraintToInviteTableView = friendTabButton.topAnchor.constraint(equalTo: inviteTableView.bottomAnchor, constant: 30.scalePt())
        friendTabTopConstraintToSetIdLabel = friendTabButton.topAnchor.constraint(equalTo: setIdLabel.bottomAnchor, constant: 30.scalePt())
        
        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: friendTabButton.centerXAnchor)
        inviteTableViewHeightConstraint = inviteTableView.heightAnchor.constraint(equalToConstant: 0)
        indicatorBottomConstraint = indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor)

        inviteTableView.delegate = self
        inviteTableView.dataSource = self
        inviteTableView.register(InviteListCell.self, forCellReuseIdentifier: "InviteCell")
        inviteTableView.layer.cornerRadius = 6.scalePt()
        inviteTableView.layer.shadowRadius = 8.scalePt()
        inviteTableView.layer.shadowOpacity = 0.1
        inviteTableView.layer.shadowColor = UIColor.black.cgColor
        inviteTableView.layer.shadowOffset = .zero
        inviteTableView.layer.masksToBounds = false
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Avatar - 固定位置約束，使用明確的數值
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 27.scalePt()),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scalePt()),
            avatarView.widthAnchor.constraint(equalToConstant: 52.scalePt()),
            avatarView.heightAnchor.constraint(equalToConstant: 52.scalePt()),

            // NameLabel - 固定位置約束，避免與其他元件產生衝突
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 35.scalePt()),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: avatarView.leadingAnchor, constant: -15.scalePt()),

            // SetIdLabel - 與 nameLabel 保持固定距離
            setIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.scalePt()),
            setIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            setIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: avatarView.leadingAnchor, constant: -15.scalePt()),

            // InviteTableView - 與 avatar 保持固定距離
            inviteTableView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 35.scalePt()),
            inviteTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            inviteTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scalePt()),
            inviteTableViewHeightConstraint,
            
            // 堆疊背景層約束
            stackedBackgroundView1.topAnchor.constraint(equalTo: inviteTableView.topAnchor, constant: 5.scalePt()),
            stackedBackgroundView1.leadingAnchor.constraint(equalTo: inviteTableView.leadingAnchor, constant: 10.scalePt()),
            stackedBackgroundView1.trailingAnchor.constraint(equalTo: inviteTableView.trailingAnchor, constant: -10.scalePt()),
            stackedBackgroundView1.bottomAnchor.constraint(equalTo: inviteTableView.bottomAnchor, constant: 10.scalePt()),
            
            stackedBackgroundView2.topAnchor.constraint(equalTo: inviteTableView.topAnchor, constant: 10.scalePt()),
            stackedBackgroundView2.leadingAnchor.constraint(equalTo: inviteTableView.leadingAnchor, constant: 10.scalePt()),
            stackedBackgroundView2.trailingAnchor.constraint(equalTo: inviteTableView.trailingAnchor, constant: -10.scalePt()),
            stackedBackgroundView2.bottomAnchor.constraint(equalTo: inviteTableView.bottomAnchor, constant: 10.scalePt()),

            // Friend Tab Button - 使用較低的優先級避免衝突
            friendTabButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scalePt()),
            
            // Chat Tab Button
            chatTabButton.centerYAnchor.constraint(equalTo: friendTabButton.centerYAnchor),
            chatTabButton.leadingAnchor.constraint(equalTo: friendTabButton.trailingAnchor, constant: 36.scalePt()),
            
            // Indicator - 修正这里，同时使用固定距离和底部约束来确保视图高度正确
            indicatorCenterXConstraint,
            indicatorView.widthAnchor.constraint(equalToConstant: 20.scalePt()),
            indicatorView.heightAnchor.constraint(equalToConstant: 4.scalePt()),
            // 使用相对于 friendTabButton 的固定距离
            indicatorView.topAnchor.constraint(equalTo: friendTabButton.bottomAnchor, constant: 9.scalePt()),
            // 保持底部约束以确保整体高度正确
            indicatorBottomConstraint,
            
            // Bottom Line
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2 / UIScreen.main.scale)
        ])
        
        // 初始設置約束狀態
        updateFriendTabConstraints()
    }
    
    private func updateFriendTabConstraints() {
        // 先停用所有相關約束
        friendTabTopConstraintToInviteTableView.isActive = false
        friendTabTopConstraintToSetIdLabel.isActive = false
        
        // 修復：根據 inviteTableView 的實際顯示狀態和高度來決定約束
        let hasVisibleInvites = !inviteTableView.isHidden && inviteTableViewHeightConstraint.constant > 0
        
        if hasVisibleInvites {
            // 當有可見的邀請時，friendTab 應該相對於 inviteTableView 定位
            friendTabTopConstraintToInviteTableView.isActive = true
        } else {
            // 當沒有邀請或邀請被隱藏時，friendTab 應該相對於 setIdLabel 定位
            friendTabTopConstraintToSetIdLabel.isActive = true
        }
    }
    
    private func updateTableViewHeight() {
        let inviteCount = allInvitesFriends.count
        if inviteCount == 0 {
            inviteTableViewHeightConstraint.constant = 0
            inviteTableView.isHidden = true
            // 隱藏堆疊背景層
            stackedBackgroundView1.isHidden = true
            stackedBackgroundView2.isHidden = true
        } else {
            let displayCount = getDisplayCount()
            let totalHeight = CGFloat(displayCount) * 70.scalePt() + CGFloat(max(0, displayCount - 1)) * 10.scalePt()
            inviteTableViewHeightConstraint.constant = totalHeight
            inviteTableView.isHidden = false
            
            // 控制堆疊背景層的顯示
            let shouldShowStackedEffect = !isInviteListExpanded && inviteCount > collapsedDisplayCount
            stackedBackgroundView1.isHidden = !shouldShowStackedEffect
            stackedBackgroundView2.isHidden = !shouldShowStackedEffect || inviteCount <= 2
        }
        
        // 更新約束 - 這裡是關鍵修復
        updateFriendTabConstraints()
    }
    
    private func getDisplayCount() -> Int {
        let inviteCount = allInvitesFriends.count
        if inviteCount <= collapsedDisplayCount {
            return inviteCount
        } else {
            return isInviteListExpanded ? inviteCount : collapsedDisplayCount
        }
    }
    
    private func calculateTotalHeight() -> CGFloat {
        let inviteCount = allInvitesFriends.count
        let baseHeight: CGFloat = 137.scalePt() // 基礎高度（avatar + nameLabel + setIdLabel + friendTab + indicator + 間距）
        var extraSpacing: CGFloat = 0
        
        if inviteCount == 0 {
//            extraSpacing = 16.scalePt()
            return baseHeight + extraSpacing
        } else {
            let displayCount = getDisplayCount()
            let tableViewHeight = CGFloat(displayCount) * 80.scalePt()
            extraSpacing = displayCount == 1 ? 20.scalePt() : 20.scalePt()
            return baseHeight + tableViewHeight + extraSpacing
        }
    }
    
    private func toggleInviteListExpansion() {
        // 只有當邀請數量大於縮合顯示數量時才能展開/收合
        guard allInvitesFriends.count > collapsedDisplayCount else { return }
        
        isInviteListExpanded.toggle()
        
        // 動畫更新高度
        UIView.animate(withDuration: 0.1, animations: {
            self.updateTableViewHeight()
            self.layoutIfNeeded()
        }) { _ in
            // 動畫完成後重新載入數據以顯示所有項目
            self.inviteTableView.reloadData()
        }
        
        // 通知父視圖高度變化
        let newHeight = calculateTotalHeight()
        heightDidChange?(newHeight)
    }
    
    // 單純縮合列表的方法
    private func collapseInviteList() {
        isInviteListExpanded = false
        
        // 動畫更新高度
        UIView.animate(withDuration: 0.1, animations: {
            self.updateTableViewHeight()
            self.layoutIfNeeded()
        }) { _ in
            // 動畫完成後重新載入數據以顯示縮合狀態
            self.inviteTableView.reloadData()
        }
        
        // 通知父視圖高度變化
        let newHeight = calculateTotalHeight()
        heightDidChange?(newHeight)
    }
    
    func setSelectedTab(index: Int) {
        if index == 0 {
            friendTabButton.setTitleColor(.systemPink, for: .normal)
            chatTabButton.setTitleColor(.darkGray, for: .normal)
            indicatorCenterXConstraint.isActive = false
            indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: friendTabButton.centerXAnchor)
            indicatorCenterXConstraint.isActive = true
        } else {
            friendTabButton.setTitleColor(.darkGray, for: .normal)
            chatTabButton.setTitleColor(.systemPink, for: .normal)
            indicatorCenterXConstraint.isActive = false
            indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: chatTabButton.centerXAnchor)
            indicatorCenterXConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    // 修改：重構 updateInvitesList 方法
    func updateInvitesList(_ friends: [Friend], completion: @escaping (CGFloat) -> Void) {
        // 1. 先重置展開狀態
        isInviteListExpanded = false
        
        // 2. 更新數據
        allInvitesFriends = friends.filter { $0.status == 2 }
        
        // 3. 更新TableView高度
        updateTableViewHeight()
        
        // 4. 重新載入數據
        inviteTableView.reloadData()
        
        // 5. 強制布局更新
        setNeedsLayout()
        layoutIfNeeded()
        
        // 6. 計算新的總高度並通過completion回調
        let newHeight = calculateTotalHeight()
        completion(newHeight)
    }
    
    // 重寫 layoutSubviews 確保布局正確
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 確保所有子視圖都正確布局
        nameLabel.sizeToFit()
        setIdLabel.sizeToFit()
    }
}

// MARK: - TableView DataSource & Delegate
extension InviteListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDisplayCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as? InviteListCell else {
            return UITableViewCell()
        }
        
        let friend = allInvitesFriends[indexPath.row]
        cell.configure(with: friend)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.scalePt()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // 處理cell點擊事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 如果是縮合狀態且有更多邀請，點擊任何cell都會展開
        if !isInviteListExpanded && allInvitesFriends.count > collapsedDisplayCount {
            toggleInviteListExpansion()
        }
        // 如果已經展開，點擊任何cell都會縮合
        else if isInviteListExpanded {
            collapseInviteList()
        }
    }
}
