//
//  PostCollectionViewLayout.swift
//  Swift_CustomApp
//
//  Created by Дмитрий on 2/13/21.
//

import UIKit

class PostCollectionViewLayout: UICollectionViewFlowLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    var cellHeight: CGFloat = 128
    private var totalCellsHeight: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        guard itemsCount > 0 else { return }
        
        let halfCellWidth = collectionView.frame.width / 2
        let smallCellWidth = collectionView.frame.width / 3
        
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        if itemsCount == 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = CGRect(x: lastX, y: lastY,
                                      width: collectionView.frame.width, height: self.cellHeight)
            lastY += self.cellHeight
            
            cacheAttributes[indexPath] = attributes
            self.totalCellsHeight = lastY
            
            return
        }
        
        var halfCount = itemsCount % 3
        if halfCount == 1 {
            halfCount = 4
        }
        var addedCount = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if index < halfCount {
                attributes.frame = CGRect(x: lastX, y: lastY,
                                          width: halfCellWidth, height: self.cellHeight)
                
                if (index + 1) % 2 == 0 {
                    lastX = 0
                    lastY += self.cellHeight
                } else {
                    lastX += halfCellWidth
                }
            } else {
                attributes.frame = CGRect(x: lastX, y: lastY,
                                          width: smallCellWidth, height: self.cellHeight)
                if addedCount == 2 {
                    lastX = 0
                    lastY += self.cellHeight
                    addedCount = 0
                } else {
                    lastX += smallCellWidth
                    addedCount += 1
                }
            }
            
            cacheAttributes[indexPath] = attributes
            self.totalCellsHeight = lastY
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in self.cacheAttributes.values {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: self.totalCellsHeight)
    }
}
