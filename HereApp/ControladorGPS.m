//
//  ControladorGPS.m
//  HereApp
//
//  Created by Alex Diaz on 2/6/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ControladorGPS.h"
#import "Ubicacion_DAO.h"
#import "Ubicacion_DTO.h"
#import "Helpers.h"
#import "User_Setup_DAO.h"
#import "User_Setup_DTO.h"
#import "ControladorNotificaciones.h"

@implementation ControladorGPS:NSObject



- (void)iniciarEscuchaGPS{
    
    NSLog(@"Inicia Busqueda GPS...");
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    else{
        
    }
    
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter=40;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.activityType = CLActivityTypeFitness;
    //self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    //no activar, los cambios significativos son muy chantas pa dibujar ruta.
    //sin embargo "levanta app cuando esta muerta"
    [self.locationManager startMonitoringSignificantLocationChanges];
    
    _firstTime = true;
    _contador = 0;
}



-(void) detieneEscuchaGPS{
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    //BOOL isInBackground = NO;
    NSLog(@"!!Detengo escucha GPS.!!");
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
   
    CLLocation * bestLocation;
    bool primero = true;
    for (CLLocation * loc in locations) {
        
//        NSLog(@"!!UBICACION!!");
//        NSLog(@"latitud: %f",loc.coordinate.latitude) ;
//        NSLog(@"longitud: %f",loc.coordinate.longitude);
//        NSLog(@"accuracy: %f",loc.horizontalAccuracy);
//        //loc.timestamp;
//        NSLog(@" ");
//        NSLog(@" ");

        if(primero)
        {
            bestLocation = loc;
            primero = false;
        }
        else
        {
            if (loc.horizontalAccuracy < bestLocation.horizontalAccuracy && loc.horizontalAccuracy>0)
                bestLocation = loc;
        }
    }
    
    if(_firstTime)
    {
        _lastLocation = bestLocation;
        _firstTime = false;
    }
    else {
        
        //Filtro de 50 m a la redonda
        if(_lastLocation != nil)
        {
            CLLocationDistance meters = [_lastLocation distanceFromLocation:bestLocation];
            NSLog(@"C GPS: Me movi %f metros.", meters);
            if(meters > 25)
            {
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"hayUbicacion" object:nil];
                
                // Esperamos que lleguen 5 ubicaciones sobre 25 metros para evitar en algo GPS con mala precision
                _contador++;
                if(_contador>5)
                {
                    _contador = 0;
                    // Revisar si hay al menos una imagen nueva en el lugar
                    NSMutableArray* ubicaciones = [Ubicacion_DAO getUbicaciones];
                    CLLocation *location;
                    bool hayImagenes = false;
                    for(Ubicacion_DTO* ubi in ubicaciones)
                    {
                        location = [[CLLocation alloc] initWithLatitude:[ubi.lat floatValue] longitude:[ubi.lon floatValue]];
                        meters = [bestLocation distanceFromLocation:location];
                        if(meters < 50)
                        {
                            hayImagenes = true;
                            break;
                        }
                        
                    }
                    
                    _lastLocation = bestLocation;
                    
                    if(hayImagenes)
                    {
                        NSDate *ahora = [NSDate date];
                        NSTimeInterval oneMinutes = 60*1;
                        NSDate *ahoraTwoMinutes = [ahora dateByAddingTimeInterval:oneMinutes];
                        NSTimeInterval interval = [ahoraTwoMinutes timeIntervalSinceNow];
                        
                        [ControladorNotificaciones crearNotificacionNuevaImagen: &interval : ahora];
                    }
                }
                
            }
        }

    }
    
    
    
    /*
    Ubicacion_DTO *u_dto = [[Ubicacion_DTO alloc] init];
    [u_dto setLon:[NSString stringWithFormat:@"%f", bestLocation.coordinate.longitude]];
    [u_dto setLat:[NSString stringWithFormat:@"%f", bestLocation.coordinate.latitude]];
    [u_dto setGpserror:[NSString stringWithFormat:@"%f", bestLocation.horizontalAccuracy]];
    [u_dto setFecha:[Helpers getCurrentTime]];
    if (bestLocation.horizontalAccuracy < 500)
        [Ubicacion_DAO insertUbicacion:u_dto];
     */
    
}




@end

