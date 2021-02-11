//
//  GlobalCommunitiesTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

var groupsGlobal: [Group] = [
    Group(name: "American democracy: lie or reality", avatarName: "flag.fill"),
    Group(name: "Одноклассники", avatarName: "bubble.middle.bottom.fill"),
]

class GlobalCommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var filteredGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
        
        self.searchBar.delegate = self
        
        self.filteredGroups = groupsGlobal
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunitiesTableViewCell
        
        // Configure the cell...
        let group = self.filteredGroups[indexPath.row]
        cell.fullNameLabel.text = group.name
        cell.photoImageView.image = UIImage(systemName: group.avatarName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        groups.append(self.filteredGroups[indexPath.row])
        groupsGlobal.removeAll(where: { $0.name == self.filteredGroups[indexPath.row].name })
        self.filteredGroups.remove(at: indexPath.row)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredGroups = []
        
        if searchText.count == 0 {
            self.filteredGroups = groupsGlobal
        } else {
            for group in groupsGlobal where group.name.lowercased().contains(searchText.lowercased()) {
                filteredGroups.append(group)
            }
        }
        
        self.tableView.reloadData()
    }
}
