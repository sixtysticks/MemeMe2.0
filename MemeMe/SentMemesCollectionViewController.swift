//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by David Gibbs on 23/10/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit
import Foundation

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Constants
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: IBOutlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    // MARK: ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memeCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {

        // Implement flowLayout for consistent collection view layout
        
        let space: CGFloat = 3.0
        var dimension = CGFloat()
        
        if (UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
            dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        } else {
            dimension = (self.view.frame.size.width - (4 * space)) / 5.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK: UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCollectionCell", for: indexPath) as! CustomMemeCollectionCell
        let meme = appDelegate.memes[indexPath.row]
        cell.setUpImage()
        cell.imageView.image = meme.originalImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        
        let imageToDisplay = appDelegate.memes[indexPath.row]
        detailVC.image = imageToDisplay.memeImage!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
