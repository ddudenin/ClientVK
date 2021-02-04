//
//  TableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 27.01.2021.
//

import UIKit

struct Section {
    let letter : String
    let friends : [Friend]
}

class FriendsTableViewController: UITableViewController {
    
    let friendsArray = [
        Friend(fullName: "Katherine Adams", photo: UIImage(named: "srvpgeneralcounsel_image")),
        Friend(fullName: "Eddy Cue", photo: UIImage(named: "srvpinternetsoftwareandservices_image")),
        Friend(fullName: "Craig Federighi", photo: UIImage(named: "srvpsoftwareengineering_image")),
        Friend(fullName: "John Giannandrea", photo: UIImage(named: "svpmachinelearningaistrategy_image")),
        Friend(fullName: "Greg “Joz” Joswiak", photo: UIImage(named: "greg-joswiak")),
        Friend(fullName: "Sabih Khan", photo: UIImage(named: "Sabih_Khan_image")),
        Friend(fullName: "Luca Maestri", photo: UIImage(named: "srvpcfo_image")),
        Friend(fullName: "Deirdre O’Brien", photo: UIImage(named: "srvpretailpeople_image")),
        Friend(fullName: "Dan Riccio", photo: UIImage(named: "srvphardwareengineering_image")),
        Friend(fullName: "Johny Srouji", photo: UIImage(named: "srvphardwaretech_image")),
        Friend(fullName: "Jeff Williams", photo: UIImage(named: "cco")),
        Friend(fullName: "Lisa Jackson", photo: UIImage(named: "environmentalpolicysocial_image")),
        Friend(fullName: "Isabel Ge Mahe", photo: UIImage(named: "greaterchina_image")),
        Friend(fullName: "Tor Myhren", photo: UIImage(named: "marcom_image")),
        Friend(fullName: "Adrian Perica", photo: UIImage(named: "corporatedevelopment_image")),
        Friend(fullName: "Phill Schiller", photo: UIImage(named: "srvpworldwidemarketing_image"))
    ]
    
    var sections = [Section]()
    var headers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: .none), forCellReuseIdentifier: "FriendCell")
        
        let sectionsData = Dictionary(grouping: friendsArray, by: { String($0.fullName.prefix(1)) })
        let keys = sectionsData.keys.sorted()
        sections = keys.map{ Section(letter: $0, friends: sectionsData[$0]!) }
        headers = sections.map{ $0.letter }
        self.tableView.reloadData()
    }
    
    let avatarView: UIView = {
        let view = AvatarView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.view.addSubview(self.avatarView)
        //self.avatarView.setNeedsDisplay()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        
        // Configure the cell...
        let friend = sections[indexPath.section].friends[indexPath.row]
        cell.fullNameLabel.text = friend.fullName
        cell.photoImageView.image = friend.photo
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendCollectionView")
        (vc as? FriendCollectionViewController)?.friend = sections[indexPath.section].friends[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    //    @IBAction func addFriend(_ sender: UIBarButtonItem) {
    //        let alert = UIAlertController(title: "Add friend", message: "", preferredStyle: .alert)
    //        alert.addTextField { (textField) in textField.placeholder = "Enter user name" }
    //        let action = UIAlertAction(title: "Sumbit",
    //                                   style: .cancel) { [weak alert] _ in
    //            guard let textFields = alert?.textFields else { return }
    //
    //            if let userName = textFields[0].text {
    //                let friend = Friend(name: userName, avatar: UIImage(systemName: "person.fill"))
    //                if !self.friends[0].contains(where: {$0.name == friend.name}){
    //                    self.friends[0].append(friend)
    //                    self.tableView.reloadData()
    //                }
    //            }
    //        }
    //        alert.addAction(action)
    //        // Показываем UIAlertController
    //        present(alert, animated: true, completion: nil)
    //    }
}
