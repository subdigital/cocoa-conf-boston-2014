//
//  ITunesViewController.swift
//  NetworkingDemo
//
//  Created by Ben Scheirman on 11/11/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class ITunesViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults: [NSDictionary]?
    var sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.sessionConfig)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchForTerm(term: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let encodedTerm = term.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: "https://itunes.apple.com/search?term=\(encodedTerm)&media=tvShow")!
        let dataTask = session.dataTaskWithURL(url) {
            (data, response, error) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if error == nil {
                
                let http = response as NSHTTPURLResponse
                if http.statusCode == 200 {
                    self.processResults(data)
                } else {
                    println("Got an HTTP \(http.statusCode)")
                }
                
            } else {
                println("ERROR: \(error)")
            }
        }
        dataTask.resume()
    }
    
    func processResults(data: NSData) {
        var error: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error) as? NSDictionary {
            if let results = json["results"] as? [NSDictionary] {
                searchResults = results
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            } else {
                println("Results dictionary couldn't be parsed")
            }
        } else {
            println("Error parsing JSON: \(error)")
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults != nil {
            return searchResults!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 94
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        }
        
        let result = searchResults?[indexPath.row]
        println("result: \(result)")
        
        cell?.textLabel.text = result?["trackName"] as NSString
        cell?.detailTextLabel?.text = result?["collectionName"] as NSString
        
        let placeholder = UIImage(named: "tv-128.png")
        if let urlString = result?["artworkUrl100"] as? NSString {
            if let artworkURL = NSURL(string: urlString) {
                cell?.imageView.loadImageFromURL(artworkURL, placeholder: placeholder)
            }
        }
        return cell!
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search for: '\(searchBar.text)'")
        searchForTerm(searchBar.text)
        searchBar.resignFirstResponder()
    }
}
