//
//  ImageDownloadViewController.swift
//  NetworkingDemo
//
//  Created by Ben Scheirman on 11/9/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class ImageDownloadViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imageUrl = NSURL(string: "http://f.cl.ly/items/1E2L3I1F3C1p2s3x180C/Screenshot%202014-11-09%2011.00.37%20(1).png")!
    var task: NSURLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.progress = 0
    }

    @IBAction func downloadImageTapped(sender: AnyObject) {
        imageView.image = nil
        task?.cancel()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate:self, delegateQueue: NSOperationQueue.mainQueue())
        task = session.downloadTaskWithURL(imageUrl)
        
        task!.resume()
    }
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let data = NSData(contentsOfURL: location)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.image = image
            }
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if error != nil {
            println("Error: \(error)")
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
}
