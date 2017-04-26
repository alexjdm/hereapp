//
//  Log_DTO.h
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Log_DTO : NSObject

@property int ID_LOG;
@property NSDate * Fecha;
@property NSString *fechaEventoLocal;
@property NSString *correo;
@property NSString *sistema;

@property NSString *evento;
@property NSString *version;
@property NSString *mensaje;
@property NSString *bateria;
@property NSString *permisoubicacion;
@property NSString *latitud;
@property NSString *longitud;
@property NSString *accuracy;
@property bool SUBIDO;

@end

