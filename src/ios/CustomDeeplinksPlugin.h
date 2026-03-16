#import <Cordova/CDVPlugin.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomDeeplinksPlugin : CDVPlugin

+ (void)setPendingURL:(NSString *)url;
- (void)handleUrl:(NSString *)urlString;
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity;
- (void)getPendingDeeplink:(CDVInvokedUrlCommand *)command;

@end
