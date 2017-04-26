//
//  AppDelegate.h
//  HereApp
//
//  Created by Alex Diaz on 1/6/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#import <UIKit/UIKit.h>
#import "LoginController.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "BackgroundWorker_Business.h"

#import "User_Setup_DAO.h"
#import "DatabaseHelper.h"
#import "Location_Business.h"
#import "ClienteHTTP.h"
#import "Helpers.h"
#import "Consts.h"
#import <CoreMotion/CoreMotion.h>
#import "MTMigration.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginController *viewController;
@property (nonatomic,strong) NSString *databaseName;
@property (nonatomic,strong) NSString *databasePath;
@property PrincipalController *principalController;

@property UIBackgroundTaskIdentifier backgroundUpdateTask;

-(void) createAndCheckDatabase;


@end

