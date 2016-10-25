//
//  SentMemesDetailViewController.swift
//  MemeMe
//
//  Created by David Gibbs on 25/10/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {
    
    var image = UIImage()
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedImageView.image = image
    }

}
