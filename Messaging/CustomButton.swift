//
//  CustomButton.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit

protocol BSAButtonDelegate: AnyObject {
    func didTapButton(_ tag: Int)
}

class CustomButton: UIView {
    var buttonTitle: String?
    var buttonTag: Int
    
    weak var delegate: BSAButtonDelegate?
    
    private lazy var button: UIButton! = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(buttonTitle: String = "", buttonTag: Int) {
        self.buttonTitle = buttonTitle
        self.buttonTag = buttonTag
        
        super.init(frame: .zero)
        
        self.addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        self.addConstraintsToViews()
        self.updateButtonUI()
    }
    
    @objc
    private func didTapButton() {
        self.delegate?.didTapButton(self.buttonTag)
    }
    
    private func addConstraintsToViews() {
        NSLayoutConstraint.activate([
            self.button.topAnchor.constraint(equalTo: self.topAnchor),
            self.button.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.button.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func updateButtonUI() {
        self.button.layer.backgroundColor = UIColor(named: "GradiantOne")!.cgColor
        self.button.layer.cornerRadius    = 8
        self.button.setTitleColor(.white, for: .normal)
        self.button.setTitle(self.buttonTitle, for: .normal)
        self.button.titleLabel?.font = UIFont.getCustomFont(fonts: .bold, size: 16)
        self.button.layer.borderWidth = 0
    }
}

