//
//  AppDelegate.m
//  HereApp
//
//  Created by Alex Diaz on 1/6/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "AppDelegate.h"
#import "ControladorNotificaciones.h"

@implementation AppDelegate

@synthesize databaseName;
@synthesize databasePath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    self.databaseName = @"hereapp.db";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
    
    NSLog(@"Esta es la direccion de la base de datos:%@", self.databasePath);
    [self createAndCheckDatabase];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //iniciar método de actualización.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //Instanciamos Controlador Principal y enviamos el control a él.
    [Helpers logToDb:@"Iniciando" : @"didFinishLaunchingWithOptions"];
    _principalController = [[PrincipalController alloc] init];
    _principalController.ventanaPrincipal=self.window;
    
    //Funcion Principal
    [_principalController IniciarApp];
    
    //Al cambiar numero de versión, ejecuta el "recreateDatabase"
    //[DatabaseHelper recreateDatabase];
    [MTMigration applicationUpdateBlock:^{
        [DatabaseHelper recreateDatabase];
    }];
    
    // Register notifications types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    //[self generateLocalNotification]; // Para testear notificaciones
    
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey])
    {
        [Helpers logToDb:@"Iniciando desde SignicantLocationChange" : @"didFinishLaunchingWithOptions"];
    }
    
    return YES;
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) createAndCheckDatabase
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}


@end
