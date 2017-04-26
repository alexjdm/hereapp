//
//  ControladorMapa.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ViewController.h"
#import "PrincipalController.h"
#import <MapKit/MapKit.h>
#import "CalloutMapAnnotation.h"
#import "CalloutMapAnnotationView.h"
#import "BasicMapAnnotation.h"

@interface ControladorMapa : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{

}

@property PrincipalController * controladorPrincipal;

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;

@property NSMutableArray * arrayUbicacionesDeFotos;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) BasicMapAnnotation *customAnnotation;
@property (nonatomic, retain) BasicMapAnnotation *normalAnnotation;
@property bool a;
@property bool first;
@property bool hasFirstLocation;
@property CLLocationCoordinate2D *firstLocation;

@end
