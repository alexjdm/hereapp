//
//  Ubicacion_DAO.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ubicacion_DTO.h"

@interface Ubicacion_DAO : NSObject

+(BOOL) insertUbicacion:(Ubicacion_DTO *) track;
+(NSMutableArray *) getUbicaciones;
+(Ubicacion_DTO *) getUbicacion: (NSInteger)idMedio;


+(BOOL) setAllAsUpdated;
+(BOOL) insertUbicacionesRuta:(NSMutableArray *) ubicaciones;
+(Ubicacion_DTO *) getLastTrack;
+(NSMutableArray *) getTracks;

+(NSMutableArray *) getUbicaciones: (NSDate *) fechaInicial;
+(NSMutableArray *) getUbicacionesRuta;
+(void) setUbicacionAsUploaded:(int) range_i :(int) range_f;
+(void) agregarUltimaUbicacionConocida:(Ubicacion_DTO *) ubicacion;
+(Ubicacion_DTO *) obtenerUltimaUbicacionConocida;
+(BOOL) borraLas2000UbicacionesMasViejas;
+(BOOL) ubicacionesSubidasSuperanLas2500;
+(BOOL) borraUbicacionesDeLaJornada;

@end
