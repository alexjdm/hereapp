//
//  BackgroundWorker_Business.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "BackgroundWorker_Business.h"
#import "Helpers.h"
#import "ClienteHTTP.h"
#import "Location_Business.h"
#import "User_Setup_DAO.h"
#import "Ubicacion_DAO.h"
#import "Log_DAO.h"


@implementation BackgroundWorker_Business

-(void) subeUbicacionesPendientes {
    
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        // Perform long-running tasks without blocking main thread
        [[Location_Business sharedInstance] tryReadBuffer];
    }];
    
}

-(void) defineMedioComoSubido:(Media_DTO *) media{
    
    //[Reporte_DAO updateMedia:media :media.urlVictoria :true];
    _subirMediaEnProgreso=false;
    //[self subeMedias];
}

-(void) defineMedioComoPendiente:(Media_DTO *)media{
    
    //[Reporte_DAO updateMedia:media :@"" :false];
    _subirMediaEnProgreso = false;
    //[self subeUnReporte];
}

-(void) subeMedias{
    
    //NO DEBERIA ESTAR LLAMANDO A ESTA WEA
    //  return;
    if (_subirMediaEnProgreso)
        return;
    
    _subirMediaEnProgreso=true;
    NSLog(@"Intenta subir un reporte Manual");
    
    Media_DTO * mdto;// = [Reporte_DAO getLastMediaPending];
    if (mdto!=nil)
    {
        
        ClienteHTTP * chttp = [[ClienteHTTP alloc] init];
        [chttp uploadPendingFileToServer:mdto];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setTerminoSubirMedias" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setTerminoSubirReportes" object:nil];
        _subirMediaEnProgreso = false;
    }
    
    
}

-(void) updatear{
    
    if(self.estaUpdateando == false)
    {
        self.estaUpdateando = true;
        //     [TimeCard_DAO asignarIdsDeMarcasATimecardsPendientes];
        self.estaUpdateando = false;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"updatear"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"subeTimecardsSincrona" object:nil];
        
    }
    
}

-(void) gestionarUbicaciones:(NSArray*) ubicaciones{
    
    [[Location_Business sharedInstance] gotLocations:ubicaciones];
    
}

-(void) SincronizacionSincronaDesdeTimer{
    [self SincronizacionSincrona];
    
}

-(void) terminoSincronizacion{
    
    self.busy=false;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHECKSYNC" object:@(false)];
    //[Helpers logToDb:@"FIN SincronizacionSincrona"];
    
}

//Este método sincroniza por completo.
//Baja cosas nuevas proyectos/tareas
//y sube lo que pueda tener pendiente.
-(void) SincronizacionSincrona{
    
    // [Helpers logToDb:@"INICIO SincronizacionSincrona"];
    
    NSLog(@"entro a sync sincrona ");
    
    self.busy=true;
    [UserBusiness RefreshIfNeeded];
    //     [[BackgroundWorker_Business sharedInstance] endCheckData:0];
    
    
    
    //Por el contrario, si han pasado mas de 200 segundos, entonces no puede estar "busy"
    //la unica explicación es que algo se colgó. Un post no puede demorarse 200 segundos.
    [self subirDataPendiente];
    NSLog(@"terminé de subir a sync sincrona ");
    
}

//Es parecido a la sincronizaciónSincrona, pero es solo para subir cosas.
//la sincronizacion, además se trae cuestiones.
-(void) subirDataPendiente{
    
    //  dispatch_queue_t queue;
    //  queue = dispatch_queue_create("com.geovictoria.QueueSubeData", NULL);
    
    NSLog(@"Encolo una llamada");
    
    dispatch_async(_queue, ^{
        int randomNumber = arc4random() % 100;
        NSLog(@"Inicio un elemento de la cola %d",randomNumber);
//        [self subeMarcasSincrona];
//        [self subeTimecardsSincrona];
//        [self subeUbicacionesSincrona];
//        
//        [self subeMediasSincrono];
//        [self subeReportesSincrono];
//        [self subeLogsSincrono];
//        
//        [self descargarUbicacionesDePersonasSincrona];
//        [self subeBaseDeDatosSincrona];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TerminoSincronizacion" object:nil];
        
        
        //Cerrar el Cargando si es que apreto boton
        NSLog(@"Finalizo Elemento de la cola %d",randomNumber);
    });
    
}

-(void) borrarUbicaciones{
    
    //[self borraUbicacionesDeLaJornada];
}

-(void) borrarUbicacionesSubidas{
    
    if([Ubicacion_DAO ubicacionesSubidasSuperanLas2500] == true)
    {
        [self borraLas2000UbicacionesMasViejas];
    }
}

-(void) subeLogsSincrono {
    
    NSMutableArray * logs = [Log_DAO getLogs];
    [ClienteHTTP subirLog:logs];
    
}

-(void) subeUbicacionesSincrona{
    
    if(self.subirUbicacionesEnProgreso == false)
    {
        self.subirUbicacionesEnProgreso = true;
        NSMutableArray *tracks = [Ubicacion_DAO getTracks];
        NSMutableArray *arrayTemporal = [[NSMutableArray alloc]init];
        int contador=0;
        bool correcto;
        for(NSDictionary * ubic in tracks){
            if (contador > 100){
                correcto = [ClienteHTTP upLoadLocationSincrona:arrayTemporal];
                contador = 0;
                if (!correcto){
                    NSLog(@"Error al subir");
                    return;
                }
                
                [arrayTemporal removeAllObjects ];
            }
            
            
            [arrayTemporal addObject:ubic];
            contador++;
        }
        
        if (arrayTemporal.count>0){
            __unused bool correcto=[ClienteHTTP upLoadLocationSincrona:arrayTemporal];
        }
        
        self.subirUbicacionesEnProgreso = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"terminoSincronizacion" object:nil];
    }
    else{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"terminoSincronizacion" object:nil];
    }
    
}

-(void) subeBaseDeDatosSincrona{
    
    if(_subirBaseDeDatosEnProgreso == false)
    {
        _subirBaseDeDatosEnProgreso = true;
        [ClienteHTTP subeBaseDeDatosSincrona];
        _subirBaseDeDatosEnProgreso = false;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"subeMediasSincrono" object:nil];
        
    }
    
}


-(BOOL) borraLas2000UbicacionesMasViejas{
    
    return [Ubicacion_DAO borraLas2000UbicacionesMasViejas];
    
}

-(void) subeMediasSincrono{
    
    
    NSMutableArray * medias; //= [Reporte_DAO getPendingMedias];
    for(Media_DTO * p in medias){
        Media_DTO * devuelta=  [ClienteHTTP uploadMediaSincrona:p];
        if (devuelta!=nil){
            [self defineMedioComoSubido:devuelta];
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"subeReportesSincrono" object:nil];
    
}

-(void)endDownloadingEssentialData:(bool)validacion withHashCode:(NSInteger)hashCode{
    NSLog(@"fin descarga datos esenciales (business)..");
    
    if(validacion){
        _state=SUBIENDO;
        [self setHashCode:hashCode];
        
        
    }
    else{
        _state=FALLO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHECKSYNC" object:@(validacion)];
    
}

-(void)setHashCode:(NSInteger)mInt{
    
    _lastUpdatedHashCode=mInt;
    
}

-(void) saveNewHashCode:(NSInteger) hashCode{
    
    _newHashCode = hashCode;
    
}

-(void)endCheckData:(NSInteger)hashCode{
    if(_newHashCode!=_lastUpdatedHashCode){
        
        ClienteHTTP *sampleProtocol = [[ClienteHTTP alloc]init];
        sampleProtocol.delegate = self;
        [self startDownloadingEssentialDataSincrono:[User_Setup_DAO getUserSetup] withHash:_newHashCode:sampleProtocol];
        // [sampleProtocol startDownloadingEssentialData:[User_Setup_DAO getUserSetup] withHash:hashCode];
    }
    else{
        
        if(_debe_cerrar_sesion == true)
        {
            //  self.state=UPDATED;
        }
        else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHECKSYNC" object:@true];
            //[[NSNotificationCenter defaultCenter]postNotificationName:@"cargarTablaProyectos" object:nil];
        }
        
    }
}

- (void) startDownloadingEssentialDataSincrono:(User_Setup_DTO *) user withHash:(NSInteger)hashCode :(ClienteHTTP *) sampleProtocol
{
    
    //[sampleProtocol startDownloadingEssentialDataSincrono:[User_Setup_DAO getUserSetup] withHash:hashCode];
    
}

-(void) descargarUbicaciones{
    
    //[ClienteHTTP obtenerLasUbicacionesDeLosSupervisadosSincrona];
    
}

@end
