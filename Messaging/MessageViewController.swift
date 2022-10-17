//
//  MessageViewController.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit
import Firebase
import FirebaseFirestore

class MessageViewController: BaseViewController {
    
    private lazy var topProfileView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton! = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
        return button
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
    
    private lazy var profileInfoStackView: UIStackView! = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var profileNameLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .medium, size: 15)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Gunther Beard"
        return label
    }()
    
    private lazy var activityLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getCustomFont(fonts: .regular, size: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "28 minutes ago"
        return label
    }()
    
    private lazy var messageCollectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection  = .vertical
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ChatViewCell.self, forCellWithReuseIdentifier: ChatViewCell.identifier)
        return collectionView
    }()
    
    private lazy var textInputView: UIView! = {
        let inputView: UIView = UIView()
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.backgroundColor = .systemBackground
        return inputView
    }()
    
    private lazy var textInputStackView: UIStackView! = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    
    private lazy var chatTextField: UITextField! = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .default
        textField.placeholder = "Enter Message here"
        textField.font = UIFont.getCustomFont(fonts: .regular, size: 16)
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 13
        textField.returnKeyType = .send
        textField.borderStyle = .none
        return textField
    }()
    
    private var inputViewBottomConstraint: NSLayoutConstraint!
    
    private lazy var sendButton: UIButton! = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "sendIcon")!, for: .normal)
        button.addTarget(self, action: #selector(onSendChat(_:)), for: .touchUpInside)
        return button
    }()
        
    private var messages: [Chat] = []
    
    private var reference: CollectionReference?
    private var messageListener: ListenerRegistration?
    
    private let dataStore = FirebaseDataStore()
    
    var channel: FirebaseChatChannel
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.addSubViews()
        
        self.assignDelegates()
        
        self.manageInputEventsForTheSubViews()
        
        reference = db.collection(["channels", channel.id, "thread"].joined(separator: "/"))
        
        self.dataStore.checkPath(path: ["channels", channel.id, "thread"], dbRepresentation: channel.representation)
        
        messageListener = reference?.addSnapshotListener { [self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                handleDocumentChange(change)
            }
        }
    }
    
    init(channel: FirebaseChatChannel) {
        self.channel = channel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    deinit {
      messageListener?.remove()
    }
    
    private func saveMessage(_ chat: Chat) {
        print("saving message: \(chat.representation)")
        reference?.addDocument(data: chat.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var message = Chat(document: change.document) else {
            return
        }
        switch change.type {
        case .added:
            insertNewMessage(message)
        default:
            break
        }
    }
    
    private func insertNewMessage(_ message: Chat) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        self.messageCollectionView.reloadData()
    }
    
    private func addSubViews() {
        self.view.addSubview(topProfileView)
        
        self.topProfileView.addSubview(backButton)
        
        self.topProfileView.addSubview(imageContainer)
        self.imageContainer.addSubview(profileImageView)
        
        self.topProfileView.addSubview(profileInfoStackView)
        self.profileInfoStackView.addArrangedSubview(profileNameLabel)
        self.profileInfoStackView.addArrangedSubview(activityLabel)
        
        self.view.addSubview(messageCollectionView)
        self.view.addSubview(textInputView)
        
        self.textInputView.addSubview(textInputStackView)
        self.textInputStackView.addArrangedSubview(self.chatTextField)
        self.textInputStackView.addArrangedSubview(self.sendButton)
        
        self.addConstraintsToViews()
    }
    
    private func addConstraintsToViews() {
        
        self.inputViewBottomConstraint = self.textInputView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        self.inputViewBottomConstraint.constant = 0
        
        NSLayoutConstraint.activate([
            self.topProfileView.bottomAnchor.constraint(equalTo: self.topBarView.bottomAnchor),
            self.topProfileView.leftAnchor.constraint(equalTo: self.topBarView.leftAnchor),
            self.topProfileView.rightAnchor.constraint(equalTo: self.topBarView.rightAnchor),
            self.topProfileView.heightAnchor.constraint(equalToConstant: self.topbarHeight - 20),
            
            self.backButton.leftAnchor.constraint(equalTo: self.topProfileView.leftAnchor, constant: 5),
            self.backButton.centerYAnchor.constraint(equalTo: self.topProfileView.centerYAnchor),
            self.backButton.widthAnchor.constraint(equalToConstant: 40),
            self.backButton.heightAnchor.constraint(equalToConstant: 40),
            
            self.imageContainer.topAnchor.constraint(equalTo: self.topProfileView.topAnchor),
            self.imageContainer.leftAnchor.constraint(equalTo: self.backButton.rightAnchor),
            self.imageContainer.bottomAnchor.constraint(equalTo: self.topProfileView.bottomAnchor),
            self.imageContainer.widthAnchor.constraint(equalToConstant: 60),
            
            self.profileImageView.centerXAnchor.constraint(equalTo: self.imageContainer.centerXAnchor),
            self.profileImageView.centerYAnchor.constraint(equalTo: self.imageContainer.centerYAnchor),
            self.profileImageView.widthAnchor.constraint(equalToConstant: 50),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            self.profileInfoStackView.centerYAnchor.constraint(equalTo: self.topProfileView.centerYAnchor),
            self.profileInfoStackView.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 15),
            self.profileInfoStackView.rightAnchor.constraint(equalTo: self.topProfileView.rightAnchor),
            
            self.activityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.inputViewBottomConstraint,
            self.textInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.textInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.textInputView.heightAnchor.constraint(equalToConstant: 50),
            
            self.messageCollectionView.topAnchor.constraint(equalTo: self.topProfileView.bottomAnchor),
            self.messageCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.messageCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.messageCollectionView.bottomAnchor.constraint(equalTo: self.textInputView.topAnchor, constant: -8),
            
            self.textInputStackView.topAnchor.constraint(equalTo: self.textInputView.topAnchor, constant: 2),
            self.textInputStackView.leftAnchor.constraint(equalTo: self.textInputView.leftAnchor, constant: 15),
            self.textInputStackView.rightAnchor.constraint(equalTo: self.textInputView.rightAnchor, constant: -15),
            self.textInputStackView.bottomAnchor.constraint(equalTo: self.textInputView.bottomAnchor, constant: -2),
            
            self.chatTextField.heightAnchor.constraint(equalTo: self.textInputStackView.heightAnchor),
            self.sendButton.widthAnchor.constraint(equalTo: self.textInputStackView.widthAnchor, multiplier: 0.175),
            self.sendButton.heightAnchor.constraint(equalTo: self.textInputStackView.heightAnchor, multiplier: 1),
        ])
    }
    
    private func assignDelegates() {
        
        self.messageCollectionView.register(ChatViewCell.self, forCellWithReuseIdentifier: ChatViewCell.identifier)
        self.messageCollectionView.dataSource = self
        self.messageCollectionView.delegate = self
        
        self.chatTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.profileImageView.layoutIfNeeded()
        self.profileImageView.layer.cornerRadius = 50 / 2
        self.profileImageView.layer.masksToBounds = true
        
        self.textInputView.layoutIfNeeded()
        self.textInputView.layer.cornerRadius = 50 / 2
        self.textInputView.layer.masksToBounds = true
        self.textInputView.layer.borderWidth = 1
        self.textInputView.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    @objc
    func onSendChat(_ sender: UIButton?) {
        guard let chatText = chatTextField.text, chatText.count >= 1 else { return }
        chatTextField.text = ""
        let chat = Chat(user_name: UserDefaults.userName!, text: chatText, createdAt: Date(), is_sent_by_me: true)
        saveMessage(chat)
    }
    
    @objc
    private func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func manageInputEventsForTheSubViews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardFrameChangeNotfHandler(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            inputViewBottomConstraint.constant = isKeyboardShowing ? -(keyboardFrame.height + 20) : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing {
                    let lastItem = self.messages.count - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.messageCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
}

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = messageCollectionView.dequeueReusableCell(withReuseIdentifier: ChatViewCell.identifier, for: indexPath) as? ChatViewCell {
            
            let chat = messages[indexPath.item]
            
            cell.messageTextView.text = chat.text
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrame = NSString(string: chat.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.getCustomFont(fonts: .medium, size: 16)], context: nil)
            
            if !chat.is_sent_by_me {
                cell.textBubbleView.frame = CGRect(x: 10, y: 0, width: estimatedFrame.width + 52, height: estimatedFrame.height + 30)
                cell.messageTextView.frame = CGRect(x: 25, y: 6, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
                cell.bubbleImageView.image = ChatViewCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
            } else {
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 52, y: -4, width: estimatedFrame.width + 50, height: estimatedFrame.height + 20 + 6)
                cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 45, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.bubbleImageView.image = ChatViewCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor(named: "GradiantOne")
                cell.messageTextView.textColor = UIColor.white
            }
            return cell
        }
        return ChatViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let chat = messages[indexPath.item]
        let size = CGSize(width: AppConstants.screenWidth * 0.6, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: chat.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.getCustomFont(fonts: .medium, size: 16)], context: nil)
        
        return CGSize(width: messageCollectionView.frame.width, height: estimatedFrame.height + 25)
    }
}

extension MessageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let txt = textField.text, txt.count >= 1 {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        onSendChat(nil)
    }
}
