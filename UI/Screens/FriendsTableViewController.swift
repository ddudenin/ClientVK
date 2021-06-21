//
//  TableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 27.01.2021.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!
    
    private var searchText: String = ""
    
    private var friends: Results<RLMUser>? {
        get {
            let friends: Results<RLMUser>? = realmManager?.getObjects()
            
            guard !self.searchText.isEmpty else { return friends }
            
            return friends?.filter("firstName CONTAINS %@ OR lastName CONTAINS %@", self.searchText, self.searchText)
        }
        
        set { }
    }
    
    private struct Section {
        let name: String
        let items: [RLMUser]
    }
    
    private var sections = [Section]()
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    
    private func calculateSectionsData() {
        guard let friends = self.friends else { return }
        let sectionsData = Dictionary(grouping: friends, by: { String($0.lastName.prefix(1)) })
        let keys = sectionsData.keys.sorted()
        self.sections = keys.map{ Section(name: $0, items: sectionsData[$0] ?? []) }
    }
    
    private func loadData() {
        self.networkManager.friendsForecast()
            .map { friends in
                do {
                    try self.realmManager?.add(objects: friends)
                } catch {
                    print(error.localizedDescription)
                }
            }
            .catch { error in
                print(error.localizedDescription)
            }
            .finally {
                self.tableView.reloadData()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: .none), forCellReuseIdentifier: "FriendCell")
        self.tableView.register(UINib(nibName: "FriendSectionHeader", bundle: .none), forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let friends = self.friends, friends.isEmpty {
            loadData()
        }
        
        calculateSectionsData()
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
        return self.sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsTableViewCell
        
        // Configure the cell...
        cell.configure(withUser: self.sections[indexPath.section].items[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = AlbumsViewController()
        vc.friend = self.sections[indexPath.section].items[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        vc.view.backgroundColor = .systemBackground
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsHeader") as! FriendSectionHeader
        
        header.configure(withName: self.sections[section].name)
        
        return header
    }
    
}

extension FriendsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        calculateSectionsData()
        self.tableView.reloadData()
    }
}
