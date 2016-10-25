//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by David Gibbs on 23/10/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var memeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as UITableViewCell
        
        let meme = appDelegate.memes[indexPath.row]
        
        cell.textLabel?.text = meme.topString!
        cell.imageView?.image = meme.originalImage!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        
        let imageToDisplay = appDelegate.memes[indexPath.row]
        detailVC.image = imageToDisplay.memeImage!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
