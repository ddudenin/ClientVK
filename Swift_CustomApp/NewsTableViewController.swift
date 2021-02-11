//
//  NewsTableViewController.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/10/21.
//

import UIKit

var newsText = [
    "Data Privacy Day at Apple: Improving transparency and empowering users. Data tracking is more widespread than ever. Learn how Apple’s privacy features help users take control over their data",
    "Apple Reports First Quarter Results. Revenue up 21 percent and EPS up 35 percent to new all-time records. iPhone, Wearables, and Services set new revenue records",
    "Dan Riccio begins a new chapter at Apple. John Ternus will join the executive team as senior vice president of Hardware Engineering",
    "Time to Walk: An inspiring audio walking experience comes to Apple Fitness+. Episodes feature personal stories, photos, and music from influential people to inspire Apple Watch users to walk more",
    "Apple launches major new Racial Equity and Justice Initiative projects to challenge systemic racism, advance racial equity nationwide. Commitments build on Apple’s $100 million pledge and include a first-of-its-kind education hub for HBCUs and an Apple Developer Academy in Detroit",
    "Monica Lozano joins Apple’s board of directors"
]

var newsData = [
    News(authorName: "Jeff Williams", authorImageName: "cco", newsText: newsText[0], newsImagesNames: ["cco"]),
    News(authorName: "Tor Myhren", authorImageName: "marcom_image", newsText: newsText[1], newsImagesNames: ["marcom_image"]),
    News(authorName: "Sabin Khan", authorImageName: "Sabih_Khan_image", newsText: newsText[2], newsImagesNames: ["Sabih_Khan_image"]),
    News(authorName: "Dan Riccio", authorImageName: "srvphardwareengineering_image", newsText: newsText[3], newsImagesNames: ["srvphardwareengineering_image"]),
    News(authorName: "Deirdre O'Brien", authorImageName: "srvpretailpeople_image", newsText: newsText[4], newsImagesNames: ["srvpretailpeople_image"]),
    News(authorName: "Tim Cook", authorImageName: "ceo_image", newsText: newsText[5], newsImagesNames: ["ceo_image"])
]

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
        return newsData.count
    }
    
    private func countToString(viewsCount count: UInt) -> String {
        let str = ["K", "M", "B"]
        
        var value = Float(count)
        var index = -1
        
        while value >= 1000 {
            value /= 1000
            index += 1
        }
        
        guard index != -1 else { return "\(count)" }
        
        return  String(format: "%.1f", value) + str[index]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        let news = newsData[indexPath.row]
        cell.authorNameLabel.text = news.authorName
        cell.authorImageView.image = UIImage(named: news.authorImageName)
        cell.newsTextLabel.text = news.newsText
        cell.newsPhotoImageView.image = UIImage(named: news.newsImagesNames[0])
        cell.commentsCountLabel.text = countToString(viewsCount: news.commentsCount)
        cell.repostsCountLabel.text = countToString(viewsCount: news.repostCount)
        cell.viewsCountLabel.text = countToString(viewsCount: news.viewsCount)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
