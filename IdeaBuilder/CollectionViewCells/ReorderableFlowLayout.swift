//
//  ReorderableFlowLayout.swift
//  Bloco de Ideias
//
//  Created by Ada 2018 on 15/06/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import UIKit

class ReorderableFlowLayout : UICollectionViewFlowLayout {
    func layoutAttributesForInteractivelyMovingItemAtIndexPath(indexPath: NSIndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath as IndexPath, withTargetPosition: position)
        
        attributes.alpha = 0.7
        attributes.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        return attributes
    }
}
