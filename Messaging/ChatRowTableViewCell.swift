//
//  ChatRowTableViewCell.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 15/10/22.
//

import UIKit

class ChatRowTableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageContainer: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var profileImageView: UIImageView! = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "profile_Icon_Two") //profile_Icon_One
        return imageView
    }()
    
    private lazy var profileInfoStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var profileNameLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .medium, size: 14)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Gunther Beard"
        return label
    }()
    
    private lazy var messageLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .regular, size: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "Candidates should build a chatting system with design standards as shown above. A chat messenger should be set up using firebase."
        return label
    }()
    
    private lazy var timeLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .regular, size: 13)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "4 hour"
        return label
    }()
    
    private lazy var messageCountView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "GradiantTwo")
        return view
    }()
    
    private lazy var messageCountLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .light, size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "99+"
        return label
    }()
    
    var profileName: String = "" {
        didSet {
            self.profileNameLabel.text = profileName
        }
    }
    
    var profileDescription: String = "" {
        didSet {
            self.messageLabel.text = profileDescription
        }
    }
    
    var profileImage: String = "" {
        didSet {
            self.profileImageView.image = UIImage(named: profileImage) ?? UIImage(named: "profile_Icon_Two")
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addViews()
        
        self.messageCountView.isHidden = true
        self.messageCountLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.contentView.addSubview(containerView)
        
        self.containerView.addSubview(imageContainer)
        
        self.imageContainer.addSubview(profileImageView)
        
        self.containerView.addSubview(profileInfoStackView)
        
        self.profileInfoStackView.addArrangedSubview(profileNameLabel)
        self.profileInfoStackView.addArrangedSubview(messageLabel)
        
        self.containerView.addSubview(timeLabel)
        
        self.containerView.addSubview(messageCountView)
        self.messageCountView.addSubview(messageCountLabel)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2.5),
            self.containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2.5),
            
            self.imageContainer.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.imageContainer.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.imageContainer.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.imageContainer.widthAnchor.constraint(equalToConstant: 80),
            
            self.profileImageView.centerXAnchor.constraint(equalTo: self.imageContainer.centerXAnchor),
            self.profileImageView.centerYAnchor.constraint(equalTo: self.imageContainer.centerYAnchor),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 55),
            self.profileImageView.widthAnchor.constraint(equalToConstant: 55),
            
            self.profileInfoStackView.leftAnchor.constraint(equalTo: self.imageContainer.rightAnchor),
            self.profileInfoStackView.rightAnchor.constraint(equalTo: self.timeLabel.leftAnchor),
            self.profileInfoStackView.topAnchor.constraint(equalTo: self.imageContainer.topAnchor),
            self.profileInfoStackView.bottomAnchor.constraint(equalTo: self.imageContainer.bottomAnchor),
            
            self.profileNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            self.timeLabel.centerYAnchor.constraint(equalTo: self.profileNameLabel.centerYAnchor),
            self.timeLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -5),
            self.timeLabel.widthAnchor.constraint(equalToConstant: 45),
            self.timeLabel.heightAnchor.constraint(equalToConstant: 25),
            
            self.messageCountView.centerYAnchor.constraint(equalTo: self.messageLabel.centerYAnchor),
            self.messageCountView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -5),
            self.messageCountView.widthAnchor.constraint(equalToConstant: 30),
            self.messageCountView.heightAnchor.constraint(equalToConstant: 30),
            
            self.messageCountLabel.centerXAnchor.constraint(equalTo: self.messageCountView.centerXAnchor),
            self.messageCountLabel.centerYAnchor.constraint(equalTo: self.messageCountView.centerYAnchor),
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.layoutIfNeeded()
        self.profileImageView.layer.cornerRadius = 55 / 2
        self.profileImageView.layer.masksToBounds = true
        
        self.messageCountView.layoutIfNeeded()
        self.messageCountView.layer.cornerRadius = 30 / 2
        self.messageCountView.layer.masksToBounds = true
    }

}
