//
//  AvatarCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 30.01.2021.
//

import UIKit
import RealmSwift

final class FriendPhotosCollectionViewController: UICollectionViewController {
    
    private var friend: UserDTO?
    private var albumID: Int = -1
    
    private var photos: Results<RLMPhoto>? {
        get {
            guard let friend = self.friend else { return nil }
            
            let photos: Results<RLMPhoto>? = self.realmManager?.getObjects()
            return photos?.filter("albumId = %@ AND ownerId = %@", self.albumID, friend.id)
        }
        
        set { }
    }
    
    private var photosDiaplayItems = [PhotoDisplayItem]()
    
    private let networkManager = NetworkManager.instance
    private let realmManager = RealmManager.instance
    private var notificationToken: NotificationToken?
    
    private func loadData() {
        guard let friend = self.friend else { return }
        
        self.networkManager.loadPhotos(userId: friend.id) { [weak self] (items) in
            DispatchQueue.main.async {
                do {
                    try self?.realmManager?.add(objects: items)
                } catch {
                    print(error.localizedDescription)
                }
                
                self?.photosDiaplayItems = items.map {
                    PhotoDisplayItemFactory.make(for: $0)
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
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    self?.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    self?.collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configure(friend user: UserDTO?, albumId id: Int) {
        self.friend = user
        self.albumID = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView.register(UINib(nibName: "FriendPhotoCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "FriendPhotoCell")
        
        // Do any additional setup after loading the view.
        self.title = self.friend?.fullName
        
        signToPhotosChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let userPhoto = self.photos else { return }
        
        if userPhoto.isEmpty {
            loadData()
        } else {
            self.photosDiaplayItems = userPhoto.map {
                PhotoDisplayItemFactory.make(for: $0)
            }
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
        let photo = self.photos?[indexPath.row]
        let item = self.photosDiaplayItems[indexPath.row]
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! FriendPhotoCollectionViewCell
        
        let handle: (Bool, Int) -> Void = { [weak self] (state, count) in
            do {
                try self?.realmManager?.update {
                    photo?.likes?.userLikes = state ? 1 : 0
                    photo?.likes?.count = count
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // Configure the cell
        cell.configure(withPhoto: item, handler: handle)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendPhotosCollectionView")
        
        guard let carouselVC = vc as? PhotosCarouselCollectionViewController else {
            return
        }
        
        carouselVC.photos = self.photosDiaplayItems
        carouselVC.index = indexPath.row
        
        self.navigationController?.pushViewController(carouselVC, animated: true)
    }
}
