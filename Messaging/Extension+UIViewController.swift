//
//  Extension+UIViewController.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 14/10/22.
//

import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
        return AppConstants.statusBarHeight +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
