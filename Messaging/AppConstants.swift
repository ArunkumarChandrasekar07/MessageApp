//
//  AppConstants.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 14/10/22.
//

import UIKit

final class AppConstants {
    
    static var screenSize: CGRect {
        return UIScreen.main.bounds
    }
    
    static var screenWidth: CGFloat {
        return self.screenSize.width
    }
    
    static var screenHeight: CGFloat {
        return self.screenSize.height
    }
    
    static var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }
    
    static var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
