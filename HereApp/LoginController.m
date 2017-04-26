//
//  LoginController.m
//  HereApp
//
//  Created by Alex Diaz on 1/10/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "LoginController.h"
#import "Consts.h"
#import "User_Setup_DTO.h"
#import "User_Setup_DAO.h"
#import "Helpers.h"


@interface LoginController()<UITextFieldDelegate>
@property UIView* waiting;
@end

@implementation LoginController



//Metodo que ajusta la visualización al escribir datos en pantalla.
//Esto es para que teclado no tape datos en pantalla.
-(void) ajustar:(BOOL) valor
{
    
    if(valor)
    {
        if(_ajustado==false)
        {
            // Arriba
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            self.view.frame = CGRectMake(self.view.frame.origin.x,-160, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _ajustado = true;
            _arriba_anterior = _arriba_actual;
            _arriba_actual = true;
        }
    }
    else
    {
        if(_ajustado==false)
        {
            // Abajo o normal
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            _ajustado = true;
            _arriba_anterior = _arriba_actual;
            _arriba_actual = false;
        }
        
    }
}

- (IBAction)cambionombre:(id)sender {
    
    _ajustado = false;
    [self ajustar:YES];
    
}

- (IBAction)cambiopassword:(id)sender {
    
    _ajustado = false;
    [self ajustar:YES];
}

- (IBAction)finuser:(id)sender {
    
    _ajustado = false;
    [self ajustar:NO];
    
}

- (IBAction)finpassword:(id)sender {
    
    _ajustado = false;
    [self ajustar:NO];
    
}

//Fin metodos de visualización.


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _useremail.delegate = self;
    _userPassword.secureTextEntry=true;
    
    _useremail.delegate = self;
    _userPassword.delegate = self;
    [_userPassword setDelegate:self];
    
    _useremail.text=@"";
    _userPassword.text=@"";
    
    UIColor *ios7BlueColor = [UIColor colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1.0];
    
    
    _loginButton.layer.backgroundColor = ios7BlueColor.CGColor;
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.borderWidth = 1;
    _loginButton.layer.borderColor = (__bridge CGColorRef _Nullable)(ios7BlueColor);
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    _useremail.keyboardType = UIKeyboardTypeEmailAddress;
    _useremail.tag = 1;
    _userPassword.tag = 2;
    
}



- (IBAction)loginhandler:(id)sender {
    
    _ajustado = false;
    
    User_Setup_DTO *udto=[[User_Setup_DTO alloc]init];
    udto.correo_electronico = _useremail.text;
    udto.password = _userPassword.text;
    
    // Validar si los campos no son nulos
    if(![_useremail hasText] || ![_userPassword hasText])
    {
        //[self.view endEditing:YES]; // Cerramos el teclado
        [self ajustar:NO];
        
        UIAlertView *mAlert = [[UIAlertView alloc]
                               initWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"titleLoginVacio" value:@"" table:nil]
                               message:[[NSBundle mainBundle] localizedStringForKey:@"msgLoginVacio" value:@"" table:nil]
                               delegate:nil
                               cancelButtonTitle:[[NSBundle mainBundle] localizedStringForKey:@"Ok" value:@"" table:nil]
                               otherButtonTitles:nil, nil];
        
        
        mAlert.delegate = self;
        mAlert.tag = 1;
        [mAlert show];
        
    }
    else {
        [self ajustar:NO];
        _waiting = [self showActivityIndicatorOnView];
        
        //Login con callback, para mostrar animación..
        _uBusiness = [[UserBusiness alloc]init];
        _uBusiness.delegadoLoginController = self;
        [_uBusiness doLogin:udto];
    }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        
        if(_arriba_anterior){
            _ajustado = false;
            [self ajustar:YES];
        }
        
    }
}


//Callback de delegado al terminar las operaciones de logeo inicial.
-(void)loginValidado:(bool)validacion{
    
    //Con esto aseguramos, que el cambio a la UI se hace en el mainQueue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (validacion){
            
//            self.controladorPrincipal.ControladorCronometro.ESTADO_ACTUAL = Consts.NO_ESTA_TRABAJANDO;
            User_Setup_DTO * current = [User_Setup_DAO getUserSetup];
            self.controladorPrincipal.idUsuario = current.idUsuario;
            self.controladorPrincipal.ESTADO_ACTUAL = PANTALLA_MAPA;
            [self.controladorPrincipal refrescarPantalla];
            
        }
        else
        {
            [_waiting removeFromSuperview];
            
            UIAlertView *alertView;
            NSString *msg_feedback_login = [_uBusiness getMsg];
            
            if([msg_feedback_login  isEqual: @"sinConexion"]){
                alertView = [[UIAlertView alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"sinConexion" value:@"" table:nil]
                                                       message:@"Please try again"
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
            }
            else if([msg_feedback_login  isEqual: @"credencialesMalas"]){
                alertView = [[UIAlertView alloc] initWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"credencialesMalas" value:@"" table:nil]
                                                       message:@"Please try again"
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
            }
            else {
                alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving User"
                                                       message:@"Please try again"
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
            }
            
            
            alertView.delegate = self;
            alertView.tag = 2;
            [alertView show];
        }
    }];
}

- (UIActivityIndicatorView *)showActivityIndicatorOnView
{
    
    UIView * testview=self.view;
    NSLog(@"Mostrar Waiting...");
    CGSize viewSize = testview.bounds.size;
    
    // create new dialog box view and components
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // other size? change it
    activityIndicatorView.bounds = CGRectMake(0, 0, 65, 65);
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.alpha = 0.7f;
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.layer.cornerRadius = 10.0f;
    
    // display it in the center of your view
    activityIndicatorView.center = CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0);
    
    [testview  addSubview: activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    // [activityIndicatorView removeFromSuperview];
    
    [self.view endEditing:YES]; // Cerramos el teclado
    
    return activityIndicatorView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
    
    //    [textField resignFirstResponder];
    //    return YES;
}

@end
