
import UIKit

class NavigationBarView: UIView {
    private var indicatorCenterXConstraint: NSLayoutConstraint!

    let friendTabButton = UIButton()
    let chatTabButton = UIButton()
    private let indicatorView = UIView()
    private let atmButton = UIButton()
    private let transferButton = UIButton()
    private let qrButton = UIButton()
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
    
    private var allInvitesFriends: [Friend] = [] {
        didSet {
            inviteTableView.reloadData()
            inviteTableView.isHidden = allInvitesFriends.isEmpty
        }
    }
    
    var userName: String = "紫琳" {
        didSet {
            nameLabel.text = userName
        }
    }
    
    var kokoID: String = "" {
        didSet {
            setIdLabel.text = "設定 KOKO ID：\(kokoID) >"
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
        atmButton.setImage(UIImage(named: "atm"), for: .normal)
        transferButton.setImage(UIImage(named: "$"), for: .normal)
        qrButton.setImage(UIImage(named: "qr"), for: .normal)
        avatarView.image = UIImage(named: "avatar")

        // avatar 圓角保持
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 52.scalePt() / 2

        // 文字設定
        nameLabel.text = userName
        nameLabel.font = .pingFangTC(.medium, size: 17.scalePt())
        nameLabel.textColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1.0)

        setIdLabel.text = "設定 KOKO ID：\(kokoID) >"
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

        // 加入 subviews
        [atmButton, transferButton, qrButton, avatarView, nameLabel, setIdLabel, inviteTableView, friendTabButton, chatTabButton, indicatorView, bottomLine].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: friendTabButton.centerXAnchor)
        
        inviteTableView.delegate = self
        inviteTableView.dataSource = self
        inviteTableView.register(InviteListCell.self, forCellReuseIdentifier: "InviteCell")

        // 設定 constraint
        NSLayoutConstraint.activate([
            // QR
            qrButton.topAnchor.constraint(equalTo: topAnchor, constant: 0.scalePt()),
            qrButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scalePt()),
            
            // ATM
            atmButton.centerYAnchor.constraint(equalTo: qrButton.centerYAnchor, constant: 0.scalePt()),
            atmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scalePt()),

            // Transfer
            transferButton.centerYAnchor.constraint(equalTo: qrButton.centerYAnchor, constant: 0.scalePt()),
            transferButton.leadingAnchor.constraint(equalTo: atmButton.trailingAnchor, constant: 24.scalePt()),
            
            qrButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            qrButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),
            atmButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            atmButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),
            transferButton.widthAnchor.constraint(equalToConstant: 24.scalePt()),
            transferButton.heightAnchor.constraint(equalToConstant: 24.scalePt()),
            
            // Avatar
            avatarView.topAnchor.constraint(equalTo: qrButton.bottomAnchor, constant: 27.scalePt()),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scalePt()),
            avatarView.widthAnchor.constraint(equalToConstant: 52.scalePt()),
            avatarView.heightAnchor.constraint(equalToConstant: 52.scalePt()),

            // NameLabel
            nameLabel.topAnchor.constraint(equalTo: atmButton.bottomAnchor, constant: 35.scalePt()),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),

            // SetIdLabel
            setIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.scalePt()),
            setIdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scalePt()),
            
            inviteTableView.topAnchor.constraint(equalTo: setIdLabel.bottomAnchor, constant: 20.scalePt()),
            inviteTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scalePt()),
            inviteTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scalePt()),
            inviteTableView.heightAnchor.constraint(equalToConstant: 140.scalePt()), // 可根據邀請數改動高度

            // Friend Tab Button
            friendTabButton.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12.scalePt()),
            friendTabButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scalePt()),
            
            // Chat Tab Button
            chatTabButton.centerYAnchor.constraint(equalTo: friendTabButton.centerYAnchor, constant: 0.scalePt()),
            chatTabButton.leadingAnchor.constraint(equalTo: friendTabButton.trailingAnchor, constant: 36.scalePt()),
            
            indicatorView.topAnchor.constraint(equalTo: friendTabButton.bottomAnchor, constant: 4.scalePt()),
            indicatorCenterXConstraint, // 用 centerXAnchor 跟 friendTabButton 綁定
            indicatorView.widthAnchor.constraint(equalToConstant: 20.scalePt()),
            indicatorView.heightAnchor.constraint(equalToConstant: 4.scalePt()),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor), // 保證包住
            
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2 / UIScreen.main.scale)
        ])
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
    
    func updateInvitesList(_ friends: [Friend]) {
        allInvitesFriends = friends.filter { $0.status == 2 }
    }
}



extension NavigationBarView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allInvitesFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as? InviteListCell else {
            return UITableViewCell()
        }
        cell.configure(with: allInvitesFriends[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.scalePt()
    }
}
