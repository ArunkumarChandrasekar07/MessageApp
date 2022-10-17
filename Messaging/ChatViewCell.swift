//
//  ChatViewCell.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit

class ChatViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ChatViewCell.self)
            
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.getCustomFont(fonts: .medium, size: 16)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    var textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatViewCell.blueBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(textBubbleView)
        self.addSubview(messageTextView)
                
        textBubbleView.addSubview(bubbleImageView)
        
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.messageTextView.text = nil
    }
}
