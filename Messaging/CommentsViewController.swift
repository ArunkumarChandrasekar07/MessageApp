//
//  CommentsViewController.swift
//  Messaging
//
//  Created by Arunkumar Chandrasekar on 16/10/22.
//

import UIKit

typealias CommentsElements = [(key: Int, value: Array<Comments>)]

class CommentsViewController: BaseViewController {
    
    private var comments: [Comments] = []
    
    private var commentsDictionary = [Int: [Comments]]()
    
    private(set) var commentsElements: CommentsElements = []
    private(set) var searchedCommentsElements: CommentsElements = []
    
    private lazy var searchBar: UISearchBar! = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barStyle = .default
        searchBar.barTintColor = .systemBackground
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private lazy var commentsListTableView: UITableView! = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchComments()
        
        self.addSubViews()
        
        self.commentsListTableView.dataSource = self
        self.commentsListTableView.delegate = self
        self.searchBar.delegate = self
        
    }
    
    private func addSubViews() {
        self.view.addSubview(searchBar)
        
        self.view.addSubview(commentsListTableView)
        
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.topBarView.bottomAnchor),
            self.searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            self.commentsListTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 5),
            self.commentsListTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.commentsListTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.commentsListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func fetchComments() {
        let spinner = Spinner.init()
        spinner.show()
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/comments")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            DispatchQueue.main.async {
                spinner.hide()
            }
            guard let data = data else {
                print(String(describing: error))
                return
            }
            if let jsonData = try? JSONDecoder().decode([Comments].self, from: data) {
                self.comments = jsonData
                self.comments.forEach { comments in
                    if self.commentsDictionary.keys.contains(comments.postId) {
                        self.commentsDictionary[comments.postId]?.append(comments)
                    }else {
                        self.commentsDictionary[comments.postId] = [comments]
                    }
                }
                self.commentsElements           = self.commentsDictionary.sorted(by: { $0.0 < $1.0 })
                self.searchedCommentsElements   = self.commentsElements
                DispatchQueue.main.async {
                    self.commentsListTableView.reloadData()
                }
            }
        }
        task.resume()
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? self.searchedCommentsElements.count : self.commentsElements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? self.searchedCommentsElements[section].value.count : self.commentsElements[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.identifier, for: indexPath) as? CommentsTableViewCell else {
            return UITableViewCell()
        }
        cell.comment = isSearching ? self.searchedCommentsElements[indexPath.section].value[indexPath.row] : self.commentsElements[indexPath.section].value[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\( isSearching ? self.searchedCommentsElements[section].key : self.commentsElements[section].key)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension CommentsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText == "" {
            isSearching = false
            self.searchedCommentsElements = self.commentsElements
        }else {
            isSearching = true
            for (index, comments) in self.searchedCommentsElements.enumerated() {
                let value = comments.value.filter { $0.body.lowercased().contains(searchText.lowercased()) }
                self.searchedCommentsElements[index].value = value
            }
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.commentsListTableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        isSearching = false
        self.searchedCommentsElements = self.commentsElements
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.commentsListTableView.reloadData()
            }
        }

    }
}
