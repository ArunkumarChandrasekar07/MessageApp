//
//  CommentsTableViewCell.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 18/10/22.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    static var identifier: String {
        return String(describing: CommentsTableViewCell.self)
    }
    
    private lazy var containerView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private var commentsStackView: UIStackView! = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var nameLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .semibold, size: 16)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var commentsLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .regular, size: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var comment: Comments = .init(postId: 0, id: 0, name: "", email: "", body: "") {
        didSet {
            self.nameLabel.text = comment.name
            self.commentsLabel.text = comment.body
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.contentView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.commentsStackView)
        
        self.commentsStackView.addArrangedSubview(nameLabel)
        self.commentsStackView.addArrangedSubview(commentsLabel)
        
        NSLayoutConstraint.activate([
            
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            self.containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            self.containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2),
            
            self.commentsStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10),
            self.commentsStackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10),
            self.commentsStackView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -10),
            self.commentsStackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -10),
            
            self.nameLabel.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.layoutIfNeeded()
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
