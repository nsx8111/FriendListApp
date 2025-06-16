import UIKit

class TabBarView: UIView {

    private var tabButtons: [UIButton] = []
    private let tabImages = ["money", "friends", "ko", "accounting", "setting"]
    private let topLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        return line
    }()
    
    var onTabSelected: ((Int) -> Void)? // callback 傳出去

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabs()
        updateSelectedTab(index: 1) // 預設選中「朋友」
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabs() {
        backgroundColor = .white

        addSubview(topLine)
        topLine.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLine.topAnchor.constraint(equalTo: topAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 2 / UIScreen.main.scale)
        ])
        
        // 建立 button
        for i in 0..<tabImages.count {
            let button = UIButton(type: .custom)
            let img = UIImage(named: tabImages[i])
            button.setImage(img, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            tabButtons.append(button)
        }

        // money
        NSLayoutConstraint.activate([
            tabButtons[0].leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25.scalePt()),
            tabButtons[0].bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -3.scalePt()),
            tabButtons[0].widthAnchor.constraint(equalToConstant: 28.scalePt()),
            tabButtons[0].heightAnchor.constraint(equalToConstant: 46.scalePt())
        ])

        // friends
        NSLayoutConstraint.activate([
            tabButtons[1].leadingAnchor.constraint(equalTo: tabButtons[0].trailingAnchor, constant: 46.scalePt()),
            tabButtons[1].bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -3.scalePt()),
            tabButtons[1].widthAnchor.constraint(equalToConstant: 28.scalePt()),
            tabButtons[1].heightAnchor.constraint(equalToConstant: 46.scalePt())
        ])

        // ko（底部 0pt，不加背景、不加圓角、不加陰影！）
        NSLayoutConstraint.activate([
            tabButtons[2].centerXAnchor.constraint(equalTo: centerXAnchor),
            tabButtons[2].bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.scalePt()),
            tabButtons[2].widthAnchor.constraint(equalToConstant: 85.scalePt()),
            tabButtons[2].heightAnchor.constraint(equalToConstant: 68.scalePt())
        ])
        // 👆 KO 不要加 backgroundColor / cornerRadius / shadow → 保留 PNG 原圖透明背景！

        // accounting
        NSLayoutConstraint.activate([
            tabButtons[3].trailingAnchor.constraint(equalTo: tabButtons[4].leadingAnchor, constant: -46.scalePt()),
            tabButtons[3].bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -3.scalePt()),
            tabButtons[3].widthAnchor.constraint(equalToConstant: 28.scalePt()),
            tabButtons[3].heightAnchor.constraint(equalToConstant: 46.scalePt())
        ])

        // setting
        NSLayoutConstraint.activate([
            tabButtons[4].trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25.scalePt()),
            tabButtons[4].bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -3.scalePt()),
            tabButtons[4].widthAnchor.constraint(equalToConstant: 28.scalePt()),
            tabButtons[4].heightAnchor.constraint(equalToConstant: 46.scalePt())
        ])
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        updateSelectedTab(index: sender.tag)
        onTabSelected?(sender.tag)
    }
    
    func updateSelectedTab(index: Int) {
        for (i, button) in tabButtons.enumerated() {
            if i == 2 {
                // KO 不做 tint 處理，保持原圖
                button.setImage(UIImage(named: tabImages[i]), for: .normal)
                button.tintColor = nil
            } else {
                if i == index {
                    button.tintColor = .systemPink
                    button.setImage(UIImage(named: tabImages[i])?.withRenderingMode(.alwaysTemplate), for: .normal)
                } else {
                    button.tintColor = .gray
                    button.setImage(UIImage(named: tabImages[i])?.withRenderingMode(.alwaysTemplate), for: .normal)
                }
            }
        }
    }
}
