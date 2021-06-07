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
    private var photos = [Photo]()
    
    private let networkManager = NetworkManager.instance

    private func loadData() {
        guard let friend = self.friend else { return }
        
        self.networkManager.loadPhotos(userId: friend.id) { [weak self] (items) in
            DispatchQueue.main.async {
                self?.photos = items
                self?.collectionNode.reloadData()
            }
        }
    }
    
    override init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(node: ASCollectionNode(collectionViewLayout: flowLayout))
        
        self.collectionNode.delegate = self
        self.collectionNode.dataSource = self
        
        self.collectionNode.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.photos.isEmpty {
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
        return self.photos.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        return {
            PhotoCellNode(photo: self.photos[indexPath.row])
        }
    }
}

class PhotoCellNode: ASCellNode {
    
    let photo: Photo
    let imageNode = ASNetworkImageNode()
    
    init(photo: Photo) {
        self.photo = photo
        super.init()
        
        self.setupSubnodes()
    }
    
    private func setupSubnodes() {
        self.imageNode.url = URL(string: photo.sizes.first(where: { $0.type == "x"})?.url ?? "")
        self.imageNode.shouldRenderProgressImages = true
        self.addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let width = UIScreen.main.bounds.width - 24
        let height = width * (photo.sizes.first(where: { $0.type == "x"})?.aspectRatio ?? 1)
        
        self.imageNode.style.preferredSize = CGSize(width: width, height: height)
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), child: self.imageNode)
        
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 12,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [insets])
    }
}
