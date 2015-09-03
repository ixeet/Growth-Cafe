//
//  AppDelegate.m
//  Growth Cafe
//
//  Created by Ixeet Software Solutions Pvt Limited on 8/12/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UpdateViewController.h"
#import "CourseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AssignmentViewController.h"
#import "MoreViewController.h"
#import "NotificationViewController.h"
@interface AppDelegate ()
{
UIView *spinnerView;
UIActivityIndicatorView *activityIndicator;
UILabel *activityLabel;
}
@end

@implementation AppDelegate


@synthesize _engine;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Allocate Engine
    _engine=[[AppEngine alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]
                                                   bounds]];
    
    [[UITabBar appearance] setTintColor:[UIColor grayColor]];
    
    // Add this code to change StateNormal text Color,
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithRed:186.0/255 green:0.0/255 blue:50.0/255 alpha:1 ]}
                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor grayColor]}
                                           forState:UIControlStateSelected];
    
    UIViewController *viewController1 = [[UpdateViewController  alloc]
                                         initWithNibName:@"UpdateViewController" bundle:nil];
    UIViewController *viewController2 = [[AssignmentViewController alloc]
                                         initWithNibName:@"AssignmentViewController" bundle:nil];
    UIViewController *viewController3 = [[CourseViewController  alloc]
                                         initWithNibName:@"CourseViewController" bundle:nil];
    UIViewController *viewController4 = [[NotificationViewController alloc]
                                         initWithNibName:@"NotificationViewController" bundle:nil];
    UIViewController *viewController5 = [[MoreViewController alloc]
                                         initWithNibName:@"MoreViewController" bundle:nil];
    //UIViewController *uvButton1 = [self.tabBarController.viewControllers objectAtIndex:0];
    viewController1.tabBarItem.title = @"Updates" ;
    viewController1.tabBarItem.image =[ [UIImage imageNamed:@"icn_updates-defaultn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //[viewController1.tabBarItem setEnabled:NO];
    viewController1.tabBarItem.selectedImage = [ [UIImage imageNamed:@"icn_updates-selectedn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    // UIViewController *uvButton2 = [self.tabBarController.viewControllers objectAtIndex:1];
    viewController2.tabBarItem.title = @"Assignment" ;
   // [viewController2.tabBarItem setEnabled:NO];
    viewController2.tabBarItem.image = [[UIImage imageNamed:@"icn_assignment-defaultn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController2.tabBarItem.selectedImage = [ [UIImage imageNamed:@"icn_assignment-selectedn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //UIViewController *uvButton3 = [self.tabBarController.viewControllers objectAtIndex:2];
    viewController3.tabBarItem.title = @"Courses" ;
    viewController3.tabBarItem.image = [[UIImage imageNamed:@"icn_course-defaultn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController3.tabBarItem.selectedImage = [ [UIImage imageNamed:@"icn_course-selectedn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // UIViewController *uvButton4 = [self.tabBarController.viewControllers objectAtIndex:3];
    viewController4.tabBarItem.title = @"Notifications" ;
    [viewController4.tabBarItem setEnabled:NO];
    viewController4.tabBarItem.image = [[UIImage imageNamed:@"icn_notification-defaultn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController4.tabBarItem.selectedImage = [[UIImage imageNamed:@"icn_notification-selectedn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // UIViewController *uvButton5 = [self.tabBarController.viewControllers objectAtIndex:4];
    viewController5.tabBarItem.title = @"More" ;
    [viewController5.tabBarItem setEnabled:NO];
    viewController5.tabBarItem.image = [[UIImage imageNamed:@"icn_more-defaultn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController5.tabBarItem.selectedImage = [[UIImage imageNamed:@"icn_more-selectedn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    [navController1.navigationBar setHidden:YES];
    
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    [navController2.navigationBar setHidden:YES];
    UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    [navController3.navigationBar setHidden:YES];
    UINavigationController *navController4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    [navController4.navigationBar setHidden:YES];
    UINavigationController *navController5 = [[UINavigationController alloc] initWithRootViewController:viewController5];
    [navController5.navigationBar setHidden:YES];
    self.tabBarController = [[UITabBarController alloc] init];
    [[self.tabBarController tabBar]setBackgroundColor:[UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:0.5 ]];
    
    
    self.tabBarController.viewControllers = @[  navController1,
                                                navController2,navController3,navController4,navController5];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [FBLoginView class];
    [FBProfilePictureView class];
    [AppSingleton sharedInstance].isKeepMeloggedIn  = [[NSUserDefaults standardUserDefaults] boolForKey:@"keep_loggedIn"];
    

    
    return YES;
}
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    //    return [[FBSDKApplicationDelegate sharedInstance] application:application
    //                                                          openURL:url
    //                                                sourceApplication:sourceApplication
    //                                                       annotation:annotation];
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}

- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
    self.allowRotation = YES;
}
- (void) moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
    self.allowRotation = NO;
    
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ixeet.sLMS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Growth_Cafe" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Growth_Cafe.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - show & hide busy Indicator

// This method simply shows a loading spinner on a blank canvas,
- (void)showSpinnerWithMessage:(NSString*)msg{
    
    // Add spinner
    if (spinnerView == nil) {
        spinnerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        spinnerView.backgroundColor = [UIColor clearColor];
        
        
        UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingBG.png"]];
        img.frame=CGRectMake((spinnerView.frame.size.width - 164)/2,(spinnerView.frame.size.height - 114)/2, 164, 114);
        
        [spinnerView addSubview:img];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((spinnerView.frame.size.width - 30)/2, img.frame.origin.y + 25 , 30, 30)];
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [spinnerView addSubview:activityIndicator];
        
        activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, activityIndicator.frame.origin.y + 40, spinnerView.frame.size.width - 20, 50)];
        activityLabel.textAlignment = NSTextAlignmentCenter;
        activityLabel.textColor = [UIColor whiteColor];
        activityLabel.numberOfLines = 0;
        activityLabel.backgroundColor = [UIColor clearColor];
        [spinnerView addSubview:activityLabel];
    }
    
    activityLabel.text = msg;
    if (![spinnerView superview]) {
        [self.window addSubview:spinnerView];
    }
    
    [activityIndicator startAnimating];
    
}

- (void)hideSpinner {
    
    [spinnerView removeFromSuperview];
    [activityIndicator stopAnimating];
    
}


@end
