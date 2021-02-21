//
//  FriendsPhotosCollectionViewController.swift
//  Swift_CustomApp
//
//  Created by user192247 on 2/21/21.
//

import UIKit

class SimpleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    func bind(color: String, imageName: String) {
        contentView.backgroundColor = color.hexColor
        titleLabel.text = "\(arc4random_uniform(1000))"
    }
}

extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64 ()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class FriendsPhotosCollectionViewController: UICollectionViewController {
    
    let cellIdentifier = "SimpleCollectionViewCell"
    let vcs = [("f44336", "nature1"),
               ("9c27b0", "nature2"),
               ("3f51b5", "nature3"),
               ("03a9f4", "animal1"),
               ("009688", "animal2"),
               ("8bc34a", "animal3"),
               ("FFEB3B", "nature1"),
               ("FF9800", "nature2"),
               ("795548", "nature3"),
               ("607D8B", "animal1")]
    
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView?.isPagingEnabled = true
    }
}

extension FriendsPhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(Int16.max)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let cell = c as? SimpleCollectionViewCell {
            let i = indexPath.row % vcs.count
            let v = vcs[i]
            cell.bind(color: v.0, imageName: v.1)
            cell.clipsToBounds = false
        }
        
        return c
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

struct LinearCardAttributesAnimator {
    var minAlpha: CGFloat
    var itemSpacing: CGFloat
    var scaleRate: CGFloat
    
    init(minAlpha: CGFloat = 0.5, itemSpacing: CGFloat = 0.4, scaleRate: CGFloat = 0.7) {
        self.minAlpha = minAlpha
        self.itemSpacing = itemSpacing
        self.scaleRate = scaleRate
    }
    
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset
        let scaleFactor = self.scaleRate - 0.1 * abs(position)
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        guard attributes.scrollDirection == .horizontal else { return }
        
        let width = collectionView.frame.width
        let translationX = -(width * self.itemSpacing * position)
        let translationTransform = CGAffineTransform(translationX: translationX, y: 0)
        
        attributes.alpha = 1.0 - abs(position) + minAlpha
        attributes.transform = translationTransform.concatenating(scaleTransform)
    }
}

class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {
    var animator = LinearCardAttributesAnimator()
    
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
