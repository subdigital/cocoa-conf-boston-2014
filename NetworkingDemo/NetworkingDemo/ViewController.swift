//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Ben Scheirman on 11/8/14.
//  Copyright (c) 2014 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outputTextView: UITextView!
    
    lazy var sessionConfig: NSURLSessionConfiguration = {
        NSURLSessionConfiguration.defaultSessionConfiguration()
    }()
    
    lazy var session: NSURLSession = {
        NSURLSession(configuration: self.sessionConfig)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://httpbin.org/get")!
        get(url)
        
        let url404 = NSURL(string: "http://httpbin.org/status/404")!
        get(url404)
        
        let urlgz = NSURL(string: "http://httpbin.org/gzip")!
        get(urlgz)
        
        post(NSURL(string: "http://httpbin.org/post")!, params:
            [
                "foo": "bar",
                "baz": "quux"
            ])
     }
    
    func get(url: NSURL) {
        var req = NSURLRequest(URL: url)
        request(req)
    }
    
    func post(url: NSURL, params: [String: String]) {
        var req = NSMutableURLRequest(URL: url)
        req.HTTPMethod = "post"
        req.allHTTPHeaderFields = [ "Content-Type": "application/json" ]
        req.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        request(req)
    }
    
    func request(request: NSURLRequest) {
        appendOutput("Sending request for \(request.URL)")
        var task = self.session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if error == nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    self.appendOutput("Received HTTP \(httpResponse.statusCode)")
                    let body = NSString(data: data, encoding: NSUTF8StringEncoding)
                    self.appendOutput("Response from \(request.URL): \(body)")
                } else {
                    self.appendOutput("Don't know how to handle response: \(response)")
                }
            } else {
                self.appendOutput("Error: \(error)")
            }
        }
        task.resume()
    }

    func appendOutput(string: String) {
        println(string)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            var text: String = self.outputTextView.text
            text = text.stringByAppendingString(string)
            text = text.stringByAppendingString("\n\n")
            self.outputTextView.text = text
        }
    }
}

