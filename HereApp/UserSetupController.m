//
//  UserSetupController.m
//  HereApp
//
//  Created by Alex Diaz on 1/18/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "UserSetupController.h"
#import "User_Setup_DAO.h"

@interface UserSetupController ()

@end

@implementation UserSetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_controladorPrincipal.navigationController.navigationBar.topItem.backBarButtonItem = nil;
    //self.navigationController.navigationBar.topItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    User_Setup_DTO * user = [User_Setup_DAO getUserSetup];
    [self setInformation:user];
}

- (IBAction)changeImage:(id)sender {
    
    
    
}

-(void) setInformation: (User_Setup_DTO*) user {
    
    _mUserName.text = [NSString stringWithFormat:@"%@ %@", user.nombres, user.apellidos];
    _mUserEmail.text = user.correo_electronico;
    _mUserPhone.text = user.telefono;
    _mUserGender.text = user.genero;
}



@end
