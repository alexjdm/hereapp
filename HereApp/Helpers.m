//
//  Helpers.m
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#import "Helpers.h"
#import "AppDelegate.h"
#import "User_Setup_DAO.h"
#import "Log_DAO.h"
#import "Log_DTO.h"


@implementation Helpers

+(NSString *) logDate:(NSDate *) fecha{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:fecha];
    return  stringFromDate;
    
}

+(void)logToDb:(NSString *)mensaje :(NSString*) evento{
    
    Log_DTO *l =[[Log_DTO alloc]init];
    l.Fecha=[self getCurrentTime];
    
    l.mensaje=mensaje;
    NSString * estado=@"";
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state == UIApplicationStateBackground)
    {
        //Do checking here
        estado=@"UIApplicationStateBackground";
    }
    if (state == UIApplicationStateInactive){
        estado=@"UIApplicationStateInactive";
    }
    if (state==UIApplicationStateActive){
        estado=@"UIApplicationStateActive";
    }
    l.mensaje = [NSString stringWithFormat:@"(%@) Msg: %@", estado, l.mensaje];
    l.evento = evento;
    [Log_DAO insert:l];
    
}

+(void) printLogs{
    // [Log_DAO getLogs:[self getCurrentTime]];
}

+(BOOL) puederVerLogs:(NSString *) id_usuario{
    
    
    // esto es para ver los logs
    if([id_usuario isEqualToString:@"80566"] == true ||
       [id_usuario isEqualToString:@"90981"] == true ||
       [id_usuario isEqualToString:@"95519"] == true ||
       [id_usuario isEqualToString:@"95520"] == true ||
       [id_usuario isEqualToString:@"95521"] == true ||
       [id_usuario isEqualToString:@"109196"] == true ||
       [id_usuario isEqualToString:@"97219"] == true ||
       [id_usuario isEqualToString:@"100765"] == true ||
       [id_usuario isEqualToString:@"106886"] == true ||
       [id_usuario isEqualToString:@"97507"] == true ||
       [id_usuario isEqualToString:@"119639"] == true ||
       [id_usuario isEqualToString:@"119640"] == true)
    {
        return YES;
    }
    
    
    return NO;
}

+(NSDate *) getCurrentTime{
    
    return [NSDate date];
}

+(NSString *) getDatabasePath
{
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    
    return databasePath;
}

+(NSString *) date2VictoriaString:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:date];
}

+(NSString *) dateString2String:(NSString *)date{
    
    NSString *fecha = [[NSString alloc] init];
    
    NSString *ano = [date substringToIndex:4];
    NSRange rango = NSMakeRange(4, 2);
    NSString *mes = [date substringWithRange:rango];
    rango = NSMakeRange(6, 2);
    NSString *dia = [date substringWithRange:rango];
    rango = NSMakeRange(8, 2);
    NSString *hora = [date substringWithRange:rango];
    rango = NSMakeRange(10, 2);
    NSString *mins = [date substringWithRange:rango];
    rango = NSMakeRange(12, 2);
    NSString *secs = [date substringWithRange:rango];
    
    fecha = [fecha stringByAppendingString:hora];
    fecha = [fecha stringByAppendingString:@":"];
    fecha = [fecha stringByAppendingString:mins];
    fecha = [fecha stringByAppendingString:@":"];
    fecha = [fecha stringByAppendingString:secs];
    fecha = [fecha stringByAppendingString:@" "];
    fecha = [fecha stringByAppendingString:dia];
    fecha = [fecha stringByAppendingString:@"-"];
    fecha = [fecha stringByAppendingString:mes];
    fecha = [fecha stringByAppendingString:@"-"];
    fecha = [fecha stringByAppendingString:ano];
    
    return fecha;
    
}

+(NSTimeInterval ) getFormatedTimeElapse:(NSString *) time{
    
    NSArray* foo = [time componentsSeparatedByString:@":"];
    NSString* hour = [foo objectAtIndex: 0];
    NSString* minute = [foo objectAtIndex: 1];
    int hora;
    int minuto;
    if([hour containsString:@"-"] == true || [minute containsString:@"-"] == true)
    {
        
        hour = [hour stringByReplacingOccurrencesOfString:@"-" withString:@""];
        minute =  [minute stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        hora = (-1)*[[NSNumber numberWithInteger:[hour integerValue]] intValue];
        minuto =  (-1)*[[NSNumber numberWithInteger:[minute integerValue]] intValue];
    }
    else
    {
        hora = [[NSNumber numberWithInteger:[hour integerValue]] intValue];
        minuto =  [[NSNumber numberWithInteger:[minute integerValue]] intValue];
    }
    
    
    NSTimeInterval intervaloDeTiempo = (hora*60*60) + (minuto*60);
    
    return intervaloDeTiempo;
}


@end
