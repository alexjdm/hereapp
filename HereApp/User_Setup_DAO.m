//
//  User_Setup_DAO.m
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "User_Setup_DAO.h"
#import "User_Setup_DTO.h"
#import "FMDatabase.h"
#import "Helpers.h"

@implementation User_Setup_DAO

+(BOOL) insert:(User_Setup_DTO*) usuario{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    NSLog(@"Intento guardar a %@ y fecha:%@", [usuario correo_electronico], usuario.ultimo_login);
    BOOL success =  [db executeUpdate:@"INSERT INTO user_setup (idUsuario, correo_electronico, nombres, apellidos, ultimo_login, password, telefono, genero) VALUES (?,?,?,?,?,?,?,?);",usuario.idUsuario, usuario.correo_electronico, usuario.nombres, usuario.apellidos, usuario.ultimo_login, usuario.password, usuario.telefono, usuario.genero, nil];
    
    [db close];
    
    return success;
    
    
}

+(BOOL) delete:(User_Setup_DTO *) usuario{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    bool success= [db executeUpdate:@"delete from user_setup;"];
    [db close];
    return success;
}

+(BOOL) update:(User_Setup_DTO *) usuario{
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    
    bool success = [db executeUpdate:@"update user_setup set ultimo_login=?",usuario.ultimo_login,nil];
    bool success3 __unused= [db executeUpdate:@"update user_setup set correo_electronico=?",usuario.correo_electronico,nil]; //descomentar
    bool success4 __unused= [db executeUpdate:@"update user_setup set nombres=?",usuario.nombres,nil]; //descomentar
    bool success5 __unused= [db executeUpdate:@"update user_setup set apellidos=?",usuario.apellidos,nil]; //descomentar
    bool success6 __unused= [db executeUpdate:@"update user_setup set password=?",usuario.password,nil]; //descomentar
    bool success7 __unused= [db executeUpdate:@"update user_setup set telefono=?",usuario.telefono,nil]; //descomentar
    bool success8 __unused= [db executeUpdate:@"update user_setup set genero=?", usuario.genero,nil]; //descomentar
    
    
    [db close];
    return success;
}

+(User_Setup_DTO *) getUserSetup
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM user_setup"];
    int resultsCount = 0;
    User_Setup_DTO *user = [[User_Setup_DTO alloc] init];
    int iduser;
    while([results next])
    {
        iduser = [results intForColumn:@"idUsuario"];
        user.idUsuario = [NSNumber numberWithInt:iduser];
        user.correo_electronico  = [results stringForColumn:@"correo_electronico"];
        user.nombres = [results stringForColumn:@"nombres"];
        user.apellidos = [results stringForColumn:@"apellidos"];
        user.ultimo_login = [results dateForColumn:@"ultimo_login"];
        user.password = [results stringForColumn:@"password"];
        user.telefono = [results stringForColumn:@"telefono"];
        user.genero = [results stringForColumn:@"genero"];
        user.navigation_drawer_color =  [UIColor colorWithRed:40/255 green:103/255 blue:255/255 alpha:0.6] ;
        user.topbar_color = [UIColor colorWithRed:40 green:133 blue:255 alpha:1] ;        
        
        resultsCount++;
        break;
    }
    
    [db close];
    
    if (resultsCount==0){
        return nil;
        //TODO: tirar un error
    }
    return user;
    
}

+(NSInteger) getHashCode{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM user_setup"];
    int valordevolver=0;
    while([results next])
    {
        valordevolver=[results intForColumn:@"UPDATE_HASHCODE"];
        
    }
    [db close];
    
    return valordevolver;
}

+(bool) saveHashCode:(NSInteger)hashCode{
    FMDatabase *db = [FMDatabase databaseWithPath:[Helpers getDatabasePath]];
    
    [db open];
    bool success __unused= [db executeUpdate:@"update user_setup set UPDATE_HASHCODE=?", @(hashCode), nil];
    [db close];
    
    return success;
}

@end
