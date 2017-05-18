//
//  Helpers.h
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helpers : NSObject

+(NSString *) logDate:(NSDate *) fecha;
+(void) logToDb:(NSString *)mensaje :(NSString*) evento;
+(BOOL) puederVerLogs:(NSString *) id_usuario;
+(void) printLogs;
+(NSString *) getDatabasePath;
+(NSString *) date2VictoriaString:(NSDate *)date;
+(NSTimeInterval ) getFormatedTimeElapse:(NSString *) time;
+(NSDate *) getCurrentTime;
+(NSString *) dateString2String:(NSString *)date;

@end
