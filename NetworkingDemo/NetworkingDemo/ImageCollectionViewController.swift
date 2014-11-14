//
//  ImageCollectionViewController.swift
//  NetworkingDemo
//
//  Created by Ben Scheirman on 11/9/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

let reuseIdentifier = "cell"

class ImageCollectionViewController: UICollectionViewController {
    
    var episodes: NSArray = []
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(80, 70)
        self.collectionView.collectionViewLayout = layout
        
        fetchEpisodes {
            (episodes) in
            self.episodes = episodes
            self.collectionView.reloadData()
        }
    }
    
    func fetchEpisodes(completion: NSArray -> ()) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let episodesTask = session.dataTaskWithURL(NSURL(string: "https://www.nsscreencast.com/api/episodes.json")!) {
            (data, response, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
         
            if error == nil {
                let httpResponse = response as NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    
                    if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil) {
                        if let episodes = json as? NSArray {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(episodes)
                            }
                        }
                    }
                    
                } else {
                    println("Got an HTTP \(httpResponse.statusCode)")
                }
            } else {
                println("Error: \(error)")
            }
        }
        episodesTask.resume()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.episodes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ImageCollectionViewCell
        let episode = self.episodes[indexPath.row] as NSDictionary
        
        let imageUrlString = episode["episode"]?["thumbnail_url"] as NSString
        let imageUrl = NSURL(string: imageUrlString)!
        cell.imageView.loadImageFromURL(imageUrl)
    
        return cell
    }
}
