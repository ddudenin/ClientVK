//
//  AvatarCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

final class FriendPhotosCollectionViewController: UICollectionViewController {
    
    var friend: User?
    
    private var photos = [Photo]()
    
    private let networkManager = NetworkManager.instance
    private var photosRef = Database.database().reference(withPath: "\(Session.instance.userId)/Photos")
    
    private var photosCollection = Firestore.firestore().collection("Users/\(Session.instance.userId)/Photos")
    private var listener: ListenerRegistration?
    
    private func loadData() {
        guard let friend = self.friend else { return }
        
        self.networkManager.loadPhotos(userId: friend.id) { [weak self] items in
            DispatchQueue.main.async {
                let firebasePhoto = items.map { Photo(from: $0) }
                
                switch Config.databaseType {
                case .database:
                    for photo in firebasePhoto {
                        self?.photosRef.child("\(photo.id)").setValue(photo.toAnyObject())
                    }
                case .firestore:
                    for photo in firebasePhoto {
                        self?.photosCollection.document("\(photo.id)").setData(photo.toAnyObject())
                    }
                }
                
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func loadDataFromDatabase() {
        self.photosRef.observe(.value) { [weak self] (snapshot) in
            DispatchQueue.main.async {
            
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
                
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func loadDataFromFirestore() {
        self.listener = self.photosCollection.addSnapshotListener { [weak self] (snapshot, error) in
            DispatchQueue.main.async {
                
                guard let snapshot = snapshot,
                      !snapshot.documents.isEmpty
                else {
                    self?.loadData()
                    return
                }

                self?.photos.removeAll()

                for doc in snapshot.documents {
                    guard let photo = Photo(dict: doc.data()) else { continue }
                    if photo.ownerID == self?.friend?.id {
                        self?.photos.append(photo)
                    }
                }
                
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
        
        switch Config.databaseType {
        case .database:
            loadDataFromDatabase()
        case .firestore:
            loadDataFromFirestore()
        }
    }
    
    deinit {
        switch Config.databaseType {
        case .database:
            self.photosRef.removeAllObservers()
        case .firestore:
            self.listener?.remove()
        }
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
        
        let handle: (Bool, Int) -> Void
        
        switch Config.databaseType {
        case .database:
            handle = { [weak self] state, count in
                photo.likes.userLikes = state ? 1 : 0
                photo.likes.count = count
                self?.photosRef.child("\(photo.id)").setValue(photo.toAnyObject()) { (error, _) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        case .firestore:
            handle = { [weak self] state, count in
                photo.likes.userLikes = state ? 1 : 0
                photo.likes.count = count
                self?.photosCollection.document("\(photo.id)").setData(photo.toAnyObject()) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
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
