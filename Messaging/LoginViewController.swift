//
//  LoginViewController.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit

class LoginViewController: BaseViewController, CustomTextFieldDelegate, BSAButtonDelegate {
    
    private(set) var email: String = ""
    private(set) var password: String = ""
    
    private lazy var titleLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .bold, size: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "LOGIN/REGISTER"
        return label
    }()
    
    private lazy var signTypeSegment: UISegmentedControl! = {
        let segmentItems = ["Login", "Register"]
        let segmentControl: UISegmentedControl = UISegmentedControl(items: segmentItems)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private lazy var signStackView: UIStackView! = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis          = .vertical
        stackView.distribution  = .fill
        stackView.contentMode   = .left
        stackView.spacing       = 16
        return stackView
    }()
    
    private lazy var emailField: CustomTextField! = {
        let field: CustomTextField = CustomTextField(textFieldType: .email, isLeftAccessoryView: true, isRightAccessoryView: false, textFieldTitle: "Email", textFieldPlaceholder: "Enter email address", leftAccessoryViewImage: UIImage(systemName: "envelope"), rightAccessoryViewImage: nil, tag: 1)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var passwordField: CustomTextField! = {
        let field: CustomTextField = CustomTextField(textFieldType: .password, isLeftAccessoryView: true, isRightAccessoryView: true, textFieldTitle: "Password", textFieldPlaceholder: "Enter password", leftAccessoryViewImage: UIImage(systemName: "lock"), rightAccessoryViewImage: UIImage(systemName: "eye"), tag: 2)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var signinButton: CustomButton! = {
        let button: CustomButton = CustomButton(buttonTitle: "Login/Register", buttonTag: 11)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(signTypeSegment)
        self.view.addSubview(signStackView)
        
        self.signStackView.addArrangedSubview(emailField)
        self.signStackView.addArrangedSubview(passwordField)
        
        self.view.addSubview(signinButton)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.topBarView.centerXAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.topBarView.centerYAnchor, constant: 15),
            
            self.signTypeSegment.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signTypeSegment.topAnchor.constraint(equalTo: self.topBarView.bottomAnchor, constant: 15),
            self.signTypeSegment.widthAnchor.constraint(equalToConstant: AppConstants.screenWidth * 0.65),
            
            self.signStackView.topAnchor.constraint(equalTo: self.signTypeSegment.bottomAnchor, constant: 24),
            self.signStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signStackView.widthAnchor.constraint(equalToConstant: AppConstants.screenWidth * 0.90),
            
            self.signinButton.topAnchor.constraint(equalTo: signStackView.bottomAnchor, constant: 30),
            self.signinButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signinButton.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.90),
            self.signinButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        self.addDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func addDelegates() {
        self.emailField.delegate        = self
        self.passwordField.delegate     = self
        self.signinButton.delegate      = self
    }
    
    func bsaTextFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField.tag == 1 {
            self.email = text
        }else {
            self.password = text
        }
    }
    
    func bsaTextFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func basicShowAlertVC(_ title: String, message: String) {
        let alertVC     = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss     = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(dismiss)
        self.present(alertVC, animated: true)
    }
    
    func didTapButton(_ tag: Int) {
        self.view.endEditing(true)
        
        if email == "" {
            self.basicShowAlertVC("Invalid Email", message: "Email can not be empty!!")
            return
        }
        
        if !isValidEmail(email) {
            self.basicShowAlertVC("Invalid Email", message: "Email can not be empty!!")
            return
        }
        
        if password == "" {
            self.basicShowAlertVC("Invalid Password", message: "Password can not be empty!!")
            return
        }
        
        let spinner = Spinner.init()
        spinner.show()
        if self.signTypeSegment.selectedSegmentIndex == 1 { // Register
            FirebaseAuthenticator.sharedInstance.createNewUser(with: self.email, password: self.password) { user, message in
                DispatchQueue.main.async {
                    spinner.hide()
                }
                if let firebaseUser = user {
                    print(firebaseUser)
                    UserDefaults.isUserLoggedIn = true
                    UserDefaults.userId = firebaseUser.uid
                    let alertVC     = UIAlertController(title: "Register Success", message: message, preferredStyle: .alert)
                    let dismiss     = UIAlertAction(title: "Ok", style: .default) { _ in
                        DispatchQueue.main.async {
                            AppConstants.appDelegate.updateParentView()
                        }
                    }
                    alertVC.addAction(dismiss)
                    self.present(alertVC, animated: true)
                }else {
                    let alertVC     = UIAlertController(title: "Register Error", message: message, preferredStyle: .alert)
                    let dismiss     = UIAlertAction(title: "Dismiss", style: .default)
                    let tryLogin    = UIAlertAction(title: "Try Login", style: .destructive) { _ in
                        self.signTypeSegment.selectedSegmentIndex = 0
                    }
                    alertVC.addAction(dismiss)
                    alertVC.addAction(tryLogin)
                    self.present(alertVC, animated: true)
                }
            }
        }else { // Login
            FirebaseAuthenticator.sharedInstance.signInUser(with: self.email, password: self.password) { user, message in
                DispatchQueue.main.async {
                    spinner.hide()
                }
                if let firebaseUser = user {
                    UserDefaults.isUserLoggedIn = true
                    UserDefaults.userId = firebaseUser.uid
                    let alertVC     = UIAlertController(title: "Login Success", message: message, preferredStyle: .alert)
                    let dismiss     = UIAlertAction(title: "Ok", style: .default) { _ in
                        DispatchQueue.main.async {
                            AppConstants.appDelegate.updateParentView()
                        }
                    }
                    alertVC.addAction(dismiss)
                    self.present(alertVC, animated: true)
                }else {
                    let alertVC     = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
                    let dismiss     = UIAlertAction(title: "Dismiss", style: .default)
                    alertVC.addAction(dismiss)
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
}
