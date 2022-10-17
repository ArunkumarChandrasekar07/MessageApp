//
//  CustomTextField.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func bsaTextFieldDidEndEditing(_ textField: UITextField)
    func bsaTextFieldShouldBeginEditing(_ textField: UITextField) -> Bool
}

class CustomTextField: UIView {
        
    var textFieldType: TextFieldType
    var isLeftAccessoryView: Bool
    var isRightAccessoryView: Bool
    
    var textFieldTitle: String
    var textFieldPlaceholder: String
    
    var leftAccessoryViewImage: UIImage?
    var rightAccessoryViewImage: UIImage?
    
    private(set) var title: String = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.18
            self.titleString.attributedText = NSMutableAttributedString(string: "\(textFieldTitle)", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    
    private(set) var placeHolder: String = "" {
        didSet {
            self.textField.placeholder = self.textFieldPlaceholder
        }
    }
    
    weak var delegate: CustomTextFieldDelegate?
    
    private lazy var stackView: UIStackView! = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis          = .vertical
        stackView.alignment     = .leading
        stackView.distribution  = .fill
        stackView.contentMode   = .left
        stackView.spacing       = 6
        return stackView
    }()
    
    private lazy var titleString: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.alpha = 0.7
        label.textColor = UIColor(red: 0.278, green: 0.302, blue: 0.322, alpha: 1)
        label.font = UIFont.getCustomFont(fonts: .medium, size: 14.0)
        return label
    }()
    
    private lazy var textField: UITextField! = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.textColor = UIColor(red: 0.063, green: 0.093, blue: 0.157, alpha: 1)
        textField.font = UIFont.getCustomFont(fonts: .regular, size: 16)
        return textField
    }()
    
    
    init(textFieldType: TextFieldType, isLeftAccessoryView: Bool, isRightAccessoryView: Bool, textFieldTitle: String, textFieldPlaceholder: String, leftAccessoryViewImage: UIImage?, rightAccessoryViewImage: UIImage?, tag: Int) {
        self.textFieldType              = textFieldType
        self.isLeftAccessoryView        = isLeftAccessoryView
        self.isRightAccessoryView       = isRightAccessoryView
        self.textFieldTitle             = textFieldTitle
        self.textFieldPlaceholder       = textFieldPlaceholder
        self.leftAccessoryViewImage     = leftAccessoryViewImage
        self.rightAccessoryViewImage    = rightAccessoryViewImage
        
        super.init(frame: .zero)
        
        self.textField.tag              = tag
        
        self.addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(stackView)
        
        self.stackView.addArrangedSubview(titleString)
        self.stackView.addArrangedSubview(textField)
        
        self.textField.layer.backgroundColor = UIColor(red: 0.967, green: 0.967, blue: 0.967, alpha: 0.5).cgColor
        
        self.title = self.textFieldTitle
        self.placeHolder = self.textFieldPlaceholder
        
        if leftAccessoryViewImage != nil {
            self.textField.setLeftView(image: self.leftAccessoryViewImage!)
        }
        
        if rightAccessoryViewImage != nil {
            self.textField.setRightView(image: self.rightAccessoryViewImage!)
        }
        
        switch textFieldType {
        case .email:
            self.textField.keyboardType         = .emailAddress
            self.textField.isSecureTextEntry    = false
        case .password:
            self.textField.keyboardType         = .default
            self.textField.isSecureTextEntry    = true
        case .default:
            self.textField.keyboardType         = .default
            self.textField.isSecureTextEntry    = false
        }
        
        self.textField.delegate = self
        
        self.addConstraintsToViews()
    }
    
    private func addConstraintsToViews() {
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.titleString.heightAnchor.constraint(equalToConstant: 20),
            self.titleString.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            self.textField.heightAnchor.constraint(equalToConstant: 50),
            self.textField.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textField.layer.cornerRadius = 10
        self.textField.layer.borderWidth  = 1
        self.textField.layer.borderColor  = UIColor(red: 0.938, green: 0.938, blue: 0.938, alpha: 1).cgColor
    }
}


extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.bsaTextFieldDidEndEditing(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.bsaTextFieldShouldBeginEditing(textField) ?? true
    }
}


enum TextFieldType {
    case email
    case password
    case `default`
}
