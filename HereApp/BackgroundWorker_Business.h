//
//  BackgroundWorker_Business.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Media_DTO.h"
#import "User_Setup_DTO.h"
#import "ClienteHTTP.h"
#import "UserBusiness.h"

@interface BackgroundWorker_Business : NSObject

@property (nonatomic,strong) id delegate;


-(void) defineMedioComoPendiente:(Media_DTO *)media;
-(void) defineMedioComoSubido:(Media_DTO *) media : (NSString *) urlLocal : (bool) value;
-(void) subeMedias;
-(void) subeUbicacionesPendientes;
-(void) SincronizacionSincrona;
-(void) subirDataPendiente;
-(void) borrarUbicaciones;
- (void) startDownloadingEssentialDataSincrono:(User_Setup_DTO *) user withHash:(NSInteger)hashCode :(ClienteHTTP *) sampleProtocol;
-(void) subeUbicacionesSincrona;
-(void) endCheckData:(NSInteger)hashCode;
-(void) endDownloadingEssentialData:(bool)validacion withHashCode:(NSInteger)hashCode;
-(BOOL) pendingData;
-(void) saveNewHashCode:(NSInteger) hashCode;
-(void) gestionarUbicaciones:(NSArray*) ubicaciones;


@property bool estaUpdateando;
@property bool subirMediaEnProgreso;
@property bool subirUbicacionesEnProgreso;
@property bool subirBaseDeDatosEnProgreso;
@property bool terminoSubirUbicaciones;
@property bool terminoSubirTimecard;
@property bool terminoSubirMedias;
@property bool terminoSubirReportes;
@property bool busy;
@property bool debe_cerrar_sesion;
@property bool logro_enviar_la_bd;
@property NSDate* fechaUltimaSincronizacion;
@property dispatch_queue_t queue;

typedef enum{
    SUBIENDO,
    SUBIDO,
    FALLO
} ESTADO;

@property ESTADO state;
@property NSInteger lastUpdatedHashCode;
@property NSInteger newHashCode;

@end
