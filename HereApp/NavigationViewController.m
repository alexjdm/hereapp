//
//  NavigationViewController.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) MostrarControlesNavegacion_default {
    
    /*UINavigationController *mNavigationController=(UINavigationController *)_principalController.navigationController;
    
    mNavigationController.navigationBar.barTintColor = [Helpers colorWithHexString:@"002f43"];
    mNavigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    mNavigationController.navigationBar.translucent = NO;
    
    mNavigationController.navigationBar.topItem.title=@"GeoVictoria";
    mNavigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    UIImage *menuImage;
    menuImage = [UIImage imageNamed:@"menu2"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(showNavigationDrawer) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:menuImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0 ,0,40,40);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    mNavigationController.navigationBar.topItem.leftBarButtonItem=barButton;
    
    
    [self.principalController.drawerController setCenterViewController:mNavigationController withCloseAnimation:YES completion:nil];
    [self.principalController.ControladorNotificaciones updateBadges];*/
    
}


@end
