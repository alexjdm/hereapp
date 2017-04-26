//
//  User_Setup_DAO.h
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_Setup_DTO.h"

@interface User_Setup_DAO : NSObject

+(BOOL) insert:(User_Setup_DTO *) usuario;
+(BOOL) delete:(User_Setup_DTO *) usuario;
+(BOOL) update:(User_Setup_DTO *) usuario;
+(User_Setup_DTO*) getUserSetup;
+(NSInteger) getHashCode;
+(bool) saveHashCode:(NSInteger)hashCode;
//+(bool) StoreEssentialData:(SyncObject_DTO *) syncObject : (NSMutableArray *) proyectosRecibidos :(NSMutableArray *) tareasRecibidas;


@end
