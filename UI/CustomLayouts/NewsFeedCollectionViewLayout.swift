//
//  NewsFeedCollectionViewLayout.swift
//  Swift_CustomApp
//
//  Created by Дмитрий Дуденин on 13.02.2021.
//

import UIKit

final class NewsFeedCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var contentSize = CGSize(width: 0, height: 0)
    
    override func prepare() {
        super.prepare()
        
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        guard itemsCount > 0 else { return }
        
        self.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        
        if itemsCount == 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = CGRect(x: 0, y: 0,
                                      width: self.contentSize.width, height: self.contentSize.height)
            
            self.cacheAttributes[indexPath] = attributes
            
            return
        }
        
        let halfCellWidth = ceil(collectionView.frame.width / 2)
        let smallCellWidth = ceil(collectionView.frame.width / 3)
        
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        var halfCount = itemsCount % 3
        if halfCount == 1 {
            halfCount = 4
        }
        var addedCount = 0
        
        let rowCount = halfCount / 2 + (itemsCount - halfCount) / 3
        let cellHeight = ceil(self.contentSize.height / CGFloat(rowCount))
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if index < halfCount {
                attributes.frame = CGRect(x: lastX, y: lastY,
                                          width: halfCellWidth, height: cellHeight)
                
                if (index + 1) % 2 == 0 {
                    lastX = 0
                    lastY += cellHeight
                } else {
                    lastX += halfCellWidth
                }
            } else {
                attributes.frame = CGRect(x: lastX, y: lastY,
                                          width: smallCellWidth, height: cellHeight)
                if addedCount == 2 {
                    lastX = 0
                    lastY += cellHeight
                    addedCount = 0
                } else {
                    lastX += smallCellWidth
                    addedCount += 1
                }
            }
            
            self.cacheAttributes[indexPath] = attributes
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
        return self.cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
}
