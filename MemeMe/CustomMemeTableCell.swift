//
//  CustomMemeTableCell.swift
//  MemeMe
//
//  Created by David Gibbs on 30/10/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit

class CustomMemeTableCell: UITableViewCell {
    
    // MARK: Constants
    
    let imageWidth: CGFloat = 60.0
    let imageHeight: CGFloat = 60.0
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableViewCellLabelTop: UILabel!
    @IBOutlet weak var tableViewCellLabelBottom: UILabel!
    @IBOutlet weak var tableCellImageView: UIImageView!
    
    // MARK: Custom methods
    
    func setUpImage() {
        let imageSize = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        tableCellImageView.frame = imageSize
        tableCellImageView.contentMode = .scaleAspectFill
        tableCellImageView.clipsToBounds = true
    }
    
}
