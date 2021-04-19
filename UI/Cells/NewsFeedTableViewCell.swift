//
//  NewsFeedTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit
import SDWebImage

final class NewsFeedTableViewCell: UITableViewCell {
    
    @IBOutlet private var createdByLabel: UILabel!
    @IBOutlet private var timeAgoLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        }
    }
    @IBOutlet private var captionLabel: UILabel!
    @IBOutlet private var commentsButton: UIButton!
    @IBOutlet private var sharesButton: UIButton!
    @IBOutlet var viewsButton: UIButton!
    @IBOutlet private var imagesCollectionView: UICollectionView!
    @IBOutlet private var likeControl: LikeControl!
    
    private var imagesNames = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.delegate = self
        
        self.imagesCollectionView.register(UINib(nibName: "NewsFeedImageCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "NewsFeedImageCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withPost post: Article) {
        self.createdByLabel.text = post.source.name
        self.timeAgoLabel.text = utcToTimeAgoDisplay(dateString: post.publishedAt)
        self.profileImageView.sd_setImage(with: URL(string: post.urlToImage ?? "https://picsum.photos/seed/picsum/200/300"))
        self.captionLabel.text = post.articleDescription ?? post.title
        
        self.imagesNames = []
        
        if let postImage = post.urlToImage {
            self.imagesNames.append(postImage)
        } else {
            for _ in 0...Int.random(in: 0...10)  {
                self.imagesNames.append("https://picsum.photos/id/\(Int.random(in: 0...1050))/200/200")
            }
        }
        
        self.likeControl.configure(withLikesCount: Int.random(in: 0...1000000), state: Bool.random())
        self.commentsButton.setTitle(convertCountToString(count: Int.random(in: 0...1000000)), for: .normal)
        self.sharesButton.setTitle(convertCountToString(count: Int.random(in: 0...10000000)), for: .normal)
        self.viewsButton.setTitle(convertCountToString(count: Int.random(in: 0...10000000)), for: .normal)
        
        self.imagesCollectionView.reloadData()
        self.imagesCollectionView.layoutIfNeeded()
    }
}

extension NewsFeedTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsFeedImageCell", for: indexPath) as! NewsFeedImageCollectionViewCell
        
        cell.configure(withStringURL: self.imagesNames[indexPath.row])
        
        return cell
    }
}

final class NewsFeedPhotosCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }
}
