#import "AppDelegate+CustomDeeplinksPlugin.h"
#import "CustomDeeplinksPlugin.h"

@implementation AppDelegate (CustomDeeplinksPlugin)

- (BOOL)application:(UIApplication *)application 
continueUserActivity:(NSUserActivity *)userActivity 
restorationHandler:(void (^)(NSArray *))restorationHandler {

    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb] || userActivity.webpageURL == nil) {
        return NO;
    }

    NSString *urlString = userActivity.webpageURL.absoluteString;
    [CustomDeeplinksPlugin setPendingURL:urlString];

    if (self.viewController != nil) {
        // O cast (CustomDeeplinksPlugin *) resolve erros de compilação
        CustomDeeplinksPlugin *plugin = (CustomDeeplinksPlugin *)[self.viewController getCommandInstance:@"CustomDeeplinks"];
        if (plugin != nil) {
            [plugin handleUserActivity:userActivity];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    [CustomDeeplinksPlugin setPendingURL:url.absoluteString];

    if (self.viewController != nil) {
        CustomDeeplinksPlugin *plugin = (CustomDeeplinksPlugin *)[self.viewController getCommandInstance:@"CustomDeeplinks"];
        if (plugin != nil) {
            [plugin handleUrl:url.absoluteString];
        }
    }
    return YES;
}

@end
