//
//  StatusViewCollectionViewCell.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 15/10/22.
//

import UIKit

class StatusViewCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statusImageContainer: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var statusImage: UIImageView! = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Princess Sarah"
        label.font = UIFont.getCustomFont(fonts: .regular, size: 12)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    var profileName: String = "" {
        didSet {
            self.nameLabel.text = profileName
        }
    }
    
    var profileImage: UIImage? {
        didSet {
            self.statusImage.image = profileImage
            self.statusImage.tintColor = .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.statusImageContainer.layoutIfNeeded()
        self.statusImageContainer.layer.cornerRadius = (AppConstants.screenHeight * 0.07)/2
        self.statusImageContainer.layer.masksToBounds = true
        self.statusImageContainer.layer.borderWidth = 2
        self.statusImageContainer.layer.borderColor = UIColor(named: "GradiantOne")!.cgColor
        
        self.statusImage.layoutIfNeeded()
        self.statusImage.layer.cornerRadius = (AppConstants.screenHeight * 0.065)/2
        self.statusImage.layer.masksToBounds = true
    }
    
    private func addViews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.statusImageContainer)
        self.statusImageContainer.addSubview(self.statusImage)
        self.containerView.addSubview(self.nameLabel)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.statusImageContainer.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.statusImageContainer.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.statusImageContainer.heightAnchor.constraint(equalToConstant: AppConstants.screenHeight * 0.072),
            self.statusImageContainer.widthAnchor.constraint(equalToConstant: AppConstants.screenHeight * 0.072),
            
            self.statusImage.centerXAnchor.constraint(equalTo: self.statusImageContainer.centerXAnchor),
            self.statusImage.centerYAnchor.constraint(equalTo: self.statusImageContainer.centerYAnchor),
            self.statusImage.heightAnchor.constraint(equalToConstant: AppConstants.screenHeight * 0.065),
            self.statusImage.widthAnchor.constraint(equalToConstant: AppConstants.screenHeight * 0.065),
            
            self.nameLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.nameLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 2),
            self.nameLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -2),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.statusImage.image = nil
    }
}
