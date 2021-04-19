//
//  NewsFeedTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit

final class NewsFeedTableViewController: UITableViewController {
    
    private var postsData = [Article]()
    private let networkManager = NetworkManager.instance
    
    private lazy var refresherController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Update", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private func loadData(completion: (() -> Void)? = nil) {
        self.networkManager.loadNews() { [weak self] (items) in
            DispatchQueue.main.async {
                self?.postsData = items
                self?.tableView.reloadData()
                completion?()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedCell")
        
        self.tableView.refreshControl = self.refresherController
        
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedTableViewCell
        
        // Configure the cell...
        cell.configure(withPost: postsData[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        loadData() { [weak self] in
            self?.refresherController.endRefreshing()
        }
    }
}
