#import "CustomDeeplinksPlugin.h"

@implementation CustomDeeplinksPlugin

static NSString *pendingURL = nil;

+ (void)setPendingURL:(NSString *)url {
    pendingURL = [url copy];
    NSLog(@"[CustomDeeplinks] Static pendingURL updated to: %@", pendingURL);
}

- (void)pluginInitialize {
    NSLog(@"[CustomDeeplinks] Plugin initialized. Pending URL: %@", pendingURL);
}

// Helper method to process the URL and notify JS if possible
- (void)handleUrl:(NSString *)urlString {
    if (urlString == nil || [urlString isEqualToString:@""]) return;

    [CustomDeeplinksPlugin setPendingURL:urlString];

    // If the WebView is ready, we dispatch the event for Warm Starts
    if (self.webViewEngine && self.webViewEngine.engineWebView) {
        NSString *js = [NSString stringWithFormat:
            @"window.dispatchEvent(new CustomEvent('deeplinks', { detail: { url: '%@' } }));", 
            urlString];
            
        [self.commandDelegate evalJs:js];
        NSLog(@"[CustomDeeplinks] Event dispatched to JS: %@", urlString);
    }
}

// Called by AppDelegate for Universal Links
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity {
    if (userActivity.webpageURL == nil) return NO;
    
    NSString *urlString = userActivity.webpageURL.absoluteString;
    NSLog(@"[CustomDeeplinks] Handling Universal Link: %@", urlString);
    
    [self handleUrl:urlString];
    return YES;
}

// Cordova Command: Called by JS on startup to catch Cold Starts
- (void)getPendingDeeplink:(CDVInvokedUrlCommand *)command {
    NSLog(@"[CustomDeeplinks] JS polling for pending URL. Current: %@", pendingURL);

    CDVPluginResult *result;
    if (pendingURL != nil && ![pendingURL isEqualToString:@""]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pendingURL];
        
        // Clear after consumption to avoid processing the same link twice
        pendingURL = nil; 
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
