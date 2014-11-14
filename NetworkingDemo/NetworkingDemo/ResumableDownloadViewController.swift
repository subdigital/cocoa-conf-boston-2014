//
//  ResumableDownloadViewController.swift
//  NetworkingDemo
//
//  Created by Ben Scheirman on 11/9/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class ResumableDownloadViewController: UIViewController, NSURLSessionDownloadDelegate {
    
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: self,
            delegateQueue: NSOperationQueue.mainQueue())
    }()
    
    var downloadTask: NSURLSessionDownloadTask?
    var resumeData: NSData?
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.progress = 0
    }

    @IBAction func downloadFileTapped(sender: AnyObject) {
        var url = NSURL(string: "https://db.tt/UNueggDo")!
        
        self.progressView.tintColor = self.view.tintColor
        
        if resumeData == nil {
            downloadTask = self.session.downloadTaskWithURL(url)
        } else {
            downloadTask = self.session.downloadTaskWithResumeData(self.resumeData!)
        }
        downloadTask?.resume()
        
    }
    
    @IBAction func pauseTapped(sender: AnyObject) {
        self.progressView.tintColor = UIColor.grayColor()
        downloadTask?.cancelByProducingResumeData {
            data in self.resumeData = data
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        self.progressView.tintColor = UIColor.greenColor()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
}
