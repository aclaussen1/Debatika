//
//  AppDelegate.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/5/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <iAd/iAd.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     */
    /*
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        NSLog(@"has never lauanched once");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    */
    
    //??
    [Parse enableLocalDatastore];
    
    
    [Parse setApplicationId:@"bAfPwBCdDTN5HMOIaDulq2kYYMMxV2q8r1e5j88f"
                  clientKey:@"C4Xriae4yxLgN4UZWiA7Ltyirgb9heA3boOiE7Yg"];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    [UIViewController prepareInterstitialAds];
    
  
    //for parse push notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}


//If the registerForRemoteNotifications is successful, the callback method -application:didRegisterForRemoteNotificationsWithDeviceToken: in the application delegate will be executed. We will need to implement this method and use it to inform Parse about this new device.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    
    /*
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    [currentInstallation addUniqueObject:@"Giants" forKey:@"channels"];
    [currentInstallation saveInBackground];

    PFPush *push = [[PFPush alloc] init];
    [push setChannel:@"Giants"];
    [push setMessage:@"The Giants just scored!"];
    [push sendPushInBackground];
     */
}

//When a push notification is received while the application is not in the foreground, it is displayed in the iOS Notification Center. However, if the notification is received while the app is active, it is up to the app to handle it. To do so, we can implement the [application:didReceiveRemoteNotification] method in the app delegate. In our case, we will simply ask Parse to handle it for us. Parse will create a modal alert and display the push notification's content.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    
}




- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
