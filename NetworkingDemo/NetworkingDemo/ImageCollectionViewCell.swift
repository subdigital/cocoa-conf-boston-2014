//
//  ImageCollectionViewCell.swift
//  NetworkingDemo
//
//  Created by Ben Scheirman on 11/9/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
