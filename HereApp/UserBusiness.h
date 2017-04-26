//
//  UserBusiness.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_Setup_DTO.h"
#import "User_Setup_DAO.h"
#import "ClienteHTTP.h"

@protocol LoginDelegate <NSObject>

@required
- (void) loginValidado:(bool) validacion;
@end


@interface UserBusiness : NSObject

@property (nonatomic,strong) id delegadoLoginController;
@property NSString* msg_feedback_login;

-(void) doLogin:(User_Setup_DTO *) user;
+(void) RefreshIfNeeded;
-(NSString*) getMsg;

@end
