//
//  CameraController.h
//  HereApp
//
//  Created by Alex Diaz on 1/21/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ViewController.h"
#import "PrincipalController.h"
#import <MapKit/MapKit.h>

@interface CameraController : ViewController<CLLocationManagerDelegate>

@property PrincipalController * controladorPrincipal;

@property (weak, nonatomic) IBOutlet UITextField *mComment;
@property (weak, nonatomic) IBOutlet UIImageView *mImage;
@property (weak, nonatomic) IBOutlet UILabel *mPlace;
@property (weak, nonatomic) IBOutlet UILabel *mGPSLocation;
@property (weak, nonatomic) IBOutlet UIButton *mCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *mRetryButton;
@property (weak, nonatomic) IBOutlet UIButton *mAcceptButton;

@property CLLocationManager *locationManager;
@property NSMutableArray * ubicaciones;
@property CLLocation * best_location;

-(void) visualizacion: (bool) value;

@end
