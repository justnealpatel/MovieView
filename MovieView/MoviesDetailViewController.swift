//
//  MoviesDetailViewController.swift
//  MovieView
//
//  Created by Neal Patel on 1/26/16.
//  Copyright © 2016 Neal Patel. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesDetailViewController: UIViewController {

    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!

    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title! = movie!["title"] as! String
        moviePosterView.alpha = 0
        print(movie)
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie!["poster_path"] as! String
        let fullImageURL = NSURL(string: baseURL + posterPath)
        movieTitle.text! = movie!["title"] as! String
        movieOverview.text! = movie!["overview"] as! String
        moviePosterView.setImageWithURL(fullImageURL!)
        fadeInPoster()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        movieOverview.sizeToFit()
    }
    
    func fadeInPoster(duration duration: NSTimeInterval = 2.0) {
        
            UIView.animateWithDuration(duration, animations: {
                
                self.moviePosterView.alpha = 1
            })
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
