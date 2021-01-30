//
//  TableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 27.01.2021.
//

import UIKit

public class Friend {
    let name: String
    let avatar: UIImage?
    
    init(name: String, avatar: UIImage?) {
        self.name = name
        self.avatar = avatar
    }
}

class FriendsTableViewController: UITableViewController {
    
    var friends: [[Friend]] = [[
        Friend(name: "Katherine Adams", avatar: UIImage(named: "srvpgeneralcounsel_image")),
        Friend(name: "Eddy Cue", avatar: UIImage(named: "srvpinternetsoftwareandservices_image")),
        Friend(name: "Craig Federighi", avatar: UIImage(named: "srvpsoftwareengineering_image")),
        Friend(name: "John Giannandrea", avatar: UIImage(named: "svpmachinelearningaistrategy_image")),
        Friend(name: "Greg “Joz” Joswiak", avatar: UIImage(named: "greg-joswiak")),
        Friend(name: "Sabih Khan", avatar: UIImage(named: "Sabih_Khan_image")),
        Friend(name: "Luca Maestri", avatar: UIImage(named: "srvpcfo_image")),
        Friend(name: "Deirdre O’Brien", avatar: UIImage(named: "srvpretailpeople_image")),
        Friend(name: "Dan Riccio", avatar: UIImage(named: "srvphardwareengineering_image")),
        Friend(name: "Johny Srouji", avatar: UIImage(named: "srvphardwaretech_image")),
        Friend(name: "Jeff Williams", avatar: UIImage(named: "cco"))
    ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: .none), forCellReuseIdentifier: "FriendCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        
        // Configure the cell...
        
        cell.friendNameLabel.text = friends[indexPath.section][indexPath.row].name
        cell.avatarImage.image = friends[indexPath.section][indexPath.row].avatar
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendCollectionView")
        (vc as? AvatarCollectionViewController)?.name = friends[indexPath.section][indexPath.row].name
        (vc as? AvatarCollectionViewController)?.avatar = friends[indexPath.section][indexPath.row].avatar!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            // Удаляем город из массива
            friends.remove(at: indexPath.row)
            // И удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addFriend(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add friend", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Enter user name" }
        let action = UIAlertAction(title: "Sumbit",
                                   style: .cancel) { [weak alert] _ in
            guard let textFields = alert?.textFields else { return }
            
            if let userName = textFields[0].text {
                let friend = Friend(name: userName, avatar: UIImage(systemName: "person.fill"))
                if !self.friends[0].contains(where: {$0.name == friend.name}){
                    self.friends[0].append(friend)
                    self.tableView.reloadData()
                }
            }
        }
        alert.addAction(action)
        // Показываем UIAlertController
        present(alert, animated: true, completion: nil)
    }
}
