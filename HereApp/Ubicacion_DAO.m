//
//  Ubicacion_DAO.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "Ubicacion_DAO.h"
#import "Ubicacion_DTO.h"
#import "FMDatabase.h"
#import "Helpers.h"

@implementation Ubicacion_DAO

+(BOOL) insertUbicacion:(Ubicacion_DTO *) track
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    NSNumber *estaSincronizada = [NSNumber numberWithInt:0];
    if([track.lat doubleValue]==0 && [track.lon doubleValue]==0){
        
        // track.TIPO_UBICACION=@"SIN UBICACION";
    }
    BOOL success =  [db executeUpdate:@"INSERT INTO Ubicacion (idMedio, LAT, LON, ERROR, FECHA, ISUPLOADED, fecha_string) VALUES (?,?,?,?,?,?,?);", track.idMedio, track.lat, track.lon, track.gpserror, track.fecha, estaSincronizada, [Helpers date2VictoriaString:track.fecha], nil];
    
    [db close];
    return success;
}


+(NSMutableArray *) getUbicaciones
{
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion order by fecha"];
    
    Ubicacion_DTO *track;
    int numId;
    while([results next])
    {
        track = [[Ubicacion_DTO alloc]init];
        track.idMedio = [NSNumber numberWithInt:[results intForColumn:@"idMedio"]];
        track.fecha=[results dateForColumn:@"fecha"];
        track.lat=[results stringForColumn:@"LAT"];
        track.lon=[results stringForColumn:@"LON"];
        track.fecha_string=[results stringForColumn:@"fecha_string"];
        track.gpserror=[results stringForColumn:@"ERROR"];
        track.isUploaded=[results boolForColumn:@"ISUPLOADED"];
        numId = [results intForColumn:@"idUbicacion"];
        track.idUbicacion=[NSNumber numberWithInt:numId];
        [tracks addObject:track];
    }
    
    [db close];
    return tracks;
    
}

+(Ubicacion_DTO *) getUbicacion: (NSInteger)idMedio
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion where idMedio = ? order by fecha limit 1", @(idMedio), nil];
    
    Ubicacion_DTO *track;
    int numId;
    while([results next])
    {
        track = [[Ubicacion_DTO alloc]init];
        track.idMedio = [NSNumber numberWithInt:[results intForColumn:@"idMedio"]];
        track.fecha=[results dateForColumn:@"fecha"];
        track.lat=[results stringForColumn:@"LAT"];
        track.lon=[results stringForColumn:@"LON"];
        track.fecha_string=[results stringForColumn:@"fecha_string"];
        track.gpserror=[results stringForColumn:@"ERROR"];
        track.isUploaded=[results boolForColumn:@"ISUPLOADED"];
        numId = [results intForColumn:@"idUbicacion"];
        track.idUbicacion=[NSNumber numberWithInt:numId];
    }
    
    [db close];
    return track;
    
}






+(BOOL) borraLas2000UbicacionesMasViejas{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    bool executebool  = [db executeUpdate:@"DELETE FROM Ubicacion where isUploaded = 1 order by fecha desc limit 2000;"];
    [db close];
    return executebool;
    
}

+(BOOL) borraUbicacionesDeLaJornada{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    bool executebool  = [db executeUpdate:@"DELETE FROM Ubicacion where isUploaded = 1"];
    [db close];
    return executebool;
    
}

+(BOOL) setAllAsUpdated{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    
    bool executebool  = [db executeUpdate:@"update Ubicacion set isUploaded=1;"];
    NSLog(@"%d",executebool);
    return true;
}

+(BOOL) ubicacionesSubidasSuperanLas2500{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    FMResultSet *rs = [db executeQuery:@"select count(*) as cnt from Ubicacion where isUploaded=1"];
    int a = 0;
    [rs next];
    
    a=[rs intForColumn:@"cnt"];
    [db close];
    if(a>2000)
    {
        return true;
    }
    
    return false;
}

+(void) actualizarUltimaUbicaciónConocida:(Ubicacion_DTO *) ubicacion{
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    [db executeUpdate:@"update Ubicacion set fecha = ? where LAST_ONE = 1;",
     ubicacion.fecha, nil];
    [db executeUpdate:@"update Ubicacion set LAT = ? where LAST_ONE = 1;",
     ubicacion.lat, nil];
    [db executeUpdate:@"update Ubicacion set LON = ? where LAST_ONE = 1;",
     ubicacion.lon, nil];
    [db executeUpdate:@"update Ubicacion set ERROR = ? where LAST_ONE = 1;",
     ubicacion.gpserror, nil];
    
}

+(Ubicacion_DTO *) obtenerUltimaUbicacionConocida{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion where LAST_ONE = 1;"];
    Ubicacion_DTO *ubicacion=[[Ubicacion_DTO alloc]init];
    Ubicacion_DTO *toReturn = nil;
    bool no_hay = true;
    while([results next])
    {
        no_hay = false;
        ubicacion.fecha=[results dateForColumn:@"fecha"];
        ubicacion.lat=[results stringForColumn:@"LAT"];
        ubicacion.lon=[results stringForColumn:@"LON"];
        ubicacion.gpserror=[results stringForColumn:@"ERROR"];
        ubicacion.isUploaded=[results boolForColumn:@"ISUPLOADED"];
        int numId= [results intForColumn:@"idUbicacion"];
        ubicacion.idUbicacion=[NSNumber numberWithInt:numId];
        ubicacion.fecha_string = [results stringForColumn:@"fecha_string"];
        ubicacion.last_one = [results intForColumn:@"last_one"];
        toReturn = ubicacion;
    }
    [db close];
    
    return toReturn;
}

+(void) agregarUltimaUbicacionConocida:(Ubicacion_DTO *) ubicacion{
    
    // Si no existe la ultima ubicación obtenida se debe insertar, es decir crearla
    if([self obtenerUltimaUbicacionConocida] == nil)
    {
        FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
        
        [db open];
        
        NSNumber *estaSincronizada=[NSNumber numberWithInt:0];
        BOOL __unused success =  [db executeUpdate:@"INSERT INTO Ubicacion (LAT,LON,ERROR,FECHA,ISUPLOADED,fecha_string,LAST_ONE,fecha_string) VALUES (?,?,?,?,?,?,?,?);",
                                  ubicacion.lat, ubicacion.lon, ubicacion.gpserror, ubicacion.fecha,estaSincronizada,[Helpers date2VictoriaString:ubicacion.fecha],[NSNumber numberWithInt:1],[Helpers date2VictoriaString:ubicacion.fecha],nil];
        [db close];
        
        
    }
    else // caso contrario debemos actualizarla
    {
        [self actualizarUltimaUbicaciónConocida:ubicacion];
        
    }
}


+(Ubicacion_DTO *) getLastTrack
{
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    //FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion order by fecha desc "];
    NSLog(@"pregunta por la ultima ubicacion almacenada");
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion where last_one is null order by fecha desc limit 1;"];
    
    Ubicacion_DTO *track=[[Ubicacion_DTO alloc]init];
    bool no_hay = true;
    while([results next])
    {
        no_hay = false;
        track.fecha=[results dateForColumn:@"fecha"];
        track.lat=[results stringForColumn:@"LAT"];
        track.lon=[results stringForColumn:@"LON"];
        track.gpserror=[results stringForColumn:@"ERROR"];
        track.isUploaded=[results boolForColumn:@"ISUPLOADED"];
        int numId= [results intForColumn:@"idUbicacion"];
        track.idUbicacion=[NSNumber numberWithInt:numId];
        [tracks addObject:track];
    }
    
    if(no_hay == true)
        track = nil;
    
    [db close];
    return track;
    
}



+(NSMutableArray *) getTracks
{
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    //FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion order by fecha desc "];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion where isuploaded=0 order by fecha limit 1000;"];
    
    while([results next])
    {
        Ubicacion_DTO *track=[[Ubicacion_DTO alloc]init];
        track.fecha=[results dateForColumn:@"fecha"];
        track.lat=[results stringForColumn:@"LAT"];
        track.lon=[results stringForColumn:@"LON"];
        track.fecha_string=[results stringForColumn:@"fecha_string"];
        track.gpserror=[results stringForColumn:@"ERROR"];
        track.isUploaded=[results boolForColumn:@"ISUPLOADED"];
        int numId= [results intForColumn:@"idUbicacion"];
        track.idUbicacion=[NSNumber numberWithInt:numId];
        [tracks addObject:track];
    }
    
    [db close];
    return tracks;
    
}

+(NSMutableArray *) getUbicaciones: (NSDate *) fechaInicial
{
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion where fecha >= ? order by fecha", fechaInicial];
    
    Ubicacion_DTO *track;
    int numId;
    while([results next])
    {
        track=[[Ubicacion_DTO alloc]init];
        track.fecha=[results dateForColumn:@"fecha"];
        track.lat=[results stringForColumn:@"LAT"];
        track.lon=[results stringForColumn:@"LON"];
        track.fecha_string=[results stringForColumn:@"fecha_string"];
        track.gpserror=[results stringForColumn:@"ERROR"];
        track.isUploaded=[results boolForColumn:@"ISUPLOADED"];
        numId = [results intForColumn:@"idUbicacion"];
        track.idUbicacion=[NSNumber numberWithInt:numId];
        [tracks addObject:track];
    }
    
    [db close];
    return tracks;
    
}


+(Ubicacion_DTO *) getTracksToUpload
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Ubicacion where isuploaded=0 order by fecha limit 1000;"];
    // =nil;
    Ubicacion_DTO *u_dto  = [[Ubicacion_DTO alloc] init];
    int contador=0;
    while([results next])
    {
        
        //int numId= [results intForColumn:@"id_punch"];
        //punch.id_punch=[NSNumber numberWithInt:numId];
        
        NSString * lon = [results stringForColumn:@"lon"];
        NSString * lat = [results stringForColumn:@"lat"];
        NSString * error = [results stringForColumn:@"error"];
        u_dto.fecha = [results dateForColumn:@"fecha"];
        u_dto.lon = lon;
        u_dto.lat = lat;
        u_dto.gpserror = error;
        
        contador++;
        
    }
    
    
    
    NSLog(@"tracks: %d",contador);
    
    
    
    [db close];
    if (contador==0)
        return nil;
    else
        return u_dto;
    //return customers;
    
}


+(void) setUbicacionAsUploaded:(int) range_i :(int) range_f{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    //SELECT * FROM table WHERE id BETWEEN 10 AND 50
    [db executeUpdate:@"update Ubicacion set isUploaded=1 WHERE idUbicacion BETWEEN ? AND ?;",
     @(range_i),@(range_f), nil];
    
    //    bool executebool2=[db executeUpdate:@"delete from Ubicacion where isUploaded=1"];
    
    [db close];
}



+(NSMutableArray *) getUbicacionesRuta
{
    NSMutableArray *ubicaciones = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM UBICACION_RUTA order by fecha;"];
    
    while([results next])
    {
        Ubicacion_DTO *ubicacion=[[Ubicacion_DTO alloc]init];
        ubicacion.fecha=[results dateForColumn:@"FECHA"];
        ubicacion.lat=[results stringForColumn:@"LATITUD"];
        ubicacion.lon=[results stringForColumn:@"LONGITUD"];
        int numId = [results intForColumn:@"ID_UBICACION"];
        ubicacion.idUbicacion=[NSNumber numberWithInt:numId];
        [ubicaciones addObject:ubicacion];
    }
    
    [db close];
    return ubicaciones;
    
}

+(BOOL) insertUbicacionesRuta:(NSMutableArray *) ubicaciones
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    
    BOOL success = true;
    
    if([db executeUpdate:@"delete from UBICACION_RUTA"])
    {
        for(Ubicacion_DTO *ubicacion in ubicaciones)
        {
            success = [db executeUpdate:@"INSERT INTO UBICACION_RUTA (FECHA, LATITUD, LONGITUD) VALUES (?,?,?);", ubicacion.fecha, ubicacion.lat, ubicacion.lon] || success;
        }
    }
    else
        success = false;
    
    [db close];
    return success;
    
}


@end

