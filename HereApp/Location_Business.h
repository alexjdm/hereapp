//
//  Location_Business.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PrincipalController.h"

@interface Location_Business : NSObject
+ (Location_Business *)sharedInstance;
-(void) tryReadBuffer;
-(void) saveBuffer;
-(void)gotLocations:(NSArray *)locations;
- (NSInteger) UbicacionesPendientes;
@property double lastKnownLocationLatitude;
@property double lastKnownLocationLongitude;
@property double lastKnownLocationError;
@property NSDate *lastKnownLocationTime;
@property BOOL *lastKnownLocationIsValid;
@property NSMutableArray * locationBuffer;
@property bool busy; // en caso que la sincronización se ejecute, esto evita que la app repita las ubicaciones subidas
@property CLLocation *bestLocation;
@property PrincipalController *controladorPrincipal;


@end
