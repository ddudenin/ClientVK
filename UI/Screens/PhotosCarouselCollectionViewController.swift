//
//  PhotosCarouselCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/21/21.
//

import UIKit
import RealmSwift

final class PhotosCarouselCollectionViewController: UICollectionViewController {
    
    var photos: Results<Photo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView.register(UINib(nibName: "CarouselPhotoCollectionViewCell", bundle: .none), forCellWithReuseIdentifier: "CarouselPhotoCell")
    }
}

extension PhotosCarouselCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselPhotoCell", for: indexPath) as! CarouselPhotoCollectionViewCell
        
        cell.configure(withPhoto: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
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

final class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var animator = PageAttributesAnimator()
    
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
        
        let attr = attributes
        let distance: CGFloat
        let itemOffset: CGFloat
        
        self.scrollDirection = .horizontal
        
        distance = collectionView.frame.width
        itemOffset = attr.center.x - collectionView.contentOffset.x
        attr.startOffset = (attr.frame.origin.x - collectionView.contentOffset.x) / attr.frame.width
        attr.endOffset = (attr.frame.origin.x - collectionView.contentOffset.x - collectionView.frame.width) / attr.frame.width
        
        attr.scrollDirection = .horizontal
        attr.middleOffset = itemOffset / distance - 0.5
        
        if attr.contentView == nil,
           let content = collectionView.cellForItem(at: attributes.indexPath)?.contentView {
            attr.contentView = content
        }
        
        self.animator.animate(collectionView: collectionView, attributes: attr)
        
        return attr
    }
}

final class AnimatedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
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

fileprivate struct PageAttributesAnimator {
    
    private var scaleRate: CGFloat
    
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
