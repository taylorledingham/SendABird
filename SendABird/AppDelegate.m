//
//  AppDelegate.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "InboxViewController.h"
#import "InboxDetailViewController.h"
//#import <ParseCrashReporting/ParseCrashReporting.h>


@interface AppDelegate ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation AppDelegate {
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
   // [ParseCrashReporting enable];
    
    [Parse setApplicationId:@"DDXGlvgKOTm6LVrkQseHgKTpnRJLUOex2ZcOB4gj"
                  clientKey:@"6uqg2oun5sTctp1y1Igm1Q8q0hRDPfK2zk8rME5X"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [FBLoginView class];
    [PFFacebookUtils initializeFacebook];
    
    [FBAppEvents activateApp];
    
    PFUser *user = [PFUser currentUser];

    if (user)
    {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];

        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.173f green:0.788f blue:0.910f alpha:1.00f]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"System" size:15], NSFontAttributeName, nil]];
        
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
      
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.173f green:0.788f blue:0.910f alpha:1.00f]];
    }
    else
    {
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.173f green:0.788f blue:0.910f alpha:1.00f]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"System" size:15], NSFontAttributeName, nil]];
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.173f green:0.788f blue:0.910f alpha:1.00f]];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
        
        self.window.rootViewController = navigation;
    }
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationCategory *messageCategory = [self createNotificationCategory];
        NSSet *categorySet = [NSSet setWithObject:messageCategory];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:categorySet];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notificationPayload) {
        // figure out what's in the notificationPayload dictionary
    }
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    NSString *urlString = userInfo[@"aps"][@"sound"];
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:urlString withExtension:@"caf"];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:nil];
    self.audioPlayer.numberOfLoops = 1;
    [self.audioPlayer prepareToPlay] ;
    [self.audioPlayer play];
    NSLog(@"%@", userInfo);
    
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {

    if ([identifier isEqualToString: @"MESSAGE_CATEGORY"]) {
        [self handleViewMessageActionWithNotification:userInfo];
    }
    
    completionHandler();
}

-(void)handleViewMessageActionWithNotification:(NSDictionary *)userInfo {
    NSString *messageID = userInfo[@"messageID"];
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"objectId" equalTo:messageID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            PFObject *message = objects.firstObject;
            //UINavigationController *navController = [[UIStoryboard storyboardWithName:@"IndexStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            //self.window.rootViewController = navController;//[[UIStoryboard storyboardWithName:@"IndexStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            UINavigationController *navController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            self.window.rootViewController = navController;
            
            InboxViewController *inboxVC = (InboxViewController *)navController.childViewControllers.firstObject;
            [inboxVC performSegueWithIdentifier:@"messageDetail" sender:message];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

-(UIMutableUserNotificationCategory *)createNotificationCategory {
    UIMutableUserNotificationAction *dismissAction =
    [[UIMutableUserNotificationAction alloc] init];
    dismissAction.identifier = @"DISMISS_IDENTIFIER";
    dismissAction.title = @"Dismiss";
    dismissAction.activationMode = UIUserNotificationActivationModeBackground;
    dismissAction.destructive = YES;
    dismissAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *viewAction =
    [[UIMutableUserNotificationAction alloc] init];
    viewAction.identifier = @"VIEW_IDENTIFIER";
    viewAction.title = @"View";
    viewAction.activationMode = UIUserNotificationActivationModeBackground;
    viewAction.destructive = NO;
    viewAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *newMessageCategory =
    [[UIMutableUserNotificationCategory alloc] init];
    
    // Identifier to include in your push payload and local notification
    newMessageCategory.identifier = @"MESSAGE_CATEGORY";
    
    // Add the actions to the category and set the action context
    [newMessageCategory setActions:@[dismissAction, viewAction]
                        forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to present in a minimal context
    [newMessageCategory setActions:@[dismissAction, viewAction]
                        forContext:UIUserNotificationActionContextMinimal];
    
    return newMessageCategory;
}


@end