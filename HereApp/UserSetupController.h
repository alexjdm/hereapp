//
//  UserSetupController.h
//  HereApp
//
//  Created by Alex Diaz on 1/18/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ViewController.h"
#import "PrincipalController.h"
#import "User_Setup_DTO.h"

@interface UserSetupController : ViewController

@property PrincipalController * controladorPrincipal;

@property (weak, nonatomic) IBOutlet UIImageView *mUserImage;
@property (weak, nonatomic) IBOutlet UIButton *mChangeImageButton;
@property (weak, nonatomic) IBOutlet UILabel *mUserName;
@property (weak, nonatomic) IBOutlet UILabel *mUserEmail;
@property (weak, nonatomic) IBOutlet UILabel *mUserPhone;
@property (weak, nonatomic) IBOutlet UILabel *mUserGender;

-(void) setInformation: (User_Setup_DTO*) user;

@end
