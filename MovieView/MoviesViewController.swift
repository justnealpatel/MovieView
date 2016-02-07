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

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var movieFlowLayout: UICollectionViewFlowLayout!
    
    var movies: [NSDictionary]?
    var endpoint = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColor(red: 66.0/255.0, green: 133.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        movieFlowLayout.minimumInteritemSpacing = 0
        movieFlowLayout.minimumLineSpacing = 0
//        if Reachability.isConnectedToNetwork() == true {
//            
//            print("success")
//            networkErrorImageView = nil
//        }
//        
//        else {
//            
//            print("fail")
//            networkErrorImageView.image = UIImage(named: "Network Error")
//        }

        loadDataFromNetwork()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        moviesCollectionView.insertSubview(refreshControl, atIndex: 0)
        // NETWORK REQUEST
        
        if endpoint == "now_playing" {
            
            self.title = "Now Playing"
        }
        
        else {
            
            self.title = "Top Rated"
        }
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        print("before task")
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    print("after 1st check")
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.moviesCollectionView.reloadData()
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
        SVProgressHUD.showWithStatus("Loading Movies")
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
                            self.moviesCollectionView.reloadData()
                    }
                }
                
                // Reload the tableView now that there is new data
//                if Reachability.isConnectedToNetwork() == true {
//                    
//                    print("success")
//                    self.networkErrorView = nil
//                }
//                    
//                else {
//                    
//                    print("fail")
//                    self.networkErrorView.image = UIImage(named: "NetworkError")
//                }
                self.moviesCollectionView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 159, height: 215) // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = movies {
            
            return movies.count
        }
            
        else {
            
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MovieCollectionViewCell
        let movie = movies![indexPath.row]
        let smallImageUrl = "https://image.tmdb.org/t/p/w45"
        let largeImageUrl = "https://image.tmdb.org/t/p/w500"
        var imageUrl = NSURL?()
        if let posterPath = movie["poster_path"] as? String {
            
            let baseURL = smallImageUrl
            let fullImageURL = NSURL(string: baseURL + posterPath)
            imageUrl = fullImageURL
            cell.moviePoster.setImageWithURL(fullImageURL!)
        }
            
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.moviePoster.image = nil
        }
        
        let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrl)!)
        let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageUrl)!)
        
        cell.moviePoster.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                cell.moviePoster.alpha = 0.0
                cell.moviePoster.image = smallImage;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    cell.moviePoster.alpha = 1.0
                    
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        cell.moviePoster.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                cell.moviePoster.image = largeImage;
                                
                            },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                })
            },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        
        if let posterPath = movie["poster_path"] as? String {
            
            let baseURL = "http://image.tmdb.org/t/p/w500"
            let fullImageURL = NSURL(string: baseURL + posterPath)
            imageUrl = fullImageURL
            cell.moviePoster.setImageWithURL(fullImageURL!)
        }
            
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.moviePoster.image = nil
        }
        
        cell.moviePoster.userInteractionEnabled = true
        
        let imageRequest = NSURLRequest(URL: imageUrl!)
        cell.moviePoster.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.moviePoster.alpha = 0.0
                    cell.moviePoster.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.moviePoster.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.moviePoster.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let cell = sender as! MovieCollectionViewCell
        let indexPath = moviesCollectionView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let VC = segue.destinationViewController as! MoviesDetailViewController
        VC.movie = movie
        print("segue called")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}