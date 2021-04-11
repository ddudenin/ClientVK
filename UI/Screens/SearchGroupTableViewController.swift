//
//  SearchGroupTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

final class SearchGroupTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var searchGroups = [Group]()
    
    private let networkManager = NetworkManager.instance
    private var groupsRef = Database.database().reference(withPath: "\(Session.instance.userId)/Groups")
    private var groupsCollection = Firestore.firestore().collection("Groups")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: .none), forCellReuseIdentifier: "GroupCell")
        
        self.searchBar.delegate = self
    }
    
    deinit {
        if Config.databaseType == .database {
            self.groupsRef.removeAllObservers()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        // Configure the cell...
        cell.configure(withGroup: self.searchGroups[indexPath.row])
        
        return cell
    }
    
    private func saveGroupToDatabse(group: Group) {
        self.groupsRef.child("\(group.id)").setValue(group.toAnyObject()) {
            [weak self] (error, _) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func saveGroupToFirestorm(group: Group) {
        self.groupsCollection.document("\(group.id)").setData(group.toAnyObject()) {
            [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Config.databaseType {
        case .database:
            saveGroupToDatabse(group: self.searchGroups[indexPath.row])
        case .firestore:
            saveGroupToFirestorm(group: self.searchGroups[indexPath.row])
        }
    }
}

extension SearchGroupTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            return
        }
        
        self.networkManager.loadGroups(searchText: searchText) { [weak self] items in
            self?.searchGroups = items
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}
