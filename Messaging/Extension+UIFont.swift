//
//  Extension+UIFont.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 14/10/22.
//

import UIKit

extension UIFont {
    
    enum Fonts {
        case thin
        case extraLight
        case light
        case regular
        case medium
        case semibold
        case bold
    }
    
    static func getCustomFont(fonts: Fonts, size: CGFloat = 16.0) -> UIFont {
        switch fonts {
        case .thin:
            return UIFont(name: "Inter-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
        case .extraLight:
            return UIFont(name: "Inter-ExtraLight", size: size) ?? UIFont.systemFont(ofSize: size)
        case .light:
            return UIFont(name: "Inter-Light", size: size) ?? UIFont.systemFont(ofSize: size)
        case .regular:
            return UIFont(name: "Inter-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        case .medium:
            return UIFont(name: "Inter-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        case .semibold:
            return UIFont(name: "Inter-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
        case .bold:
            return UIFont(name: "Inter-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}
