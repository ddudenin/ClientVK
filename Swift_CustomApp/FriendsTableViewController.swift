//
//  TableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 27.01.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    private var filteredFriends = [FriendItem]()
    
    private struct Section {
        let letter : String
        let friends : [FriendItem]
    }
    
    private var sections = [Section]()
    private var headers = [String]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    private func CalculateSectionsAndHeaders() {
        let sectionsData = Dictionary(grouping: self.filteredFriends, by: { String($0.lastName.prefix(1)) })
        let keys = sectionsData.keys.sorted()
        self.sections = keys.map{ Section(letter: $0, friends: sectionsData[$0]!) }
        self.headers = self.sections.map{ $0.letter }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: .none), forCellReuseIdentifier: "FriendCell")
        self.tableView.register(UINib(nibName: "FriendSectionHeader", bundle: .none), forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        
        self.searchBar.delegate = self
        
        NetworkManager.instance.loadFriends() { [weak self] items in
            self?.filteredFriends = items
            friendsArray = items
            
            DispatchQueue.main.async {
                self?.CalculateSectionsAndHeaders()
                self?.tableView.reloadData()
            }
        }

        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        cell.alpha = 0.0
        
        UIView.animate(withDuration: 0.75) {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1.0
        }
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
        cell.configure(withFriend: self.sections[indexPath.section].friends[indexPath.row])

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
        return 40
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredFriends = []
        
        if searchText.count == 0 {
            self.filteredFriends = friendsArray
        } else {
            for friend in friendsArray where friend.getFullName().lowercased().contains(searchText.lowercased()) {
                self.filteredFriends.append(friend)
            }
        }
        
        CalculateSectionsAndHeaders()
        
        self.tableView.reloadData()
    }
}
