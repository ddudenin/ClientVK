//
//  TableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 27.01.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var friends = [User]()
    private var filtered = [User]()
    
    private struct Section {
        let name: String
        let items: [User]
    }
    
    private var sections = [Section]()
    
    private let networkManager = NetworkManager.instance
    
    private var friendsRef = Database.database().reference(withPath: "\(Session.instance.userId)/Friends")
    
    private var friendsCollection = Firestore.firestore().collection("Friends")
    private var listener: ListenerRegistration?
    
    private func CalculateSectionsAndHeaders() {
        let sectionsData = Dictionary(grouping: self.filtered, by: { String($0.lastName.prefix(1)) })
        let keys = sectionsData.keys.sorted()
        self.sections = keys.map { Section(name: $0, items: sectionsData[$0] ?? []) }
    }
    
    private func loadData() {
        self.networkManager.loadFriends() { [weak self] items in
            DispatchQueue.main.async {
                let firebaseUsers = items.map { User(from: $0) }
                
                switch Config.databaseType {
                case .database:
                    for user in firebaseUsers {
                        self?.friendsRef.child("\(user.id)").setValue(user.toAnyObject())
                    }
                case .firestore:
                    for user in firebaseUsers {
                        self?.friendsCollection.document("\(user.id)").setData(user.toAnyObject())
                    }
                }
                
                self?.CalculateSectionsAndHeaders()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func loadDataFromDatabase() {
        self.friendsRef.observe(.value) { [weak self] (snapshot) in
            DispatchQueue.main.async {
                self?.friends.removeAll()
                
                guard !snapshot.children.allObjects.isEmpty else {
                    self?.loadData()
                    return
                }
                
                for child in snapshot.children {
                    guard let child = child as? DataSnapshot,
                          let user = User(snapshot: child) else {
                        continue
                    }
                    
                    self?.friends.append(user)
                }
                
                self?.filtered = self?.friends ?? []
                friendsArray = self?.friends ?? []
                self?.CalculateSectionsAndHeaders()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func loadDataFromFirestore() {
        self.listener = self.friendsCollection.addSnapshotListener { [weak self] (snapshot, error) in
            DispatchQueue.main.async {
                self?.friends.removeAll()
                
                guard let snapshot = snapshot,
                      !snapshot.documents.isEmpty
                else {
                    self?.loadData()
                    return
                }
                
                for doc in snapshot.documents {
                    guard let user = User(dict: doc.data()) else { continue }
                    self?.friends.append(user)
                }
                
                self?.filtered = self?.friends ?? []
                friendsArray = self?.friends ?? []
                self?.CalculateSectionsAndHeaders()
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: .none), forCellReuseIdentifier: "FriendCell")
        self.tableView.register(UINib(nibName: "FriendSectionHeader", bundle: .none), forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        
        self.searchBar.delegate = self
        
        switch Config.databaseType {
        case .database:
            loadDataFromDatabase()
        case .firestore:
            loadDataFromFirestore()
        }
    }
    
    deinit {
        switch Config.databaseType {
        case .database:
            self.friendsRef.removeAllObservers()
        case .firestore:
            self.listener?.remove()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        cell.alpha = 0.0
        
        UIView.animate(withDuration: 0.75) {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1.0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        
        // Configure the cell...
        cell.configure(withUser: self.sections[indexPath.section].items[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendCollectionView")
        (vc as? FriendPhotosCollectionViewController)?.friend = self.sections[indexPath.section].items[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsHeader") as! FriendSectionHeader
        
        header.configure(withName: self.sections[section].name)
        
        return header
    }
    
}

extension FriendsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filtered = self.friends
        } else {
            self.filtered = self.friends.filter { $0.getFullName().lowercased().contains(searchText.lowercased())}
        }
        
        CalculateSectionsAndHeaders()
        self.tableView.reloadData()
    }
}
