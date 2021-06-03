//
//  NewsFeedTableViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 10.02.2021.
//

import UIKit

final class NewsFeedTableViewController: UITableViewController {
    
    enum PostBlock {
        case author
        case text
        case photos
        case footer
    }
    
    private var postsData = [PostData]() {
        didSet {
            return timeAgoTextCache = [:]
        }
    }
    
    private let networkManager = NetworkManager.instance
    
    private var sectionBlocks = [[PostBlock]]()
    
    lazy var relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter
    }()
    
    private var timeAgoTextCache: [Int : String] = [:]
    
    private var isLoading = false
    private var nextFrom = ""
    
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
    
    private func preparePostData(response: PostResponse, complition: @escaping ((posts: [PostData], sections: [[PostBlock]])) -> ()) {
        var blocksData = [[PostBlock]]()
        var posts = [PostData]()
        
        self.nextFrom = response.nextFrom ?? ""
        
        for post in response.items {
            var content = [PostBlock]()
            
            let index = post.sourceId
            
            var photos = [Size]()
            
            if let attachments = post.attachments, !attachments.isEmpty {
                for item in attachments {
                    if let photo = item.photo?.sizes.first(where: { $0.type == "x" }) {
                        photos.append(photo)
                    }
                }
            }
            
            if index > 0 {
                if let profile = response.profiles.first(where: {$0.id == index}) {
                    posts.append(PostData(source: profile, item: post, photos: photos))
                }
            } else {
                if let group = response.groups.first(where: {$0.id == -index}) {
                    posts.append(PostData(source: group, item: post, photos: photos))
                }
            }
            
            content = [.author]
            
            if(!post.text.isEmpty) {
                content.append(.text)
            }
            
            if !photos.isEmpty {
                content.append(.photos)
            }
            
            content.append(.footer)
            
            blocksData.append(content)
        }
        
        complition((posts, blocksData))
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        self.networkManager.loadPosts() { [weak self] (response) in
            DispatchQueue.main.async {
                self?.preparePostData(response: response) { data in
                    self?.postsData = data.posts
                    self?.sectionBlocks = data.sections
                    self?.tableView.reloadData()
                    completion?()
                }
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
        
        DispatchQueue.main.async {
            self.view.addSubview(self.toTopButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "NewsFeedAuthorTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedAuthorCell")
        self.tableView.register(UINib(nibName: "NewsFeedTextTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedTextCell")
        self.tableView.register(UINib(nibName: "NewsFeedSingleImageTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedSingleImagesCell")
        self.tableView.register(UINib(nibName: "NewsFeedImagesTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedImagesCell")
        self.tableView.register(UINib(nibName: "NewsFeedFooterTableViewCell", bundle: .none), forCellReuseIdentifier: "NewsFeedFooterCell")
        
        self.tableView.refreshControl = self.refresherController
        self.tableView.prefetchDataSource = self
        
        loadData()
        
        self.setupFloatingButton()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.postsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionBlocks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = postsData[indexPath.section]
        
        switch self.sectionBlocks[indexPath.section][indexPath.row] {
        case .author:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedAuthorCell", for: indexPath) as! NewsFeedAuthorTableViewCell
            
            var timeAgoText: String
            
            if let formattedDate = self.timeAgoTextCache[post.item.date] {
                timeAgoText = formattedDate
            } else {
                timeAgoText = self.relativeDateTimeFormatter.localizedString(for: Date(timeIntervalSince1970: TimeInterval(post.item.date)), relativeTo: Date())
                self.timeAgoTextCache[post.item.date] = timeAgoText
            }
            
            // Configure the cell...
            cell.configure(withPost: post, timeAgo: timeAgoText)
            
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTextCell", for: indexPath) as! NewsFeedTextTableViewCell
            
            // Configure the cell...
            cell.configure(withPost: post)
            
            return cell
        case .photos:
            var cell = UITableViewCell()
            
            if post.photos.count == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedSingleImagesCell", for: indexPath)
                
                // Configure the cell...
                (cell as! NewsFeedSingleImageTableViewCell).configure(withPost: post)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedImagesCell", for: indexPath)
                
                // Configure the cell...
                (cell as! NewsFeedImagesTableViewCell).configure(withPost: post)
            }
            
            return cell
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedFooterCell", for: indexPath) as! NewsFeedFooterTableViewCell
            
            // Configure the cell...
            cell.configure(withPost: post)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.sectionBlocks[indexPath.section][indexPath.row] {
        case .photos:
            let post = postsData[indexPath.section]
            
            guard post.photos.count == 1 else {
                return UITableView.automaticDimension
            }
            
            let tableWidth = tableView.bounds.width
            let cellHeight = tableWidth * (post.photos.first?.aspectRatio ?? 1)
            return cellHeight
            
        default:
            return UITableView.automaticDimension
        }
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
        self.refreshControl?.beginRefreshing()
        let mostFreshNewsDate = self.postsData.first?.item.date ?? Int(Date().timeIntervalSince1970)
        self.networkManager.loadPosts(startTime: Double(mostFreshNewsDate + 1)) { [weak self] response in
            
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
            }
            
            guard let self = self else { return }
            
            self.preparePostData(response: response) { data in
                guard !data.posts.isEmpty else { return }
                
                self.postsData = data.posts + self.postsData
                self.sectionBlocks = data.sections + self.sectionBlocks
                
                
                DispatchQueue.main.async {
                    let indexSet = IndexSet(integersIn: 0..<data.posts.count)
                    self.tableView.insertSections(indexSet, with: .automatic)
                }
            }
        }
    }
    
    @objc func scrollToTopHandle(_ sender: UIButton) {
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

extension NewsFeedTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        
        if maxSection > self.postsData.count - 3, !isLoading {
            isLoading = true
            self.networkManager.loadPosts(startFrom: self.nextFrom) { [weak self] (response) in
                guard let self = self else { return }
                
                self.preparePostData(response: response) { data in
                    if(data.posts.isEmpty) {
                        self.isLoading = false
                        return
                    }
                    
                    self.postsData.append(contentsOf: data.posts)
                    self.sectionBlocks.append(contentsOf: data.sections)
                    
                    DispatchQueue.main.async {
                        let newCount = self.postsData.count + data.posts.count
                        let indexSet = IndexSet(integersIn: self.postsData.count..<newCount)
                        self.tableView.insertSections(indexSet, with: .automatic)
                    }
                    
                    self.isLoading = false
                }
            }
        }
    }
}

protocol NewsSource {
    var title: String { get }
    var imageUrl: String { get }
}
