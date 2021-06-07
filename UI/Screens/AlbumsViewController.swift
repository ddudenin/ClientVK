//
//  AlbumsViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 06.06.2021.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class AlbumsViewController: ASDKViewController<ASDisplayNode> {
    
    var collectionNode: ASCollectionNode {
        return self.node as! ASCollectionNode
    }
    
    var friend: User?
    private var albums = [Album]()
    
    private let networkManager = NetworkManager.instance
    
    private func loadData() {
        guard let friend = self.friend else { return }
        
        self.networkManager.loadAlbums(userId: friend.id) { [weak self] (items) in
            DispatchQueue.main.async {
                self?.albums = items
                self?.collectionNode.reloadData()
            }
        }
    }
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        super.init(node: ASCollectionNode(collectionViewLayout: flowLayout))
        
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        
        self.collectionNode.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.albums.isEmpty {
            loadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlbumsViewController: ASCollectionDelegate, ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        return {
            PhotoCellNode(album: self.albums[indexPath.row])
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        self.collectionNode.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendCollectionView")
        (vc as? FriendPhotosCollectionViewController)?.configure(friend: self.friend, albumId: self.albums[indexPath.row].id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class PhotoCellNode: ASCellNode {
    
    let album: Album
    let imageNode = ASNetworkImageNode()
    let nameNode = ASTextNode()
    
    init(album: Album) {
        self.album = album
        super.init()
        
        self.setupSubnodes()
    }
    
    private func setupSubnodes() {
        self.nameNode.attributedText = NSAttributedString(string: self.album.title, attributes: [.font: UIFont.systemFont(ofSize: 13)])
        self.nameNode.backgroundColor = .systemBackground
        
        self.addSubnode(self.nameNode)
        
        self.imageNode.url = URL(string: album.thumbSrc)
        self.imageNode.shouldRenderProgressImages = true
        self.addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let width = UIScreen.main.bounds.width - 24
        let height = width
        self.imageNode.style.preferredSize = CGSize(width: width, height: height)
        
        let avatarNodeWithInsets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), child: self.imageNode)
        
        let nameNodeWithInsets = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: [], child: self.nameNode)
        
        let stack = ASStackLayoutSpec()
        stack.spacing = 8
        stack.direction = .vertical
        stack.children = [avatarNodeWithInsets, nameNodeWithInsets]
        return stack
    }
}
