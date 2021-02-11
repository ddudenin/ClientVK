//
//  UserCommunitiesTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

var groups: [Group] = [
    Group(name: "Быстрые займы за 5 минут", avatarName: "bitcoinsign.circle.fill"),
    Group(name: "Дворец Путина", avatarName: "crown.fill"),
    Group(name: "Психология успешных людей", avatarName: "star.fill"),
    Group(name: "Барахолка", avatarName: "giftcard.fill")
]

class UserCommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var filteredGroups = [Group]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
        
        self.searchBar.delegate = self
        
        self.filteredGroups = groups
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchBar(self.searchBar, textDidChange: self.searchBar.text ?? "")
        
        self.tableView.reloadData()
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
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupsGlobal.append(self.filteredGroups[indexPath.row])
            groups.removeAll(where: {$0.name == self.filteredGroups[indexPath.row].name})
            self.filteredGroups.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredGroups = []
        
        if searchText.count == 0 {
            self.filteredGroups = groups
        } else {
            for group in groups where group.name.lowercased().contains(searchText.lowercased()) {
                filteredGroups.append(group)
            }
        }
        
        self.tableView.reloadData()
    }
}
