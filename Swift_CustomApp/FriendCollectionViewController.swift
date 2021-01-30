//
//  AvatarCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

class FriendCollectionViewController: UICollectionViewController {
    
    var friend = Friend(fullName: "No name", photo: UIImage(systemName: "person.fill"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "FriendCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "AvatarCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! FriendCollectionViewCell
        
        // Configure the cell
        cell.fullNameLabel.text = friend.fullName
        cell.photoImageView.image = friend.photo?.resize(withWidth: UIScreen.main.bounds.width)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension UIImage {
    func resize(withWidth newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
