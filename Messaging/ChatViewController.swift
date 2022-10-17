//
//  ChatViewController.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 14/10/22.
//

import UIKit
import FirebaseAuth

class ChatViewController: BaseViewController {
    
    private lazy var scrollView: UIScrollView! = {
        let scrollview: UIScrollView = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.showsVerticalScrollIndicator = false
        return scrollview
    }()
    
    private lazy var containerView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var searchBarView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var searchImage: UIImageView! = {
        let view: UIImageView = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        view.contentMode = .scaleAspectFit
        view.tintColor = .gray
        return view
    }()
    
    private lazy var searchTextField: MessageTextField! = {
        let textField: MessageTextField = MessageTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.masksToBounds = true
        textField.placeholder = "Search"
        return textField
    }()
    
    private lazy var cameraButtonView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var cameraIcon: UIImageView! = {
        let view: UIImageView = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image          = UIImage(systemName: "camera")?.withRenderingMode(.alwaysTemplate)
        view.contentMode    = .scaleAspectFit
        view.tintColor      = UIColor(named: "GradiantTwo")
        return view
    }()
    
    private lazy var statusView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var statusCollectionView: UICollectionView! = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset     = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize         = CGSize(width: AppConstants.screenHeight * 0.095, height: AppConstants.screenHeight * 0.09)
        layout.scrollDirection  = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StatusViewCollectionViewCell.self, forCellWithReuseIdentifier: "StatusViewCollectionViewCell")
        return collectionView
    }()
    
    private lazy var lineView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var mainView: UIView! = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var chatListTableView: UITableView! = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ChatRowTableViewCell.self, forCellReuseIdentifier: "ChatRowTableViewCell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var scrollViewContentHeight: CGFloat = 0
    
    private var tableViewHeightConstaints: NSLayoutConstraint!
    
    private(set) var chatListUsers: [ChatUsers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollViewContentHeight = ((AppConstants.screenHeight) - (self.topbarHeight + 30))
        
        self.addSubViews()
        
        self.searchTextField.delegate = self
        self.searchTextField.returnKeyType = .search
        
        self.statusCollectionView.dataSource    = self
        self.statusCollectionView.delegate      = self
        
        self.chatListTableView.dataSource       = self
        self.chatListTableView.delegate         = self
        
        self.scrollView.delegate                = self
        self.scrollView.bounces                 = true
        self.chatListTableView.bounces          = false
        self.chatListTableView.isScrollEnabled  = false
        self.chatListTableView.allowsSelection  = true
        
        self.fetchUserList()
        
        if let currentUser = Auth.auth().currentUser {
            if currentUser.displayName == nil || currentUser.displayName == "" {
                self.getUserName()
            }else {
                UserDefaults.userName = currentUser.displayName!
            }
        } else {
            
        }
    }
    
    private func getUserName() {
        let alertController = UIAlertController(title: "Update Display name", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter User Name"
        }

        let saveAction = UIAlertAction(title: "Update", style: .default, handler: { alert -> Void in
            let nameField = alertController.textFields![0] as UITextField
            self.updateUserName(with: nameField.text!)
        })
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateUserName(with name: String) {
        if name == "" {
            let alertController = UIAlertController(title: "Display Name Error", message: "Name cannot be empty", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Retry", style: .default) { action in
                self.getUserName()
            }
            alertController.addAction(saveAction)

            self.present(alertController, animated: true, completion: nil)
        }
        let spinner = Spinner.init()
        spinner.show()
        if let currentUser = Auth.auth().currentUser {
            let changeRequest = currentUser.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                spinner.hide()
            }
        }else {
            spinner.hide()
        }
    }
    
    private func fetchUserList() {
        let spinner = Spinner.init()
        spinner.show()
        if let url = Bundle.main.url(forResource: "chatusers", withExtension: "json") {
            DispatchQueue.main.async {
                spinner.hide()
            }
            do {
                let data = try Data.init(contentsOf: url)
                let decoder = JSONDecoder.init()
                self.chatListUsers = try decoder.decode([ChatUsers].self, from: data)
                self.statusCollectionView.reloadData()
                self.chatListTableView.reloadData()
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        self.searchBarView.layer.cornerRadius = self.searchBarView.frame.height / 2
        self.searchTextField.layer.cornerRadius = self.searchBarView.frame.height / 2
        self.cameraButtonView.layer.cornerRadius = self.cameraButtonView.frame.height / 2
    }
    
    private func addSubViews() {
        self.view.addSubview(searchBarView)
        self.searchBarView.addSubview(searchImage)
        self.searchBarView.addSubview(searchTextField)
        
        self.view.addSubview(cameraButtonView)
        self.cameraButtonView.addSubview(cameraIcon)
        
        self.view.addSubview(self.mainView)
        
        self.mainView.addSubview(self.scrollView)
        
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.contentSize = .init(width: AppConstants.screenWidth, height: 200)
        
        self.scrollView.addSubview(containerView)
        
        self.containerView.addSubview(statusView)
        self.statusView.addSubview(statusCollectionView)
        
        self.containerView.addSubview(lineView)
        
        self.containerView.addSubview(chatListTableView)
        
        self.addConstraintsToSubViews()
    }
    
    private let dataStore = FirebaseDataStore()
    
    private func addConstraintsToSubViews() {
        
        tableViewHeightConstaints = self.chatListTableView.heightAnchor.constraint(equalToConstant: 10 * 70)
        
        NSLayoutConstraint.activate([
            
            self.searchBarView.centerYAnchor.constraint(equalTo: self.topBarView.centerYAnchor, constant: 15),
            self.searchBarView.leftAnchor.constraint(equalTo: self.topBarView.leftAnchor, constant: 16),
            self.searchBarView.rightAnchor.constraint(equalTo: self.cameraButtonView.leftAnchor, constant: -16),
            self.searchBarView.heightAnchor.constraint(equalToConstant: 35),
            
            self.searchImage.centerYAnchor.constraint(equalTo: self.searchBarView.centerYAnchor),
            self.searchImage.heightAnchor.constraint(equalToConstant: 20),
            self.searchImage.widthAnchor.constraint(equalToConstant: 20),
            self.searchImage.leftAnchor.constraint(equalTo: self.searchBarView.leftAnchor, constant: 10),
            
            self.searchTextField.topAnchor.constraint(equalTo: self.searchBarView.topAnchor),
            self.searchTextField.rightAnchor.constraint(equalTo: self.searchBarView.rightAnchor),
            self.searchTextField.leftAnchor.constraint(equalTo: self.searchImage.rightAnchor, constant: 10),
            self.searchTextField.bottomAnchor.constraint(equalTo: self.searchBarView.bottomAnchor),
            
            self.cameraButtonView.rightAnchor.constraint(equalTo: self.topBarView.rightAnchor, constant: -15),
            self.cameraButtonView.centerYAnchor.constraint(equalTo: self.searchBarView.centerYAnchor),
            self.cameraButtonView.heightAnchor.constraint(equalToConstant: 30),
            self.cameraButtonView.widthAnchor.constraint(equalToConstant: 30),
            
            self.cameraIcon.centerXAnchor.constraint(equalTo: self.cameraButtonView.centerXAnchor),
            self.cameraIcon.centerYAnchor.constraint(equalTo: self.cameraButtonView.centerYAnchor),
            self.cameraIcon.heightAnchor.constraint(equalToConstant: 20),
            self.cameraIcon.widthAnchor.constraint(equalToConstant: 20),
            
            self.mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.topbarHeight + 30),
            self.mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.scrollView.topAnchor.constraint(equalTo: self.mainView.topAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.mainView.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.mainView.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor),
            
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.containerView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalToConstant: AppConstants.screenWidth),
            
            self.statusView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0),
            self.statusView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.statusView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            self.statusView.heightAnchor.constraint(equalToConstant: AppConstants.screenHeight * 0.11),
            
            self.statusCollectionView.topAnchor.constraint(equalTo: self.statusView.topAnchor),
            self.statusCollectionView.leftAnchor.constraint(equalTo: self.statusView.leftAnchor),
            self.statusCollectionView.rightAnchor.constraint(equalTo: self.statusView.rightAnchor),
            self.statusCollectionView.bottomAnchor.constraint(equalTo: self.statusView.bottomAnchor),
            
            self.lineView.topAnchor.constraint(equalTo: self.statusView.bottomAnchor),
            self.lineView.leftAnchor.constraint(equalTo: self.statusView.leftAnchor),
            self.lineView.rightAnchor.constraint(equalTo: self.statusView.rightAnchor),
            self.lineView.heightAnchor.constraint(equalToConstant: 1),
            
            self.chatListTableView.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 10),
            self.chatListTableView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0),
            self.chatListTableView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0),
            self.chatListTableView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            tableViewHeightConstaints,
        ])
        
        let heightConstraint = self.containerView.heightAnchor.constraint(equalToConstant: scrollViewContentHeight)
        heightConstraint.priority = UILayoutPriority(rawValue: 250)
        heightConstraint.isActive = true
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text as Any)
    }
}

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chatListUsers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusViewCollectionViewCell", for: indexPath) as? StatusViewCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            cell.profileName = "My Story"
            cell.profileImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        }else {
            cell.profileName = self.chatListUsers[indexPath.row - 1].id//"Gunther Beard"
            cell.profileImage = UIImage(named: self.chatListUsers[indexPath.row - 1].profileImage) ?? UIImage(named: "profile_Icon")
        }
        return cell
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatListUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRowTableViewCell", for: indexPath) as? ChatRowTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.profileName = self.chatListUsers[indexPath.row].name
        cell.profileDescription = self.chatListUsers[indexPath.row].description
        cell.profileImage = self.chatListUsers[indexPath.row].profileImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        dataStore.getUsersList()
        let channelId = "\(UserDefaults.userName!):\(self.chatListUsers[indexPath.row].id)"
        let messageVC = MessageViewController(channel: .init(id: channelId, name: self.chatListUsers[indexPath.row].name))
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
}
