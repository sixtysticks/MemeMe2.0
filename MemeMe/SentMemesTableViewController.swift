//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by David Gibbs on 23/10/2016.
//  Copyright © 2016 SixtySticks. All rights reserved.
//

import UIKit
import Foundation

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Constants
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cellHeight = 60.0
    
    // MARK: IBOutlets
    
    @IBOutlet weak var memeTableView: UITableView!
    
    // MARK: ViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        memeTableView.rowHeight = CGFloat(cellHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memeTableView.reloadData()
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! CustomMemeTableCell

        let meme = appDelegate.memes[indexPath.row]
        
        // Set up labels and image
        
        cell.tableViewCellLabelTop.text = meme.topString!
        cell.tableViewCellLabelBottom.text = meme.bottomString!
        
        cell.setUpImage()
        cell.tableCellImageView.image = meme.originalImage!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "SentMemesDetailViewController") as! SentMemesDetailViewController
        
        let imageToDisplay = appDelegate.memes[indexPath.row]
        detailVC.image = imageToDisplay.memeImage!
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
