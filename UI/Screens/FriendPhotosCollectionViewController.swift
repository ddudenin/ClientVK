//
//  AvatarCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import FirebaseDatabase

final class FriendPhotosCollectionViewController: UICollectionViewController {
    
    var friend: User?
    
    private var photos = [Photo]()
    
    private let networkManager = NetworkManager.instance
    private var photosRef = Database.database().reference(withPath: "Photos")
    
    private func loadData() {
        guard let friend = self.friend else { return }
        
        self.networkManager.loadPhotos(userId: friend.id) { [weak self] items in
            let firebasePhoto = items.map { Photo(from: $0) }
            
            for photo in firebasePhoto {
                self?.photosRef.child("\(photo.id)").setValue(photo.toAnyObject())
            }

            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func loadDataFromFirebase() {
        self.photosRef.observe(.value) { [weak self] (snapshot) in
            self?.photos.removeAll()
            
            guard !snapshot.children.allObjects.isEmpty else {
                self?.loadData()
                return
            }
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot,
                      let photo = Photo(snapshot: child) else {
                    continue
                }
                
                if photo.ownerID == self?.friend?.id {
                    self?.photos.append(photo)
                }
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView.register(UINib(nibName: "FriendPhotoCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "FriendPhotoCell")
        
        // Do any additional setup after loading the view.
        guard let friend = self.friend else { return }
        self.title = friend.getFullName()
        
        loadDataFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    deinit {
        self.photosRef.removeAllObservers()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! FriendPhotoCollectionViewCell
        
        let photo = self.photos[indexPath.row]

        let handle: (Bool, Int) -> Void = { [weak self] state, count in
            photo.likes.userLikes = state ? 1 : 0
            photo.likes.count = count
            self?.photosRef.child("\(photo.id)").setValue(photo.toAnyObject()) { (error, _) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        // Configure the cell
        cell.configure(withPhoto: photo, handler: handle)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendPhotosCollectionView")
        (vc as? PhotosCarouselCollectionViewController)?.photos = self.photos
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
