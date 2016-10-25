//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by David Gibbs on 23/10/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var memeCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memeCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) as! CustomMemeCell
        
        let meme = appDelegate.memes[indexPath.row]
        
        cell.memeLabel.text = meme.topString
        cell.imageView.image = meme.originalImage
        cell.backgroundColor = UIColor.darkGray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        
        let imageToDisplay = appDelegate.memes[indexPath.row]
        detailVC.image = imageToDisplay.memeImage!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
