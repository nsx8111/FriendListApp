//
//  Extension.swift
//  FriendListApp
//
//  Created by 洋洋 on 2025/6/10.
//

import UIKit

extension UIFont {
    enum PingFangWeight: String {
        case light = "PingFangTC-Light"
        case regular = "PingFangTC-Regular"
        case medium = "PingFangTC-Medium"
        case semibold = "PingFangTC-Semibold"
        case bold = "PingFangTC-Bold"
    }

    static func pingFangTC(_ weight: PingFangWeight = .regular, size: CGFloat) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}


extension CGFloat {
    func scalePt(baseWidth: CGFloat = 375.0) -> CGFloat {
        let scaleFactor = UIScreen.main.bounds.width / baseWidth
        return self * scaleFactor
    }
    
    func scalePtHeight(baseHeight: CGFloat = 667.0) -> CGFloat {
        let scaleFactor = UIScreen.main.bounds.height / baseHeight
        return self * scaleFactor
    }
}

extension Int {
    func scalePt(baseWidth: CGFloat = 375.0) -> CGFloat {
        let scaleFactor = UIScreen.main.bounds.width / baseWidth
        return CGFloat(self) * scaleFactor
    }
}
