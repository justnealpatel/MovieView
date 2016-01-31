//
//  MoviesViewController.swift
//  MovieView
//
//  Created by Neal Patel on 1/24/16.
//  Copyright © 2016 Neal Patel. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieSearch: UISearchBar!
    @IBOutlet weak var networkErrorView: UIImageView!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var searchController: UISearchController!
    var specMovieTitle = ""
    var specMovieOverview = ""
    var specMoviePosterURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if Reachability.isConnectedToNetwork() == true {
//            
//            print("success")
//            networkErrorView = nil
//        }
//        
//        else {
//            
//            print("fail")
//            networkErrorView.image = UIImage(named: "NetworkError")
//        }
        
        movieSearch.delegate = self
        movieTableView.dataSource = self
        movieTableView.delegate = self
        loadDataFromNetwork()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        movieTableView.insertSubview(refreshControl, atIndex: 0)
        // NETWORK REQUEST
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.movieTableView.reloadData()
                    }
                }
        })
        task.resume()
    }
    
    // REFRESHER
    func loadDataFromNetwork() {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        SVProgressHUD.showWithStatus("Loading")
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                SVProgressHUD.dismiss()
                // ... Remainder of response handling code ...
                
        });
        task.resume()
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // ... Use the new data to update the data source ...
                if let data = data {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.movieTableView.reloadData()
                    }
                }
                
                // Reload the tableView now that there is new data
                if Reachability.isConnectedToNetwork() == true {
                    
                    print("success")
                    self.networkErrorView = nil
                }
                    
                else {
                    
                    print("fail")
                    self.networkErrorView.image = UIImage(named: "NetworkError")
                }
                self.movieTableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movies = movies {
            
            return movies.count
        }
        
        else {
            
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseURL = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let fullImageURL = NSURL(string: baseURL + posterPath)
        cell.titleLabel.text! = title
        cell.overviewLabel.text! = overview
        cell.moviePosterView.setImageWithURL(fullImageURL!)
        let imageUrl = baseURL + posterPath
        let imageRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
        cell.moviePosterView!.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.moviePosterView!.alpha = 0.0
                    cell.moviePosterView!.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.moviePosterView!.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.moviePosterView!.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "movie" {
            
            let indexPath = movieTableView.indexPathForSelectedRow!
            let movie = movies![indexPath.row]
            let title = movie["title"] as! String
            let overview = movie["overview"] as! String
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let posterPath = movie["poster_path"] as! String
            specMovieTitle = title
            print("specMovieTitle is \(specMovieTitle)")
            specMovieOverview = overview
            print("specMovieOverview is \(specMovieOverview)")
            specMoviePosterURL = baseURL + posterPath
            print("specMoviePosterURL is \(specMoviePosterURL)")
            let VC = segue.destinationViewController as! MoviesDetailViewController
            VC.movietitle = specMovieTitle
            VC.movieoverview = specMovieOverview
            VC.movieposterurl = specMoviePosterURL
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}