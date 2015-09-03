//
//  AppDelegate.h
//  Growth Cafe
//
//  Created by Ixeet Software Solutions Pvt Limited on 8/12/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class AppEngine;
@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) AppEngine *_engine;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (assign, nonatomic) BOOL allowRotation;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - show & hide busy Indicator
- (void)showSpinnerWithMessage:(NSString*)msg;
- (void)hideSpinner;
@end

