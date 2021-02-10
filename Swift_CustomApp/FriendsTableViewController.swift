//
//  TableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 27.01.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    private let friendsArray = [
        Friend(name: "Katherine", surname: "Adams", photoName: "srvpgeneralcounsel_image"),
        Friend(name: "Eddy", surname: "Cue", photoName: "srvpinternetsoftwareandservices_image"),
        Friend(name: "Craig", surname: "Federighi", photoName: "srvpsoftwareengineering_image"),
        Friend(name: "John", surname: "Giannandrea", photoName: "svpmachinelearningaistrategy_image"),
        Friend(name: "Greg “Joz”", surname: "Joswiak", photoName: "greg-joswiak"),
        Friend(name: "Sabih", surname: "Khan", photoName: "Sabih_Khan_image"),
        Friend(name: "Luca", surname: "Maestri", photoName: "srvpcfo_image"),
        Friend(name: "Deirdre", surname: "O’Brien", photoName: "srvpretailpeople_image"),
        Friend(name: "Dan", surname: "Riccio", photoName: "srvphardwareengineering_image"),
        Friend(name: "Johny", surname: "Srouji", photoName: "srvphardwaretech_image"),
        Friend(name: "Jeff ", surname: "Williams", photoName: "cco"),
        Friend(name: "Lisa", surname: "Jackson", photoName: "environmentalpolicysocial_image"),
        Friend(name: "Isabel", surname: "Ge Mahe", photoName: "greaterchina_image"),
        Friend(name: "Tor", surname: "Myhren", photoName: "marcom_image"),
        Friend(name: "Adrian", surname: "Perica", photoName: "corporatedevelopment_image"),
        Friend(name: "Phill", surname: "Schiller", photoName: "srvpworldwidemarketing_image")
    ]
    
    private var filteredFriends = [Friend]()
    
    private struct Section {
        let letter : String
        let friends : [Friend]
    }
    
    private var sections = [Section]()
    private var headers = [String]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    private func CalculateSectionsAndHeaders() {
        let sectionsData = Dictionary(grouping: self.filteredFriends, by: { String($0.surname.prefix(1)) })
        let keys = sectionsData.keys.sorted()
        self.sections = keys.map{ Section(letter: $0, friends: sectionsData[$0]!) }
        self.headers = self.sections.map{ $0.letter }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: .none), forCellReuseIdentifier: "FriendCell")
        self.tableView.register(UINib(nibName: "FriendSectionHeader", bundle: .none), forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        
        self.searchBar.delegate = self
        
        self.filteredFriends = self.friendsArray
        
        CalculateSectionsAndHeaders()
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        
        // Configure the cell...
        let friend = self.sections[indexPath.section].friends[indexPath.row]
        cell.fullNameLabel.text = friend.getFullName()
        cell.photoView.photoImageView.image = UIImage(named: friend.photoName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendCollectionView")
        (vc as? FriendCollectionViewController)?.friend = self.sections[indexPath.section].friends[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsHeader") as! FriendSectionHeader
        
        header.nameLabel.text = self.headers[section]
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 50
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFriends = []
        
        if searchText.count == 0 {
            filteredFriends = friendsArray
        } else {
            for friend in friendsArray where friend.getFullName().lowercased().contains(searchText.lowercased()) {
                filteredFriends.append(friend)
            }
        }
        
        CalculateSectionsAndHeaders()
        
        self.tableView.reloadData()
    }
}
