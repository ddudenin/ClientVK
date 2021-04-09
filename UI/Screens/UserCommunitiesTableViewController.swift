//
//  UserCommunitiesTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import RealmSwift

class UserCommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    private var searchText = ""
    
    @IBOutlet var searchBar: UISearchBar!
    
    private var userGroups: Results<Group>? {
        get {
            let groups: Results<Group>? = realmManager?.getObjects()
            
            guard !self.searchText.isEmpty else { return groups }
            
            return groups?.filter("name CONTAINS %@", self.searchText)
        }
        
        set { }
    }
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    private var notificationToken: NotificationToken?
    
    private func loadData() {
        networkManager.loadGroups() { [weak self] items in
            DispatchQueue.main.async {
                try? self?.realmManager?.add(objects: items)
            }
        }
    }
    
    private func signToGroupsChanges() {
        notificationToken = self.userGroups?.observe { [weak self] (change) in
            switch change {
            case .initial(let groups):
                #if DEBUG
                print("Initialized \(groups.count)")
                #endif
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
   
                let deletionsIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }
                
                #if DEBUG
                print(deletions, insertions, modifications)
                #endif
                
                self?.tableView.beginUpdates()
                
                self?.tableView.deleteRows(at: deletionsIndexPaths, with: .automatic)
                self?.tableView.insertRows(at: insertionsIndexPaths, with: .automatic)
                self?.tableView.reloadRows(at: modificationsIndexPaths, with: .automatic)
                
                self?.tableView.endUpdates()
                
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
        
        self.searchBar.delegate = self
        signToGroupsChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userGroups = self.userGroups, userGroups.isEmpty {
            loadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBar.text = ""
        searchBar(self.searchBar, textDidChange: "")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userGroups?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunitiesTableViewCell
        
        // Configure the cell...
        guard let group = self.userGroups?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(withGroup: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                guard let userGroups = self.userGroups else { return }
                try realmManager?.delete(object: userGroups[indexPath.row])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CommunitiesTableViewCell {
            cell.photoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.25),
                           initialSpringVelocity: CGFloat(4.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            cell.photoImageView.transform = CGAffineTransform.identity
                           },
                           completion: nil
            )
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.tableView.reloadData()
    }
}
