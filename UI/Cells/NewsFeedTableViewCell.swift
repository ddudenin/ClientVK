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
    @IBOutlet private var viewsCountLabel: UILabel!
    @IBOutlet private var imagesCollectionsViews: UICollectionView!
    @IBOutlet private var likeControl: LikeControl!
    
    private var imagesNames = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imagesCollectionsViews.dataSource = self
        self.imagesCollectionsViews.delegate = self
        
        self.imagesCollectionsViews.register(UINib(nibName: "NewsFeedImageCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "PostImageCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withPost post: Post) {
        self.createdByLabel.text = post.createdBy.fullName
        self.timeAgoLabel.text = generateTimeAgoDisplay()
        self.profileImageView.sd_setImage(with: URL(string: post.createdBy.photo200_Orig))
        self.captionLabel.text = post.caption
        self.imagesNames = post.imagesNames
        self.likeControl.configure(withLikesCount: Int(post.likesCount), state: Bool.random())
        self.commentsButton.setTitle(convertCountToString(count: post.commentsCount), for: .normal)
        self.sharesButton.setTitle(convertCountToString(count: post.sharesCount), for: .normal)
        self.viewsCountLabel.text = convertCountToString(count: post.viewsCount)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as! NewsFeedImageCollectionViewCell
        
        cell.configure(withStringURL: self.imagesNames[indexPath.row])

        return cell
    }
}
