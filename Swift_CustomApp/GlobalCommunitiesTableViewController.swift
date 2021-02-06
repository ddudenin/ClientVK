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

class GlobalCommunitiesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsGlobal.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunitiesTableViewCell
        
        // Configure the cell...
        
        cell.fullNameLabel.text = groupsGlobal[indexPath.row].name
        cell.photoImageView.image = UIImage(systemName: groupsGlobal[indexPath.row].avatarName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserCommunitiesTableView")
        
        groups.append(groupsGlobal[indexPath.row])
        groupsGlobal.remove(at: indexPath.row)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
