//
//  TableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 27.01.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet private var searchBar: UISearchBar!

    private var friends = [UserDTO]()
    
    private struct Section {
        let name: String
        let items: [UserDisplayItem]
    }
    
    private var sections = [Section]()
    
    private let serviceAdapter = ServiceAdapter()
    
    private func calculateSectionsData() {
        let sectionsData = Dictionary(grouping: self.friends, by: { String($0.lastName.prefix(1)) }).compactMapValues { $0.map { UserDisplayItemFactory.make(for: $0) } }
        let keys = sectionsData.keys.sorted()
        self.sections = keys.map { Section(name: $0, items: sectionsData[$0] ?? []) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: .none), forCellReuseIdentifier: "FriendCell")
        self.tableView.register(UINib(nibName: "FriendSectionHeader", bundle: .none), forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        serviceAdapter.loadFriends(complition: { [weak self] items in
            self?.friends = items
            self?.calculateSectionsData()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
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
        
        let fullName = self.sections[indexPath.section].items[indexPath.row].fullName
        guard let friend = self.friends.first(where: { $0.fullName == fullName }) else {
            return
        }
        
        vc.friend = friend
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
        serviceAdapter.loadFriends(complition: { [weak self] items in
            if (!searchText.isEmpty) {
                self?.friends = items.filter {
                    $0.fullName
                        .lowercased()
                        .contains(searchText.lowercased())
                }
            } else {
                self?.friends = items
            }
            
            self?.calculateSectionsData()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
}
