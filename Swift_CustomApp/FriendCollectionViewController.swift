//
//  AvatarCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit

class FriendCollectionViewController: UICollectionViewController {
    
    var friend = Friend(name: "No", surname: "Name", photoName: "")
    var photos: [UIImage] = {
        var arr = [UIImage]()
        
        for _ in 1...Int.random(in: 2...10) {
            arr.append(UIImage(named: friendsArray.randomElement()!.photoName)!)
        }
        
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "FriendCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "AvatarCell")
        
        photos.insert(UIImage(named: friend.photoName)!, at: 0)

        // Do any additional setup after loading the view.
        self.title = "\(self.friend.getFullName())"
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! FriendCollectionViewCell
        
        // Configure the cell
        cell.photoImageView.image = photos[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendPhotosCollectionView")
        (vc as? FriendsPhotosCollectionViewController)?.photos = self.photos
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
