//
//  Log_DAO.m
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "Log_DAO.h"
#import "LOG_DTO.h"
#import "FMDatabase.h"
#import "Helpers.h"

@implementation Log_DAO

+(NSMutableArray *) getLogs {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM LOG where subido=0 order by ID_LOG  limit 95"]];
    NSMutableArray * logs = [[NSMutableArray alloc] init];
    
    
    while([results next])
    {
        Log_DTO * log = [[Log_DTO alloc] init];
        log.ID_LOG= [results intForColumn:@"ID_LOG"];
        log.Fecha = [results dateForColumn:@"FECHA_LOG"];
        log.evento = [results stringForColumn:@"EVENTO"];
        log.version =[results stringForColumn:@"VERSION"];
        log.bateria =[results stringForColumn:@"BATERIA"];
        log.permisoubicacion =[results stringForColumn:@"PERMISOUBICACION"];
        log.latitud =[results stringForColumn:@"LATITUD"];
        log.longitud =[results stringForColumn:@"LONGITUD"];
        log.accuracy =[results stringForColumn:@"ACCURACY"];
        log.sistema =[results stringForColumn:@"SISTEMA"];
        log.mensaje =[results stringForColumn:@"MENSAJE"];
        [logs addObject:log];
        
    }
    
    return logs;
    
}

+(void) borrarLogsSiSobrePasanLos2000{
    
    
}

+(BOOL) setLogAsUploaded:(NSMutableArray *) logs{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    BOOL exito=false;
    
    [db open];
    if (logs.count>0){
        Log_DTO * linicial=[logs objectAtIndex:0];
        NSNumber * idloginicial=[NSNumber numberWithInt:linicial.ID_LOG];
        Log_DTO * lfinal=[logs objectAtIndex:logs.count-1];
        NSNumber * idlogfinal=[NSNumber numberWithInt:lfinal.ID_LOG];
        //asume que los logs vienen ordenados por id, asi que los setea con un mayor y un menor que.
        exito= [db executeUpdate:@"update log set subido=1 where id_log >= ? and id_log<=?",idloginicial,idlogfinal,nil];
        
        exito= [db executeUpdate:@"delete from log where id_log >= ? and id_log<=?",idloginicial,idlogfinal,nil];
    }
    [db close];
    return exito;
    
}

//El subir logs es una tarea "pesada" si acumula 1000 logs, no queremos demorar la subida de otras cosas
//por lo tanto, subimos 100 cuando haya oportunidad, para eso hay que rescatar 100.
+(void) get100Logs{
    
}

+(void) insert:(Log_DTO *)log{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    BOOL exito=false;
    
    [db open];
    log.SUBIDO=NO;
    //Obtener Batería restante
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    UIDevice *myDevice = [UIDevice currentDevice];
    
    [myDevice setBatteryMonitoringEnabled:YES];
    double batLeft = (float)[myDevice batteryLevel];
    NSLog(@"%f",batLeft);
    log.bateria=[NSString stringWithFormat:@"%f",batLeft];
    
    //Ver si tiene permiso de ubicación encendido.
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            NSLog(@"kCLAuthorizationStatusDenied");
            log.permisoubicacion=@"kCLAuthorizationStatusDenied";
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways){
            NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
            log.permisoubicacion=@"kCLAuthorizationStatusAuthorizedAlways";
            
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            log.permisoubicacion=@"kCLAuthorizationStatusAuthorizedWhenInUse";
        }
        else {
            NSLog(@"Otro Estado");
            log.permisoubicacion=@"Otro estado ¿¿??";
        }
        
    }
    else {
        log.permisoubicacion=@"Location services disabled.";
    }
    //Fin analisis permiso ubicación
    exito = [db executeUpdate:@"INSERT INTO LOG (FECHA_LOG,DESCRIPCION_LOG,SISTEMA,EVENTO,VERSION,MENSAJE,BATERIA,PERMISOUBICACION,LATITUD,LONGITUD,ACCURACY,SUBIDO) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);",log.Fecha,log.mensaje,log.sistema,log.evento,log.version,log.mensaje,log.bateria,log.permisoubicacion,log.latitud,log.longitud,log.accuracy, [NSNumber numberWithInteger:log.SUBIDO],nil];
    
    
    [db close];
}

@end
