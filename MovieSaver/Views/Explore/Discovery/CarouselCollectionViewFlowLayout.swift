//
//  CarouselCollectionViewFlowLayout.swift
//  MovieSaver
//
//  Created by tungdd on 16/05/2024.
//

import UIKit

class CarouselViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var position: CGFloat = 0
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CarouselViewLayoutAttributes else {
            return false
        }
        var isEqual = super.isEqual(object)
        isEqual = isEqual && (position == object.position)
        return isEqual
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CarouselViewLayoutAttributes
        copy.position = position
        return copy
    }
}


class CarouselCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var contentSize: CGSize = .zero
    var collectionViewSize: CGSize = .zero
    var leadingSpacing: CGFloat = 0
    var itemSpacing: CGFloat = 195
    var needsReprepare = true
    var minimumScale: CGFloat = 164 / 195
    var minimumAlpha: CGFloat = 0.6
    var numberOfSections = 1
    var numberOfItems = 5
    var actualInteritemSpacing: CGFloat = 16
    
    var actualItemSize: CGSize = .init(width: 195, height: 195)
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        
        guard needsReprepare || collectionViewSize != collectionView.frame.size else {
            return
        }
        needsReprepare = false
        
        actualItemSize = itemSize
        
        collectionViewSize = collectionView.frame.size
        
        leadingSpacing = (collectionView.frame.width - actualItemSize.width) * 0.5
        
        contentSize = {
            let numberOfItems = self.numberOfItems * self.numberOfSections
            var contentSizeWidth: CGFloat = self.leadingSpacing *
            2
            contentSizeWidth += CGFloat(numberOfItems - 1) * self.actualInteritemSpacing
            contentSizeWidth += CGFloat(numberOfItems) * self.actualItemSize.width
            let contentSize = CGSize(width: contentSizeWidth, height: collectionView.frame.height)
            return contentSize
        }()
        adjustCollectionViewBounds()
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        guard itemSpacing > 0, !rect.isEmpty else {
            return layoutAttributes
        }
        
        let rect = rect.intersection(CGRect(origin: .zero, size: contentSize))
        guard !rect.isEmpty else {
            return layoutAttributes
        }
        
        let numberOfItemsBefore = max(Int((rect.minX - leadingSpacing) / itemSpacing), 0)
        let startPosition = leadingSpacing + CGFloat(numberOfItemsBefore) * itemSpacing
        let startIndex = numberOfItemsBefore
        
        var itemIndex = startIndex
        var origin = startPosition
        
        let maxPosition = min(rect.maxX, contentSize.width - actualItemSize.width - leadingSpacing)
        
        while origin - maxPosition <= max(CGFloat(100.0) * .ulpOfOne * abs(origin + maxPosition), .leastNonzeroMagnitude) {
            let indexPath = IndexPath(item: itemIndex % numberOfItems, section: itemIndex / numberOfItems)
            let attributes = layoutAttributesForItem(at: indexPath) as! CarouselViewLayoutAttributes
            applyTransform(to: attributes)
            layoutAttributes.append(attributes)
            itemIndex += 1
            origin += itemSpacing
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = CarouselViewLayoutAttributes(forCellWith: indexPath)
        attributes.indexPath = indexPath
        let frame = frame(for: indexPath)
        let center = CGPoint(x: frame.midX, y: frame.midY)
        attributes.center = center
        attributes.size = actualItemSize
        return attributes
    }
    
    override open func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint)
    -> CGPoint
    {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        var proposedContentOffset = proposedContentOffset
        
        func calculateTargetOffset(by proposedOffset: CGFloat, boundedOffset: CGFloat) -> CGFloat {
            var targetOffset: CGFloat
            switch velocity.x {
            case 0.3 ... CGFloat.greatestFiniteMagnitude:
                targetOffset = ceil(collectionView.contentOffset.x / itemSpacing) * itemSpacing
            case -CGFloat.greatestFiniteMagnitude ... -0.3:
                targetOffset = floor(collectionView.contentOffset.x / itemSpacing) * itemSpacing
            default:
                targetOffset = round(proposedOffset / itemSpacing) * itemSpacing
            }
            targetOffset = max(0, targetOffset)
            targetOffset = min(boundedOffset, targetOffset)
            return targetOffset
        }
        let proposedContentOffsetX: CGFloat = {
            let boundedOffset = collectionView.contentSize.width - self.itemSpacing
            return calculateTargetOffset(by: proposedContentOffset.x, boundedOffset: boundedOffset)
        }()
        let proposedContentOffsetY: CGFloat = proposedContentOffset.y
        proposedContentOffset = CGPoint(x: proposedContentOffsetX, y: proposedContentOffsetY)
        return proposedContentOffset
    }
    
    func contentOffset(for indexPath: IndexPath) -> CGPoint {
        let origin = frame(for: indexPath).origin
        guard let collectionView = collectionView else {
            return origin
        }
        let contentOffsetX: CGFloat = {
            let contentOffsetX = origin.x - (collectionView.frame.width * 0.5 - self.actualItemSize.width * 0.5)
            return contentOffsetX
        }()
        
        let contentOffsetY: CGFloat = 0
        let contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY)
        
        return contentOffset
    }
    
    func adjustCollectionViewBounds() {
        guard let collectionView = collectionView else {
            return
        }
        let newIndexPath = IndexPath(item: 0, section: numberOfSections / 2)
        let contentOffset = self.contentOffset(for: newIndexPath)
        let newBounds = CGRect(origin: contentOffset, size: collectionView.frame.size)
        collectionView.bounds = newBounds
    }
    
    func applyTransform(to attributes: UICollectionViewLayoutAttributes) {
        guard let collectionView = collectionView else {
            return
        }
        let ruler = collectionView.bounds.midX
        let position = (attributes.center.x - ruler) / itemSpacing
        attributes.zIndex = Int(numberOfItems) - Int(position)
        let scale = max(1 - (1 - minimumScale) * abs(position), minimumScale)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        attributes.transform = transform
        let alpha = (minimumAlpha + (1 - abs(position)) * (1 - minimumAlpha))
        attributes.alpha = alpha
        let zIndex = (1 - abs(position)) * 10
        attributes.zIndex = Int(zIndex)
    }
    
    internal func frame(for indexPath: IndexPath) -> CGRect {
        let numberOfItems = numberOfItems * indexPath.section + indexPath.item
        let originX: CGFloat = leadingSpacing + CGFloat(numberOfItems) * itemSpacing
        let originY: CGFloat = (collectionView!.frame.height - actualItemSize.height) * 0.5
        
        let origin = CGPoint(x: originX, y: originY)
        let frame = CGRect(origin: origin, size: actualItemSize)
        return frame
    }
}

