//
//  Media_DAO.m
//  HereApp
//
//  Created by Alex Diaz on 1/23/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "Media_DAO.h"
#import "Media_DTO.h"
#import "FMDatabase.h"
#import "Helpers.h"
#import "Ubicacion_DAO.h"

@implementation Media_DAO

+(BOOL) insertMedia:(Media_DTO *)media
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    BOOL success =  [db executeUpdate:@"INSERT INTO medio (urlLocal, comentario, isUploaded, tipoMedio, idUsuario) VALUES (?,?,?,?,?);", media.urlLocal, media.comentario, @(media.isUploaded), @(media.type), @(media.idUsuario), nil];
    
    long long lastId = [db lastInsertRowId];
    media.idMedio = lastId;
    
    [db close];
    
    return success;
    
}

+(NSMutableArray *)getMedios{
    NSMutableArray *medias = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM medio order by idMedio desc"];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:queryString];
    
    Media_DTO *media;
    while([results next])
    {
        media = [[Media_DTO alloc]init];
        media.idMedio = [results intForColumn:@"idMedio"];
        media.isUploaded = [results intForColumn:@"isUploaded"];
        media.urlLocal = [results stringForColumn:@"urlLocal"];
        media.type = [results intForColumn:@"tipoMedio"];
        media.comentario = [results stringForColumn:@"comentario"];
        media.idUsuario = [results intForColumn:@"idUsuario"];
        
        media.ubicacion = [Ubicacion_DAO getUbicacion:media.idMedio];
        
        [medias addObject:media];
    }
    
    [db close];
    return medias;
}

@end
