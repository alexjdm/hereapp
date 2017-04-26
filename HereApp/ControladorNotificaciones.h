//
//  ControladorNotificaciones.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PrincipalController;
@interface ControladorNotificaciones : NSObject

@property PrincipalController * ControladorPrincipal;

+(void) crearNotificacionNuevaImagen:(NSTimeInterval *) duracion : (NSDate *) fecha_inicio;
+(void) borrarNotificacionNuevaImagen;

@end

