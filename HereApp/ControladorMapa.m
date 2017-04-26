//
//  ControladorMapa.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ControladorMapa.h"
#import "Ubicacion_DTO.h"
#import "Ubicacion_DAO.h"
#import "PVAttractionAnnotation.h"
#import "PVAttractionAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "CalloutMapAnnotationView.h"
#import "BasicMapAnnotation.h"
#import "PrincipalController.h"

@interface ControladorMapa () <CLLocationManagerDelegate>

@end

@implementation ControladorMapa

- (void) viewWillAppear:(BOOL)animated{
    
    [self cargarUbicacionesFotos];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hayUbicacion" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hayUbicacion:)
                                                 name:@"hayUbicacion" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView clearsContextBeforeDrawing];
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    
    _first = true;
    _hasFirstLocation = false;

    [self inicializarGps];
    
    if ([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
    }

}

-(void)hayUbicacion:(NSNotification *) notification {
    
    [self cargarUbicacionesFotos];
    
}


-(void) inicializarGps{
    
    if ([CLLocationManager locationServicesEnabled]){
        
        if (nil == _locationManager)
            
            _locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=1;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        self.locationManager.activityType = CLActivityTypeFitness;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        
    }
    else{
        // [self locationManagerUnavailable];
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if([locations count] > 0)
    {
        CLLocation * bestLocation;
        bool primero = true;
        for (CLLocation * l in locations) {
            
            if(primero)
            {
                bestLocation = l;
                primero = false;
            }
            else
            {
                if (l.horizontalAccuracy < bestLocation.horizontalAccuracy && l.horizontalAccuracy>0)
                    bestLocation = l;
            }

            if(_first)
                _first = false;
        }
        
        //set location and zoom level
        CLLocationCoordinate2D myCoordinate = {bestLocation.coordinate.latitude, bestLocation.coordinate.longitude};
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, 1000, 1000);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        
        if(!_hasFirstLocation)
        {
            _controladorPrincipal.ubicacionActual = bestLocation;
            _controladorPrincipal.ultimaUbicacionConMedios = bestLocation;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hayUbicacion" object:nil];
            _hasFirstLocation = true;
        }
        else
        {
            //Filtro de 50 m a la redonda
            if(_controladorPrincipal.ubicacionActual != nil)
            {
                CLLocationDistance meters = [_controladorPrincipal.ultimaUbicacionConMedios distanceFromLocation:bestLocation];
                NSLog(@"C MAP: me movi %f metros.", meters);
                if(meters > 25)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hayUbicacion" object:nil];
                
                _controladorPrincipal.ubicacionActual = bestLocation;
            }
        }
        
    }
}


-(void) cargarUbicacionesFotos{
    
    [_arrayUbicacionesDeFotos removeAllObjects];
    _arrayUbicacionesDeFotos =  [Ubicacion_DAO getUbicaciones];
    
    //Filtro de 50 m a la redonda
    if(_controladorPrincipal.ubicacionActual != nil)
    {
        CLLocationDistance meters;
        NSMutableArray * arrayFotos = [[NSMutableArray alloc] init];
        CLLocation *location;
        for(Ubicacion_DTO* ubi in _arrayUbicacionesDeFotos)
        {
            location = [[CLLocation alloc] initWithLatitude:[ubi.lat floatValue] longitude:[ubi.lon floatValue]];
            meters = [_controladorPrincipal.ubicacionActual distanceFromLocation:location];
            if(meters < 50)
                [arrayFotos addObject:ubi];
        }
        _arrayUbicacionesDeFotos = arrayFotos;
    }
    
    if([_arrayUbicacionesDeFotos count] > 0)
        _controladorPrincipal.ultimaUbicacionConMedios = _controladorPrincipal.ubicacionActual;
    
    [_mapView removeAnnotations:_mapView.annotations];
    PVAttractionAnnotation * annotation;
    for (Ubicacion_DTO * ubi in _arrayUbicacionesDeFotos) {
        
        annotation =  [[PVAttractionAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake([ubi.lat floatValue], [ubi.lon floatValue]);
        annotation.type = 0;
        annotation.title = @"Photo";
        annotation.nombre = @"Nombre";
        annotation.fecha = ubi.fecha_string;
        //int id_usuario = per_dto.id_usuario;
        //annotation.identificador = [NSString stringWithFormat:@"%ld",(long)id_usuario];
        
        [_mapView addAnnotation:annotation];
        
        [[_mapView viewForAnnotation:annotation] setHidden:NO];
        
    }
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[PVAttractionAnnotation class]])
    {
        // If no pin view already exists, create a new one.
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        customPinView.pinTintColor = [UIColor blackColor];
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        
        // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:@selector(goToGallery:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        // Add a custom image to the left side of the callout.
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapImage"]];
        customPinView.leftCalloutAccessoryView = myCustomImage;
        
        return customPinView;
    }
    
    
    /*
    if([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
        
        calloutMapAnnotationView = [[CalloutMapAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:@"CalloutAnnotation"];
        
        calloutMapAnnotationView.contentWidth = 38.0f;
        
        CalloutMapAnnotation * calloutAnnotation = (CalloutMapAnnotation *)annotation;
        calloutMapAnnotationView = [self getCalloutMapAnnotation:calloutAnnotation :calloutMapAnnotationView];
       
        calloutMapAnnotationView.parentAnnotationView = _selectedAnnotationView;
        calloutMapAnnotationView.mapView = _mapView;
        
        return calloutMapAnnotationView;
    }
    else {
        
        if([annotation isKindOfClass:[PVAttractionAnnotation class]])
        {
            PVAttractionAnnotationView *annotationVieww = [[PVAttractionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Attraction"];
            PVAttractionAnnotation * pva = ( PVAttractionAnnotation *)annotation;
            annotationVieww.canShowCallout = YES;
            
            if(pva.type == 0)
            {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapImage"]];
                [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 50, 50)];
                [annotationVieww addSubview:imageView];
            }
            
            annotationVieww.nombre = pva.nombre;
            annotationVieww.fecha = pva.fecha;
            annotationVieww.identificador = pva.identificador;
            annotationVieww.tipo = pva.type;
            annotationVieww.coordinate = pva.coordinate;
            //annotationVieww.canShowCallout = NO;
            annotationVieww.annotation = annotation;
            
            return annotationVieww;
        }
    }
    */
    
    return nil;
    
}

-(CalloutMapAnnotationView *) getCalloutMapAnnotation:(CalloutMapAnnotation *) calloutAnnotation :(CalloutMapAnnotationView *) calloutAnnotationView
{
    if(calloutAnnotation.type == 0)
    {
        
        calloutAnnotationView.contentHeight = 88.0f;
        UILabel * label_nombre = [[UILabel alloc] initWithFrame:CGRectMake(5, 8 ,200, 15)];
        label_nombre.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        
        UILabel * last_seen = [[UILabel alloc] initWithFrame:CGRectMake(5, 72 ,170, 15)];
        last_seen.font = [UIFont fontWithName:@"Helvetica" size:12];
        last_seen.text = [NSString stringWithFormat:@"%@ %@",[[NSBundle mainBundle] localizedStringForKey:@"lastSeen" value:@"" table:nil],calloutAnnotation.fecha];
        last_seen.textAlignment = NSTextAlignmentCenter;
        
        
        label_nombre.text = calloutAnnotation.nombre;
        
        UIButton *goGallery = [UIButton buttonWithType:UIButtonTypeCustom];
        [goGallery addTarget:self
                   action:@selector(goToGallery:)
         forControlEvents:UIControlEventTouchUpInside];
        [goGallery setTitle:@"Go" forState:UIControlStateNormal];
        goGallery.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
        
        [calloutAnnotationView.contentView addSubview:label_nombre];
        [calloutAnnotationView.contentView addSubview:last_seen];
        [calloutAnnotationView.contentView addSubview:goGallery];
    }
    
    return calloutAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if ([view isKindOfClass:[PVAttractionAnnotationView class]]){
        PVAttractionAnnotationView * annotationView = (PVAttractionAnnotationView *) view;
        
        if(self.calloutAnnotation!=nil)
            [self.mapView removeAnnotation: self.calloutAnnotation];
     
        self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:annotationView.coordinate.latitude
                                                                   andLongitude:annotationView.coordinate.longitude];
        
//        CLLocationCoordinate2D center;
//        center.latitude = self.calloutAnnotation.latitude;
//        center.longitude = self.calloutAnnotation.longitude;
//        [self.mapView setCenterCoordinate:annotationView.coordinate animated:YES];
        
        
        if([annotationView.nombre isKindOfClass:[NSNull class]])
            self.calloutAnnotation.nombre = @"";
        else
            self.calloutAnnotation.nombre = annotationView.nombre;
        
        self.calloutAnnotation.type = annotationView.tipo;
        
        if([annotationView.fecha isKindOfClass:[NSNull class]])
            self.calloutAnnotation.fecha = @"";
        else
            self.calloutAnnotation.fecha = annotationView.fecha;
        
        [self.mapView addAnnotation:self.calloutAnnotation];

        self.selectedAnnotationView = view;
    }

}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if (self.calloutAnnotation && view.annotation == self.customAnnotation) {
        [self.mapView removeAnnotation: self.calloutAnnotation];
        _a = false;
    }
}

-(void) goToGallery:(UIButton*)sender
{
    NSLog(@"you clicked on button %ld", (long)sender.tag);
    [_controladorPrincipal button3Tap:nil];
    //[_controladorPrincipal mostrarGallery];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    _controladorPrincipal.ubicacionActual = newLocation;
    
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}


@end
