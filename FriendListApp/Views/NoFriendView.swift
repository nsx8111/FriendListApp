import UIKit

import UIKit

class NoFriendView: UIView {
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "add_friend_illustration") ?? UIImage()
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "就從加好友開始吧：）"
        label.font = .pingFangTC(.medium, size: 21.scalePt())
        label.textColor = UIColor(red: 71/255.0, green: 71/255.0, blue: 71/255.0, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        label.font = .pingFangTC(.regular, size: 14.scalePt())
        label.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .custom)

        // 文字設定
        button.setTitle("加好友", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pingFangTC(.medium, size: 16.scalePt())

        // 圓角 + clips
        button.layer.cornerRadius = 20.scalePt()
        button.clipsToBounds = true

        // GradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 86/255.0, green: 179/255.0, blue: 11/255.0, alpha: 1).cgColor,
            UIColor(red: 166/255.0, green: 204/255.0, blue: 66/255.0, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 20.scalePt()

        // 預設 frame 設一個固定值 → 你後續 layout 再約束 width / height → 會自動更新 gradientLayer.frame
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 192.scalePt(), height: 40.scalePt())
        button.layer.insertSublayer(gradientLayer, at: 0)

        // 建立右側小 icon
        let iconImageView = UIImageView(image: UIImage(named: "add_friend_icon"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // 把 icon 加到 button 裡
        button.addSubview(iconImageView)

        // 設定 layout constraint
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8.scalePt()),
            iconImageView.widthAnchor.constraint(equalToConstant: 24.scalePt()), // 可依你的 icon 圖檔大小調整
            iconImageView.heightAnchor.constraint(equalToConstant: 24.scalePt())
        ])

        return button
    }()
    
    private let helpContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "幫助好友更快找到你？"
        label.font = .pingFangTC(.regular, size: 13.scalePt())
        label.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    private let setKokoIdLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "設定 KOKO ID")
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 236/255.0, green: 0/255.0, blue: 140/255.0, alpha: 1), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.font = .pingFangTC(.regular, size: 13.scalePt())
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
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
    
    private var allFriends: [Friend] = []      // 原始完整資料
    private var filteredFriends: [Friend] = [] // 顯示用的資料
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFriendList(_ friends: [Friend]) {
        allFriends = friends
        filteredFriends = friends
        tableView.reloadData()
        if filteredFriends.count == 0 {
            tableView.isHidden = true
        }
    }
    
    private func setupView() {
        [helpLabel, setKokoIdLabel].forEach {
            helpContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [imageView, titleLabel, descLabel, addButton, helpContainerView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [tableView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            helpLabel.leadingAnchor.constraint(equalTo: helpContainerView.leadingAnchor),
            helpLabel.topAnchor.constraint(equalTo: helpContainerView.topAnchor),
            helpLabel.bottomAnchor.constraint(equalTo: helpContainerView.bottomAnchor),

            setKokoIdLabel.trailingAnchor.constraint(equalTo: helpContainerView.trailingAnchor),
            setKokoIdLabel.topAnchor.constraint(equalTo: helpContainerView.topAnchor),
            setKokoIdLabel.bottomAnchor.constraint(equalTo: helpContainerView.bottomAnchor),

            helpLabel.trailingAnchor.constraint(equalTo: setKokoIdLabel.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
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
        ])
    }
}
