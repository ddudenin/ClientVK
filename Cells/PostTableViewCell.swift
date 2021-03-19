//
//  PostTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var createdByLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        }
    }
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var commentsButton: UIButton!
    @IBOutlet var sharesButton: UIButton!
    @IBOutlet var viewsCountLabel: UILabel!
    @IBOutlet var imagesCollectionsViews: UICollectionView!
    @IBOutlet var likeControl: LikeControl!
    
    var imagesNames = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imagesCollectionsViews.dataSource = self
        self.imagesCollectionsViews.delegate = self

        self.imagesCollectionsViews.register(UINib(nibName: "PostImageCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "PostImageCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension PostTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as! PostImageCollectionViewCell
        
        cell.imageView.image = UIImage(named: self.imagesNames[indexPath.row])
 
        return cell
    }
}
