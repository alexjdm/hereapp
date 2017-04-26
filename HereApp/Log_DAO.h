//
//  Log_DAO.h
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log_DTO.h"
#import <CoreLocation/CoreLocation.h>

@interface Log_DAO : NSObject

+(void) insert:(Log_DTO *)log;
+(NSMutableArray *) getLogs;
+(BOOL) setLogAsUploaded:(NSMutableArray *) logs;

@end
