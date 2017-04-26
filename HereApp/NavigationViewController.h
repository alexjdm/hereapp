//
//  NavigationViewController.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ViewController.h"

@interface NavigationViewController : ViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *MapButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PhotoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *UserAccountButton;

-(void) MostrarControlesNavegacion_default;


@end
