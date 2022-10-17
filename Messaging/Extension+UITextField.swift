//
//  Extension+UITextField.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit

extension UITextField {
    func setLeftView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 15, y: 12, width: 25, height: 25)) // set your Own size
        iconView.image = image.withRenderingMode(.alwaysTemplate)
        iconView.image?.withTintColor(UIColor(red: 0.573, green: 0.6, blue: 0.627, alpha: 1))
        iconView.contentMode = .scaleAspectFit
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
    }
    
    func setRightView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 15, y: 15, width: 25, height: 20)) // set your Own size
        iconView.image = image.withRenderingMode(.alwaysTemplate)
        iconView.image?.withTintColor(UIColor(red: 0.573, green: 0.6, blue: 0.627, alpha: 1))
        iconView.contentMode = .scaleAspectFit
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }
}
