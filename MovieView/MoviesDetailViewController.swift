//
//  MoviesDetailViewController.swift
//  MovieView
//
//  Created by Neal Patel on 1/26/16.
//  Copyright © 2016 Neal Patel. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieCell: UITableViewCell!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UITextView!

    var movietitle = ""
    var movieoverview = ""
    var movieposterurl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("second VC, title = \(movietitle)")
        let fullImageURL = NSURL(string: movieposterurl)
        moviePoster.setImageWithURL(fullImageURL!)
        movieTitle.text! = movietitle
        movieOverview.text! = movieoverview
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = movieCell
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
