//
//  UserBusiness.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "UserBusiness.h"


@implementation UserBusiness

-(User_Setup_DTO*) fakeDoLogin:(User_Setup_DTO *) user {
    
    User_Setup_DTO *userRet = [[User_Setup_DTO alloc] init];
    userRet.correo_electronico = user.correo_electronico;
    userRet.apellidos = @"Diaz";
    userRet.nombres= @"Alex";
    userRet.idUsuario = [NSNumber numberWithInt:1];
    userRet.password = user.password;
    userRet.telefono = @"+56951145392";
    userRet.genero = @"M";
    userRet.ultimo_login = [NSDate date];
    
    return userRet;
}

-(void)doLogin:(User_Setup_DTO *) user{
    
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        // Perform long-running tasks without blocking main thread
        //User_Setup_DTO * usuarioLogin = [ClienteHTTP doLogin:user];
        User_Setup_DTO * usuarioLogin = [self fakeDoLogin:user];
        
        if (usuarioLogin.idUsuario == nil && usuarioLogin.msg_feedback_login.length > 0)
        {
            _msg_feedback_login = usuarioLogin.msg_feedback_login;
            usuarioLogin = NULL;
        }
        
        [User_Setup_DAO insert:usuarioLogin];
        
        if (usuarioLogin == NULL)
        {
            NSLog(@"LoginErroneo");
            [_delegadoLoginController loginValidado:false];
        }
        else{
            NSLog(@"LoginExitoso");
            //[UserBusiness RefreshIfNeeded];
            [_delegadoLoginController loginValidado:true];
        }
        
    }];
    
}

+(void) RefreshIfNeeded{
    
    User_Setup_DTO* usuarioLogin = [User_Setup_DAO getUserSetup];
    //Obtener Hash de datos
    NSInteger  hashCode=[ClienteHTTP getDataHash:usuarioLogin];
    
    NSInteger StoredHashCode= [User_Setup_DAO getHashCode];
    
    //Si son distintos, actualizar.
    if(hashCode!=StoredHashCode){
        
        [User_Setup_DAO saveHashCode:hashCode];
        [ClienteHTTP DownloadEssentialDataSincrono:usuarioLogin];
        
    }
    else{
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHECKSYNC" object:@true];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"didFinishDownloadProjectData" object:nil];
    
}

-(NSString*) getMsg{
    return _msg_feedback_login;
}

@end

