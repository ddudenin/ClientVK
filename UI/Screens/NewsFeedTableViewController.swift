//
//  NewsFeedTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit

final class NewsFeedTableViewController: UITableViewController {
    
    enum PostBlock {
        case author
        case text
        case photos
        case footer
    }
    
    private var postsData = [Article]()
    private let networkManager = NetworkManager.instance
    
    private var sectionBlocks = [[PostBlock]]()
    
    private lazy var refresherController: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Update", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    var toTopButton = UIButton()
    private var isScrollOnTop = true
    private var startYPos: CGFloat = 0
    
    private func loadData(completion: (() -> Void)? = nil) {
        self.networkManager.loadNews() { [weak self] (items) in
            DispatchQueue.main.async {
                self?.postsData = items
                self?.calculateSectionsBlocks()
                self?.tableView.reloadData()
                completion?()
            }
        }
    }
    
    private func setupFloatingButton() {
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        let buttonSize = CGSize(width: 30, height: 30)
        self.startYPos = navigationBarHeight + buttonSize.height
        
        self.toTopButton.frame = CGRect(x: self.tableView.frame.width / 2 - buttonSize.width / 2, y: startYPos, width: buttonSize.width, height: buttonSize.height)
        self.toTopButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .normal)
        self.toTopButton.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.5294117647, blue: 0.9607843137, alpha: 1)
        self.toTopButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.toTopButton.clipsToBounds = true
        self.toTopButton.layer.cornerRadius = buttonSize.width / 2
        self.toTopButton.addTarget(self, action: #selector(scrollToTopHandle(_:)), for: .touchUpInside)
        self.toTopButton.alpha = 0
        
        self.view.addSubview(self.toTopButton)
    }
    
    private func calculateSectionsBlocks() {
        var blocks: [PostBlock]
        
        for post in postsData {
            blocks = [.author]
            
            //if let text = post.articleDescription, !text.isEmpty {
                blocks.append(.text)
            //}
            
            if let _ = post.urlToImage {
                blocks.append(.photos)
            }
            
            blocks.append(.footer)
            
            self.sectionBlocks.append(blocks)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsFeedAuthorTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedAuthorCell")
        self.tableView.register(UINib(nibName: "NewsFeedTextTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedTextCell")
        self.tableView.register(UINib(nibName: "NewsFeedImagesTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedImagesCell")
        self.tableView.register(UINib(nibName: "NewsFeedFooterTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedFooterCell")
        
        self.tableView.refreshControl = self.refresherController
        
        loadData()
        
        setupFloatingButton()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.postsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionBlocks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.sectionBlocks[indexPath.section][indexPath.row] {
        case .author:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedAuthorCell", for: indexPath) as! NewsFeedAuthorTableViewCell
            
            // Configure the cell...
            cell.configure(withPost: postsData[indexPath.section])
            
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTextCell", for: indexPath) as! NewsFeedTextTableViewCell
            
            // Configure the cell...
            cell.configure(withPost: postsData[indexPath.section])
            
            return cell
        case .photos:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedImagesCell", for: indexPath) as! NewsFeedImagesTableViewCell
            
            // Configure the cell...
            cell.configure(withPost: postsData[indexPath.section])
            
            return cell
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedFooterCell", for: indexPath) as! NewsFeedFooterTableViewCell
            
            // Configure the cell...
            cell.configure(withPost: postsData[indexPath.section])
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.toTopButton.frame.origin.y = self.startYPos + scrollView.contentOffset.y
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > 200 {
            if self.isScrollOnTop {
                UIView.animate(withDuration: 0.3) {
                    self.toTopButton.alpha = 1
                }
                self.isScrollOnTop = false
            }
        } else if !self.isScrollOnTop {
            UIView.animate(withDuration: 0.3) {
                self.toTopButton.alpha = 0
            }
            self.isScrollOnTop = true
        }
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        loadData() { [weak self] in
            self?.refresherController.endRefreshing()
        }
    }
    
    @objc func scrollToTopHandle(_ sender: UIButton) {
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}
