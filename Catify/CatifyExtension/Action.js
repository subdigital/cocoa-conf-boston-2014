//
//  Action.js
//  CatifyExtension
//
//  Created by ben on 9/30/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        arguments.completionFunction({
            "host": window.location.host,
            "path": window.location.pathname
        });
    },
    
    finalize: function(arguments) {
        window.location = arguments["newURL"];
    }
    
};
    
var ExtensionPreprocessingJS = new Action
