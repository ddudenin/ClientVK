//
//  UserCommunitiesTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import RealmSwift

class UserCommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    
    private var searchText: String = ""
    
    private var filteredGroups: [GroupItem] {
        get {
            let groups: Results<GroupItem>? = realmManager?.getObjects()
            
            guard !searchText.isEmpty else { return groups?.toArray() ?? [] }
            
            return groups?.filter("name CONTAINS %@", searchText).toArray() ?? []
        }
        
        set { }
    }
    
    @IBOutlet var searchBar: UISearchBar!
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    
    private func loadData() {
        networkManager.loadGroups() { [weak self] items in
            DispatchQueue.main.async {
                try? self?.realmManager?.add(objects: items)
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CommunitiesTableViewCell", bundle: .none), forCellReuseIdentifier: "CommunityCell")
        
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchBar(self.searchBar, textDidChange: self.searchBar.text ?? "")
        
        if self.filteredGroups.isEmpty {
            loadData()
        }
        
        groups = self.filteredGroups
        
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
        cell.configure(withGroup: self.filteredGroups[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realmManager?.delete(object: self.filteredGroups[indexPath.row])
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CommunitiesTableViewCell {
            cell.photoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 2.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.25),
                           initialSpringVelocity: CGFloat(4.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            cell.photoImageView.transform = CGAffineTransform.identity
                           },
                           completion: nil
            )
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.tableView.reloadData()
    }
}
