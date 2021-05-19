//
//  GroupsTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import RealmSwift

final class GroupsTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var searchText = ""
    
    private var userGroups: Results<Group>? {
        get {
            let groups: Results<Group>? = self.realmManager?.getObjects()
            
            guard !self.searchText.isEmpty else { return groups }
            
            return groups?.filter("name CONTAINS %@", self.searchText)
        }
        
        set { }
    }
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    private var notificationToken: NotificationToken?
    
    private func loadData() {
        let queue = OperationQueue()
        
        let fetchOP = FetchDataOperation()
        queue.addOperation(fetchOP)
        
        let parseOP = ParseDataOperation()
        parseOP.addDependency(fetchOP)
        queue.addOperation(parseOP)
        
        let saveOP = SaveToRealmOperation()
        saveOP.addDependency(parseOP)
        OperationQueue.main.addOperation(saveOP)
        
        let reloadOP = DisplayDataOpeartion(tableView: self.tableView)
        reloadOP.addDependency(saveOP)
        OperationQueue.main.addOperation(reloadOP)
    }
    
    private func signToGroupsChanges() {
        self.notificationToken = self.userGroups?.observe { [weak self] (change) in
            switch change {
            case .initial(let groups):
                #if DEBUG
                print("Initialized \(groups.count)")
                #endif
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self?.tableView.beginUpdates()
                
                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self?.tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "GroupsTableViewCell", bundle: .none), forCellReuseIdentifier: "GroupCell")
        
        self.searchBar.delegate = self
        
        signToGroupsChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let userGroups = self.userGroups, userGroups.isEmpty {
            loadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar(self.searchBar, textDidChange: "")
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = self.userGroups?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        // Configure the cell...
        cell.configure(withGroup: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let userGroups = self.userGroups else { return }
            
            do {
                try realmManager?.delete(object: userGroups[indexPath.row])
            } catch {
                print(error.localizedDescription)
            }
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
        self.searchText = searchText
        self.tableView.reloadData()
    }
}
