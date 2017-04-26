//
//  DatabaseHelper.h
//  HereApp
//
//  Created by Alex Diaz on 1/7/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseHelper : NSObject
+(void)recreateDatabase;
+(void) deleteAllDataBase;
@end
