//
//  Ubicacion_DTO.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ubicacion_DTO : NSObject

@property NSNumber * idUbicacion;
@property NSNumber * idMedio;
@property NSDate *fecha;
@property NSString *fecha_string;
@property NSString *lat;
@property NSString *lon;
@property NSString *gpserror;
@property bool isUploaded;
@property NSInteger last_one;

@end
