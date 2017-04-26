//
//  Media_DAO.h
//  HereApp
//
//  Created by Alex Diaz on 1/23/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Media_DTO.h"


@interface Media_DAO : NSObject

+(BOOL) insertMedia:(Media_DTO *)media;
+(NSMutableArray *)getMedios;

@end
