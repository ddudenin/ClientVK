//
//  GroupsTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 30.01.2021.
//

import UIKit
import RealmSwift

final class GroupsTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var searchText = ""
    
    private var groupDisplayItems = [GroupDisplayItem]()
    
    private var userGroups = [GroupDTO]()
    private var serviceAdapter = ServiceAdapter()
    private var proxy: ProxyNetworkService? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: .none), forCellReuseIdentifier: "GroupCell")
        
        self.proxy = ProxyNetworkService(base: self.serviceAdapter)
        
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.proxy?.loadGroups(complition: { [weak self] items in
            self?.userGroups = items
            self?.groupDisplayItems = items.map {
                GroupDisplayItemFactory.make(for: $0)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar(self.searchBar, textDidChange: "")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        // Configure the cell...
        let group = self.groupDisplayItems[indexPath.row]
        cell.configure(withGroup: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groups: Results<RLMGroup>? = RealmManager.instance?.getObjects()
            
            let groudID = userGroups[indexPath.row].id
            let group = groups?.first(where: { $0.id ==  groudID })
            
            guard let object = group else { return }

            do {
                try RealmManager.instance?.delete(object: object)
            } catch {
                print(error.localizedDescription)
            }
            
            self.proxy?.loadGroups(complition: { [weak self] items in
                self?.userGroups = items
                self?.groupDisplayItems = items.map {
                    GroupDisplayItemFactory.make(for: $0)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GroupsTableViewCell {
            cell.animate()
        }
    }
}

extension GroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.proxy?.loadGroups(complition: { [weak self] items in
            if (!searchText.isEmpty) {
                self?.userGroups = items.filter {
                    $0.name
                        .lowercased()
                        .contains(searchText.lowercased())
                }
            } else {
                self?.userGroups = items
            }
            
            self?.groupDisplayItems = self?.userGroups.map {
                GroupDisplayItemFactory.make(for: $0)
            } ?? []

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
}
