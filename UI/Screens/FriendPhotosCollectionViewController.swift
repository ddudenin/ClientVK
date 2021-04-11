//
//  AvatarCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 30.01.2021.
//

import UIKit
import RealmSwift

final class FriendPhotosCollectionViewController: UICollectionViewController {
    
    var friend: User?
    
    private var photos: Results<Photo>? {
        get {
            guard let friend = self.friend else { return nil }
            
            let photos: Results<Photo>? = realmManager?.getObjects()
            return photos?.filter("ownerID = %@", friend.id)
        }
        
        set { }
    }
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    private var notificationToken: NotificationToken?
    
    private func loadData() {
        guard let friend = self.friend else { return }
        
        self.networkManager.loadPhotos(userId: friend.id) { [weak self] items in
            DispatchQueue.main.async {
                do {
                    try self?.realmManager?.add(objects: items)
                } catch {
                    print(error.localizedDescription)
                }
                
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func signToPhotosChanges() {
        self.notificationToken = self.photos?.observe { [weak self] (change) in
            switch change {
            case .initial(let photos):
                #if DEBUG
                print("Initialized \(photos.count)")
                #endif
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                
                let deletionsIndexPaths = deletions.map { IndexPath(row: $0, section: 0) }
                let insertionsIndexPaths = insertions.map { IndexPath(row: $0, section: 0) }
                let modificationsIndexPaths = modifications.map { IndexPath(row: $0, section: 0) }
                
                #if DEBUG
                print(deletions, insertions, modifications)
                #endif
                
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.deleteItems(at: deletionsIndexPaths)
                    self?.collectionView.insertItems(at: insertionsIndexPaths)
                    self?.collectionView.reloadItems(at: modificationsIndexPaths)
                }
            case .error(let error):
                print(error.localizedDescription)
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
        
        signToPhotosChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userPhoto = self.photos, userPhoto.isEmpty {
            loadData()
        }
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photo = self.photos?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! FriendPhotoCollectionViewCell
        
        let handle: (Bool, Int) -> Void = { [weak self] state, count in
            do {
                self?.realmManager?.beginWrite()
                photo.likes?.userLikes = state ? 1 : 0
                photo.likes?.count = count
                try self?.realmManager?.endWrite()
            } catch {
                print(error.localizedDescription)
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
