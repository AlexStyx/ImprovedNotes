//
//  NotesListLayout.swift
//  ImprovedNotes
//
//  Created by Александр Бисеров on 2/16/22.
//

import UIKit


protocol NotesListLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: NotesListLayout, heightForLabelsAtIndexPath indexPath: IndexPath) -> CGFloat
}

class NotesListLayout: UICollectionViewLayout {
    
    public var delegate: NotesListLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var numberOfItems: Int = 0
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectioView = collectionView else { return 0 }
        
        let insets = collectioView.contentInset
        return collectioView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard
            let collectioView = collectionView,
            (cache.isEmpty || collectioView.numberOfItems(inSection: 0) != numberOfItems)
        else {
            return
        }
        numberOfItems = collectioView.numberOfItems(inSection: 0)
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
    
        for item in 0..<collectioView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let cellHeight = delegate?.collectionView(collectioView, layout: self, heightForLabelsAtIndexPath: indexPath) ?? collectioView.bounds.height / 2
            let height = cellPadding * 2 + cellHeight
    
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            
            contentHeight = max(contentHeight, frame.maxY)
            
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleAttributes.append(attributes)
            }
        }
        return visibleAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
