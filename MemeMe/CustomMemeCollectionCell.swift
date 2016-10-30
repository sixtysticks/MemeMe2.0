//
//  CustomMemeCollectionCell.swift
//  MemeMe
//
//  Created by David Gibbs on 25/10/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit

class CustomMemeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setUpImage() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
}
