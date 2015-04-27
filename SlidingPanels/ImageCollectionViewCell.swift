//
//  ImageCollectionViewCell.swift
//  SlidingPanels
//
//  Created by Ipalibo Whyte on 4/26/15.
//  Copyright (c) 2015 Ipalibo Whyte. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let image = UIImage(named: "A1.png")
        let imageView = UIImageView(image: image)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        return imageView
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        let views = [
            "imageView": imageView
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options: nil, metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: nil, metrics: nil, views: views))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
