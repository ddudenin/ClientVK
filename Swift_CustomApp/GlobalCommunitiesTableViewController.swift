//
//  GlobalCommunitiesTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

class GlobalCommunitiesTableViewController: UITableViewController {
    
    var groups: [Group] = [
        Group(name: "Быстрые займы за 5 минут", avatar: UIImage(systemName: "bitcoinsign.circle.fill")),
        Group(name: "Дворец Путина", avatar: UIImage(systemName: "crown.fill")),
        Group(name: "Психология успешных людей", avatar: UIImage(systemName: "star.fill")),
        Group(name: "American democracy: lie or reality", avatar: UIImage(systemName: "flag.fill")),
        Group(name: "Одноклассники", avatar: UIImage(systemName: "bubble.middle.bottom.fill")),
        Group(name: "Барахолка", avatar: UIImage(systemName: "giftcard.fill")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell", for: indexPath) as! CommunitiesTableViewCell
        
        // Configure the cell...
        
        cell.fullNameLabel.text = groups[indexPath.row].name
        cell.photoImageView.image = groups[indexPath.row].avatar
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserCommunitiesTableView")
        (vc as? UserCommunitiesTableViewController)?.addGroup(group: groups[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
