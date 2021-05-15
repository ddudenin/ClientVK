//
//  NewsFeedImagesTableViewCell.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/10/21.
//

import UIKit
import SDWebImage

final class NewsFeedImagesTableViewCell: UITableViewCell {
    
    @IBOutlet private var imagesCollectionView: UICollectionView!

    private var imagesURL = [String]()
    
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
    
    func configure(withPost post: PostData) {
        self.imagesURL = post.photos
        self.imagesCollectionView.reloadData()
        self.imagesCollectionView.layoutIfNeeded()
    }
}

extension NewsFeedImagesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsFeedImageCell", for: indexPath) as! NewsFeedImageCollectionViewCell
        
        cell.configure(withStringURL: self.imagesURL[indexPath.row])
        
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
