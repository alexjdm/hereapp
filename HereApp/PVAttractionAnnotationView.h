//
//  PVAttractionAnnotationView.h
//  Park View
//
//  Created by Cesare Rocchi on 6/19/14.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PVAttractionAnnotationView : MKAnnotationView

@property CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *nombre;
@property (nonatomic, copy) NSString *fecha;
@property (nonatomic,copy) NSString *identificador;
@property  NSInteger  tipo;

@end
