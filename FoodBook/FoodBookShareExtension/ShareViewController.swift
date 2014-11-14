//
//  ShareViewController.swift
//  FoodBookShareExtension
//
//  Created by ben on 10/3/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    var image: UIImage?
    
    override func viewDidLoad() {
        var itemProvider: NSItemProvider?
        if let items = extensionContext?.inputItems {
            if let item = items.first as? NSExtensionItem {
                if let attachment = item.attachments?.first as? NSItemProvider {
                    itemProvider = attachment
                }
            }
        }
        

        let imageType = kUTTypeImage as NSString
        if itemProvider?.hasItemConformingToTypeIdentifier(imageType) == true {
            itemProvider?.loadItemForTypeIdentifier(imageType, options: nil, completionHandler: {
                (item, error) in
                if error == nil {
                    
                    let url = item as NSURL
                    let imageData = NSData(contentsOfURL: url)
                    self.image = UIImage(data: imageData)
                } else {
                    println("ERROR: \(error)")
                }
            })
        }
    }
    
    override func isContentValid() -> Bool {
        return image != nil
    }

    override func didSelectPost() {
        println("posting image \(image?.size)")
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return NSArray()
    }

}
