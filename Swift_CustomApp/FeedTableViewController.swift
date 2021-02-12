//
//  NewsTableViewController.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/10/21.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: .none), forCellReuseIdentifier: "PostCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        // Configure the cell...
        let post = postsData[indexPath.row]
        cell.createdByLabel.text = post.createdBy.getFullName()
        cell.profileImageView.image = UIImage(named: post.createdBy.photoName)
        cell.captionLabel.text = post.caption
        cell.postImageView.image = UIImage(named: post.postImagesNames[0])
        cell.likesButton.setTitle(convertCountToString(count: post.likesCount), for: .normal)
        cell.commentsButton.setTitle(convertCountToString(count: post.commentsCount), for: .normal)
        cell.sharesButton.setTitle(convertCountToString(count: post.sharesCount), for: .normal)
        cell.viewsCountLabel.text = convertCountToString(count: post.viewsCount)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
