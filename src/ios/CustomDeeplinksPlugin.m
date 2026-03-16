#import "CustomDeeplinksPlugin.h"

@implementation CustomDeeplinksPlugin

static NSString *pendingURL = nil;

+ (void)setPendingURL:(NSString *)url {
    pendingURL = [url copy];
    NSLog(@"[CustomDeeplinks] Static pendingURL updated: %@", pendingURL);
}

- (void)pluginInitialize {
    NSLog(@"[CustomDeeplinks] Plugin initialized. Current pending: %@", pendingURL);
}

- (void)handleUrl:(NSString *)urlString {
    if (urlString == nil || [urlString isEqualToString:@""]) return;

    [CustomDeeplinksPlugin setPendingURL:urlString];

    if (self.webViewEngine && self.webViewEngine.engineWebView) {
        NSString *js = [NSString stringWithFormat:
            @"window.dispatchEvent(new CustomEvent('deeplinks', { detail: { url: '%@' } }));", 
            urlString];
            
        [self.commandDelegate evalJs:js];
    }
}

- (BOOL)handleUserActivity:(NSUserActivity *)userActivity {
    if (userActivity.webpageURL == nil) return NO;
    [self handleUrl:userActivity.webpageURL.absoluteString];
    return YES;
}

- (void)getPendingDeeplink:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *result;
    if (pendingURL != nil && ![pendingURL isEqualToString:@""]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:pendingURL];
        pendingURL = nil; // Consumed
    } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:nil];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end    NSString *urlString = userActivity.webpageURL.absoluteString;
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
