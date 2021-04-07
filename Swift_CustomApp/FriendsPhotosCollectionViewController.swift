//
//  FriendsPhotosCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/21/21.
//

import UIKit

class FriendsPhotosCollectionViewController: UICollectionViewController {
    var photos: [PhotoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "FriendPhotoCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "FriendPhotoCell")
    }
}

extension FriendsPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! FriendPhotoCollectionViewCell
        
        cell.configure(withPhoto: self.photos[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    var animator = PageAttributesAnimator()
    
    class override var layoutAttributesClass: AnyClass {
        return AnimatedCollectionViewLayoutAttributes.self
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        return attributes.compactMap { $0.copy() as? AnimatedCollectionViewLayoutAttributes }.map { self.transformLayoutAttributes($0) }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func transformLayoutAttributes(_ attributes: AnimatedCollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else { return attributes }
        
        let a = attributes
        let distance: CGFloat
        let itemOffset: CGFloat
        
        self.scrollDirection = .horizontal
        
        distance = collectionView.frame.width
        itemOffset = a.center.x - collectionView.contentOffset.x
        a.startOffset = (a.frame.origin.x - collectionView.contentOffset.x) / a.frame.width
        a.endOffset = (a.frame.origin.x - collectionView.contentOffset.x - collectionView.frame.width) / a.frame.width
        
        a.scrollDirection = .horizontal
        a.middleOffset = itemOffset / distance - 0.5
        
        if a.contentView == nil,
           let c = collectionView.cellForItem(at: attributes.indexPath)?.contentView {
            a.contentView = c
        }
        
        self.animator.animate(collectionView: collectionView, attributes: a)
        
        return a
    }
}

class AnimatedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var contentView: UIView?
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    var startOffset: CGFloat = 0
    var middleOffset: CGFloat = 0
    var endOffset: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! AnimatedCollectionViewLayoutAttributes
        copy.contentView = self.contentView
        copy.scrollDirection = self.scrollDirection
        copy.startOffset = self.startOffset
        copy.middleOffset = self.middleOffset
        copy.endOffset = self.endOffset
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? AnimatedCollectionViewLayoutAttributes else { return false }
        
        return super.isEqual(obj)
            && obj.contentView == self.contentView
            && obj.scrollDirection == self.scrollDirection
            && obj.startOffset == self.startOffset
            && obj.middleOffset == self.middleOffset
            && obj.endOffset == self.endOffset
    }
}

struct PageAttributesAnimator {
    var scaleRate: CGFloat
    
    init(scaleRate: CGFloat = 0.3) {
        self.scaleRate = scaleRate
    }
    
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset
        let contentOffset = collectionView.contentOffset
        let itemOrigin = attributes.frame.origin
        let scaleFactor = self.scaleRate * min(position, 0) + 1.0
        var transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        guard attributes.scrollDirection == .horizontal else { return }
        
        transform = transform.concatenating(CGAffineTransform(translationX: position < 0 ? contentOffset.x - itemOrigin.x : 0, y: 0))
        
        attributes.transform = transform
        attributes.zIndex = attributes.indexPath.row
    }
}
