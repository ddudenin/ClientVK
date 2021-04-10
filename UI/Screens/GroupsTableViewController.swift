//
//  GroupsTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import FirebaseDatabase

final class GroupsTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var groupsRef = Database.database().reference(withPath: "Groups")
    private var userGroups = [Group]()
    private var filtered = [Group]()
    
    private let networkManager = NetworkManager.instance
    
    private func loadData() {
        self.networkManager.loadGroups() { [weak self] items in
            let firebaseGroups = items.map { Group(from: $0) }
            
            for group in firebaseGroups {
                self?.groupsRef.child("\(group.id)").setValue(group.toAnyObject())
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func loadDataFromFirebase() {
        self.groupsRef.observe(.value) { [weak self] (snapshot) in
            self?.userGroups.removeAll()
            
            guard !snapshot.children.allObjects.isEmpty else {
                self?.loadData()
                return
            }
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot,
                      let group = Group(snapshot: child) else {
                    continue
                }
                
                self?.userGroups.append(group)
            }
            
            DispatchQueue.main.async {
                self?.filtered = self?.userGroups ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: .none), forCellReuseIdentifier: "GroupCell")
        
        self.searchBar.delegate = self
        loadDataFromFirebase()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        // Configure the cell...
        cell.configure(withGroup: self.filtered[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.filtered[indexPath.row].ref?.removeValue() { [weak self] (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GroupsTableViewCell {
            cell.animate()
        }
    }
}

extension GroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filtered = self.userGroups
        } else {
            self.filtered = self.userGroups.filter { $0.name.lowercased().contains(searchText.lowercased())}
        }
        
        self.tableView.reloadData()
    }
}
