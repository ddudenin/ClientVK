//
//  NewsTableViewController.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/10/21.
//

import UIKit

class NewsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell

        // Configure the cell...
        cell.authorNameLabel.text = "Apple Inc"
        cell.newsTextLabel.text = "Apple Reports Record First Quarter Results. iPhone, Wearables and Services Drive All-Time Record Revenue and Earnings"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
