//
//  Location_Business.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "Location_Business.h"
#import "Ubicacion_DTO.h"
#import "Ubicacion_DAO.h"
#import "ClienteHTTP.h"
#import "User_Setup_DAO.h"
#import "Helpers.h"

@interface Location_Business()
-(void)setLastKnownLocation:(CLLocation *)newLocation;
@end

@implementation Location_Business

+ (Location_Business *)sharedInstance
{
    static dispatch_once_t once;
    static Location_Business *sharedInstance;
    dispatch_once(&once, ^{
        
        
        sharedInstance = [[Location_Business alloc] init];
        sharedInstance.locationBuffer = [[NSMutableArray alloc] init];
        sharedInstance.busy = false;
    });
    
    return sharedInstance;
}

-(void)gotLocation:(CLLocationCoordinate2D) location withError:(CLLocationAccuracy) accuracy{
    
    
    
    self.lastKnownLocationLatitude=location.latitude;
    self.lastKnownLocationLongitude=location.longitude;
    
}

-(void) saveLocations:(CLLocation *) nl{
    
    
    int cantidad;
    cantidad = 10;
    if(nl.horizontalAccuracy<=65)
    {
        //NSDictionary * dictionaryAux = [[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithFormat:@"%lf",nl.coordinate.longitude],@"lon",[NSString stringWithFormat:@"%lf",nl.coordinate.latitude],@"lat",[NSString stringWithFormat:@"%lf",nl.horizontalAccuracy],@"error",nl.timestamp,@"fecha",nil];
        
        NSLog(@"se ha agregado ubicacion al array");
//        NSLog(@"ubicaciones en el buffer: %ld",(long)[[Activity_aux sharedInstance].ubicaciones count]);
//        [[Activity_aux sharedInstance].ubicaciones addObject:dictionaryAux];
    }
    
//    if([[Activity_aux sharedInstance].ubicaciones count]>=cantidad && [[User_Setup_DAO getUserSetup].trackeo_activado integerValue] == 1)
//    {
//        [self saveBuffer]; // guardamos las ubicaciones de tracking en el buffer temporal ( si superan las 10)
//        [[Activity_aux sharedInstance].ubicaciones removeAllObjects];
//        [_controladorPrincipal SincronizacionSincrona];
//        
//    }
    
}

-(void) saveBuffer{
    
    
//    if([[Activity_aux sharedInstance].ubicaciones isKindOfClass:[NSNull class]] == false && [[Activity_aux sharedInstance].ubicaciones count]!=0)
//    {
//        
//        NSMutableArray * copia = [[Activity_aux sharedInstance].ubicaciones copy];
//        for(id nl in copia)
//        {
//            Ubicacion_DTO * last_ubication = [Ubicacion_DAO getLastTrack];
//            
//            if(last_ubication==nil)
//            {
//                NSLog(@"insertando primera ubicacion");
//                Ubicacion_DTO *u_dto = [[Ubicacion_DTO alloc] init];
//                [u_dto setLon:[nl valueForKey:@"lon"]];
//                [u_dto setLat:[nl valueForKey:@"lat"]];
//                [u_dto setGpserror:[nl valueForKey:@"error"]];
//                [u_dto setFecha:[nl valueForKey:@"fecha"]];
//                [Ubicacion_DAO insertUbicacion:u_dto];
//                
//            }
//            else{
//                
//                
//                NSDate * date = (NSDate *)[nl valueForKey:@"fecha"];
//                NSTimeInterval secs = [date timeIntervalSinceDate:last_ubication.fecha];
//                int algo;
//                algo= (int)secs;
//                if(algo >= 5) // guardamos ubicaciones que tengan 5 segundos de diferencia
//                {
//                    NSLog(@"insertando ubicacion con 5 segundos de diferencia a Victoria");
//                    Ubicacion_DTO *u_dto = [[Ubicacion_DTO alloc] init];
//                    [u_dto setLon:[nl valueForKey:@"lon"]];
//                    [u_dto setLat:[nl valueForKey:@"lat"]];
//                    [u_dto setGpserror:[nl valueForKey:@"error"]];
//                    [u_dto setFecha:[nl valueForKey:@"fecha"]];
//                    [Ubicacion_DAO insertUbicacion:u_dto];
//                }
//            }
//        }
//    }
}

- (NSInteger) UbicacionesPendientes{
    NSMutableArray * tracks = [Ubicacion_DAO getTracks];
    
    return tracks.count;
}

-(void) tryReadBuffer{
    
    //getArrayUbicacionesParaPost
    
}

-(void)gotLocations:(NSArray *)locations{
    
    NSLog(@"ubicación entro al got locations");
    
    if([locations isKindOfClass:[NSNull class]] == false && locations != nil && [locations count] != 0)
    {
        for (CLLocation *myLocation in locations) {
            
            if(myLocation!=_bestLocation)
            {
                _bestLocation = myLocation;
                [self saveLocations:myLocation];
            }
            else
            {
                if (_bestLocation.horizontalAccuracy <myLocation.horizontalAccuracy) {
                    _bestLocation=myLocation;
                }
            }
        }
    }
    
    if([_bestLocation isKindOfClass:[NSNull class]] == false && _bestLocation != nil)
    {
        if(_bestLocation.horizontalAccuracy<=65)
        {
            NSDictionary * dictionaryAux = [[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithFormat:@"%lf",_bestLocation.coordinate.longitude],@"lon",[NSString stringWithFormat:@"%lf",_bestLocation.coordinate.latitude],@"lat",[NSString stringWithFormat:@"%lf",_bestLocation.horizontalAccuracy],@"error",_bestLocation.timestamp,@"fecha",nil];
            
            Ubicacion_DTO *u_dto = [[Ubicacion_DTO alloc] init];
            [u_dto setLon:[dictionaryAux valueForKey:@"lon"]];
            [u_dto setLat:[dictionaryAux valueForKey:@"lat"]];
            [u_dto setGpserror:[dictionaryAux valueForKey:@"error"]];
            [u_dto setFecha:[dictionaryAux valueForKey:@"fecha"]];
            [Ubicacion_DAO agregarUltimaUbicacionConocida:u_dto];
        }
        
        [self setLastKnownLocation:_bestLocation];
    }
}
-(void)setLastKnownLocation:(CLLocation *)newLocation{
    self.lastKnownLocationLatitude=newLocation.coordinate.latitude;
    self.lastKnownLocationLongitude=newLocation.coordinate.longitude;
    self.lastKnownLocationError=newLocation.horizontalAccuracy;
    self.lastKnownLocationTime=[newLocation.timestamp copy];
    
    
    //Esta wea devuelve la ubicacion actual del usuario al controlador Home (mientras tenga el trackeo activado, de esta manera actualizamos en vivo las distancias de los proyectos
    NSDictionary *latitudYLongitud = [[NSDictionary alloc] initWithObjectsAndKeys:@(self.lastKnownLocationLatitude), @"latitud", @(self.lastKnownLocationLongitude), @"longitud", nil];
    NSDictionary *devuelta =
    [NSDictionary dictionaryWithObjectsAndKeys:latitudYLongitud,@"presentUserLocation", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateUserLocation"
                                                        object:self
                                                      userInfo:devuelta];
    
    
    
}
@end
