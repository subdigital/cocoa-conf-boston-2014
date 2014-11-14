//
//  ActionRequestHandler.swift
//  CatifyExtension
//
//  Created by ben on 9/30/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        self.extensionContext = context
        
        if let item = context.inputItems.first as? NSExtensionItem {
            if let provider = item.attachments?.first as? NSItemProvider {
                let itemType = String(kUTTypePropertyList)
                if provider.hasItemConformingToTypeIdentifier(itemType) {
                    provider.loadItemForTypeIdentifier(itemType, options: nil) {
                        item, error in
                        let dictionary = item as NSDictionary
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as NSDictionary
                            self.itemLoadCompletedWithPreprocessingResults(results)
                        }
                    }
                } else {
                    self.doneWithResults(nil)
                }
            }
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(results: NSDictionary) {
        let host = results["host"] as String
        let path = results["path"] as String
        let newURL = "http://cat.\(host).meowbify.com\(path)"
        doneWithResults(["newURL": newURL])
    }
    
    func doneWithResults(results: NSDictionary?) {
        if let finalizeResults = results {
            var resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: finalizeResults]
            let itemType = kUTTypePropertyList as NSString
            var resultsProvider = NSItemProvider(item: resultsDictionary, typeIdentifier: itemType)
            var resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            extensionContext?.completeRequestReturningItems([resultsItem], completionHandler: nil)
        } else {
            extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
        }
        
        extensionContext = nil
    }

}
