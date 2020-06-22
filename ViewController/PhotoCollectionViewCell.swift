//
//  PhotoCollectionViewCell.swift
//  Tourist
//
//  Created by Ecem Aleyna on 17.05.2020.
//  Copyright © 2020 Ecem Aleyna. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    
//  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//
//        // Specify you want _full width_
//        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
//
//        // Calculate the size (height) using Auto Layout
//        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
//        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)
//
//        // Assign the new size to the layout attributes
//        autoLayoutAttributes.frame = autoLayoutFrame
//        return autoLayoutAttributes
//    }
    
    
}
