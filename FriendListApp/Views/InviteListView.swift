import UIKit

class InviteListView: UIView {
    private var friendTabTopConstraintToInviteTableView: NSLayoutConstraint!
    private var friendTabTopConstraintToSetIdLabel: NSLayoutConstraint!
    private var inviteTableViewHeightConstraint: NSLayoutConstraint!
    private var indicatorCenterXConstraint: NSLayoutConstraint!
    
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
    
    var userName: String = "紫琳" {
        didSet {
            nameLabel.text = userName
        }
    }
    
    var kokoID: String = "" {
        didSet {
            setIdLabel.text = "KOKO ID：\(kokoID) >"
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

        // avatar 圓角保持
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 52.scalePt() / 2

        // 文字設定
        nameLabel.text = userName
        nameLabel.font = .pingFangTC(.medium, size: 17.scalePt())
        nameLabel.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)

        setIdLabel.text = "KOKO ID：\(kokoID) >"
        setIdLabel.font = .pingFangTC(.regular, size: 13.scalePt())
        setIdLabel.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)

        // Tab 按鈕設定
        friendTabButton.setTitle("好友", for: .normal)
        chatTabButton.setTitle("聊天", for: .normal)

        [friendTabButton, chatTabButton].forEach {
            $0.setTitleColor(UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0), for: .normal)
            $0.titleLabel?.font = .pingFangTC(.medium, size: 13.scalePt())
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

        // 加入 subviews - 注意順序，背景層要在 tableView 之前，移除三個按鈕
        [avatarView, nameLabel, setIdLabel, stackedBackgroundView2, stackedBackgroundView1, inviteTableView, friendTabButton, chatTabButton, indicatorView, bottomLine].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        friendTabTopConstraintToInviteTableView = friendTabButton.topAnchor.constraint(equalTo: stackedBackgroundView1.bottomAnchor, constant: 22.scalePt())
        friendTabTopConstraintToSetIdLabel = friendTabButton.topAnchor.constraint(equalTo: setIdLabel.bottomAnchor, constant: 30.scalePt())
        
        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: friendTabButton.centerXAnchor)
        inviteTableViewHeightConstraint = inviteTableView.heightAnchor.constraint(equalToConstant: 0)
        
        inviteTableView.delegate = self
        inviteTableView.dataSource = self
        inviteTableView.register(InviteListCell.self, forCellReuseIdentifier: "InviteCell")
        inviteTableView.layer.cornerRadius = 6.scalePt()
        inviteTableView.layer.shadowRadius = 8.scalePt()
        inviteTableView.layer.shadowOpacity = 0.1
        inviteTableView.layer.shadowColor = UIColor.black.cgColor
        inviteTableView.layer.shadowOffset = .zero
        inviteTableView.layer.masksToBounds = false

        // 設定 constraint - 移除三個按鈕相關的約束
        NSLayoutConstraint.activate([
            // Avatar - 調整 top 約束，直接基於 topAnchor
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 27.scalePt()),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scalePt()),
            avatarView.widthAnchor.constraint(equalToConstant: 52.scalePt()),
            avatarView.heightAnchor.constraint(equalToConstant: 52.scalePt()),

            // NameLabel - 調整 top 約束，直接基於 topAnchor
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 35.scalePt()),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),

            // SetIdLabel
            setIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.scalePt()),
            setIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            
            // InviteTableView - 根據UI設計調整間距
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

            friendTabButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scalePt()),
            friendTabTopConstraintToSetIdLabel,
            
            // Chat Tab Button
            chatTabButton.centerYAnchor.constraint(equalTo: friendTabButton.centerYAnchor, constant: 0.scalePt()),
            chatTabButton.leadingAnchor.constraint(equalTo: friendTabButton.trailingAnchor, constant: 36.scalePt()),
            
            indicatorView.topAnchor.constraint(equalTo: friendTabButton.bottomAnchor, constant: 9.scalePt()),
            indicatorCenterXConstraint,
            indicatorView.widthAnchor.constraint(equalToConstant: 20.scalePt()),
            indicatorView.heightAnchor.constraint(equalToConstant: 4.scalePt()),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2 / UIScreen.main.scale)
        ])
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
        
        // 根據是否顯示堆疊效果來選擇約束
        if !stackedBackgroundView1.isHidden {
            friendTabTopConstraintToInviteTableView.isActive = true
            friendTabTopConstraintToSetIdLabel.isActive = false
        } else {
            friendTabTopConstraintToInviteTableView.isActive = !inviteTableView.isHidden
            friendTabTopConstraintToSetIdLabel.isActive = inviteTableView.isHidden
        }
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
        var baseHeight: CGFloat = 137.scalePt()
        let inviteCount = allInvitesFriends.count
        
        if inviteCount == 0 {
            return baseHeight
        } else {
            let displayCount = getDisplayCount()
            let tableViewHeight = CGFloat(displayCount) * 80
            if displayCount == 1 {
                baseHeight = baseHeight + CGFloat(32.scalePt())
            } else {
                baseHeight = baseHeight + CGFloat(42.scalePt())
            }
            print("totalHeight",displayCount, baseHeight + tableViewHeight)
            return baseHeight + tableViewHeight
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
    
    // 新增：單純縮合列表的方法
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
        
        // 5. 計算新的總高度並通過completion回調
        let newHeight = calculateTotalHeight()
        completion(newHeight)
    }
}

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
