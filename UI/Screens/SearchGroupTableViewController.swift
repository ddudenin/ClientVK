//
//  SearchGroupTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import FirebaseDatabase

final class SearchGroupTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var searchGroups = [Group]()
    
    private let networkManager = NetworkManager.instance
    private var groupsRef = Database.database().reference(withPath: "Groups")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: .none), forCellReuseIdentifier: "GroupCell")
        
        self.searchBar.delegate = self
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        saveGroupToDatabse(group: self.searchGroups[indexPath.row])
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
