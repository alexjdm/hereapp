//
//  PrincipalController.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#import "PrincipalController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "DatabaseHelper.h"
#import "Ubicacion_DAO.h"
#import "Consts.h"
#import "BackgroundWorker_Business.h"
#import "ControladorGPS.h"
#import "LoginController.h"
#import "ControladorNotificaciones.h"
#import "ControladorMapa.h"
#import "CameraController.h"
#import "GalleryController.h"
#import "UserSetupController.h"

//Forward Classes
#import "BackgroundWorker_Business.h"
//#import "ControladorGPS.h"

@interface PrincipalController ()<UITabBarControllerDelegate,CLLocationManagerDelegate>

@property UIAlertController *alert;
@property UIAlertController *closingSession;
@property NSTimer * timer;
@property NSTimer * sync_timer;
@property NSTimer * location_timer;
@property NSTimeInterval  tiempo_sync;

@end


@implementation PrincipalController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//Este método es el mas importante. Hace todas las comprobaciones necesarias y llama
//a los responsables de cada funcionalidad.
-(void) IniciarApp{

    //Al iniciar, creamos los controladores.
    //Probablemente luego sea necesario crearlos on-demand.
    [self InstanciarControladores];
    [self recuperarEstado];
    [self refrescarPantalla];
//    
//    if([User_Setup_DAO getUserSetup]!=nil){
//        [self SincronizacionSincrona];
//    }
    
    //[[NSNotificationCenter defaultCenter] addObserver:self
    //                                         selector:@selector(QuitarAlertSincronizando)
    //                                             name:@"TerminoSincronizacion"
    //                                           object:nil];
    
}

-(void) InstanciarControladores {
    
    self.ESTADO_ACTUAL = Consts.SIN_LOGIN;
    
    //_TrabajadorBackground = [[BackgroundWorker_Business alloc]init];
    //Instanciar cola
    //_TrabajadorBackground.queue = dispatch_queue_create("com.geovictoria.QueueSubeData", NULL);
    
    
    _ControladorGPS = [[ControladorGPS alloc]init];
    [_ControladorGPS iniciarEscuchaGPS];
    
    //Logs, Privado.
    //_logViewController = [[LogViewController alloc] init];
    //_logViewController.principalController = self;
    
    
    _ControladorNotificaciones = [[ControladorNotificaciones alloc]init];
    _ControladorNotificaciones.ControladorPrincipal = self;
    
    _LoginController = [[LoginController alloc]init];
    _LoginController.controladorPrincipal = self;
    
    _ControladorMapa = [[ControladorMapa alloc] init];
    _ControladorMapa.controladorPrincipal = self;
    
    _CameraController = [[CameraController alloc] init];
    _CameraController.controladorPrincipal = self;
    
    _GalleryController = [[GalleryController alloc] init];
    _GalleryController.controladorPrincipal = self;
    
    _UserSetupController = [[UserSetupController alloc] init];
    _UserSetupController.controladorPrincipal = self;
    
}

-(void) recuperarEstado{
    //Obtener estado desde base de datos.
    User_Setup_DTO * current=[User_Setup_DAO getUserSetup];
    if (current==nil) //Sino tiene usuario registrado. No existe.
        self.ESTADO_ACTUAL = Consts.SIN_LOGIN;
    else
        self.ESTADO_ACTUAL = Consts.CON_LOGIN;
}

-(void) button1Tap:(UIButton*)sender
{
    NSLog(@"you clicked on button %ld", (long)sender.tag);
    [self mostrarMapa];
    [self createToolbar: _ControladorMapa];
}

-(void) button2Tap:(UIButton*)sender
{
    NSLog(@"you clicked on button %ld", (long)sender.tag);
    [self mostrarCamera];
    [_CameraController visualizacion:YES];
    //[self createToolbar: _CameraController];
}

-(void) button3Tap:(UIButton*)sender
{
    NSLog(@"you clicked on button %ld", (long)sender.tag);
    [self mostrarGallery];
    [self createToolbar: _GalleryController];
}

-(void) button4Tap:(UIButton*)sender
{
    NSLog(@"you clicked on user button %ld", (long)sender.tag);
    
    [self mostrarUserSetup];
    [self createToolbar: _UserSetupController];
    
}

-(void) createToolbar: (UIViewController*) controller
{
    UIImage *buttonMap = [[UIImage imageNamed:@"buttonMap"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *buttonCamera = [[UIImage imageNamed:@"buttonCamera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *buttonGallery = [[UIImage imageNamed:@"buttonGallery"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *buttonUser = [[UIImage imageNamed:@"buttonUser"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithImage:buttonMap style:UIBarButtonItemStylePlain target:self action:@selector(button1Tap:)];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithImage:buttonCamera style:UIBarButtonItemStylePlain target:self action:@selector(button2Tap:)];
    UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithImage:buttonGallery style:UIBarButtonItemStylePlain target:self action:@selector(button3Tap:)];
    UIBarButtonItem *button4 = [[UIBarButtonItem alloc] initWithImage:buttonUser style:UIBarButtonItemStylePlain target:self action:@selector(button4Tap:)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.navigationController setToolbarHidden:NO];
    
    controller.toolbarItems = [NSArray arrayWithObjects:button1, flexibleItem, button2, flexibleItem, button3, flexibleItem, button4, nil];
}

- (void) iniciaNavigationDrawer: (UIViewController*) controller {
    
    
    UINavigationController *mNavigationController = [[UINavigationController alloc]initWithRootViewController:controller];
    mNavigationController.navigationBar.barTintColor = [UIColor whiteColor];
    mNavigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    mNavigationController.navigationBar.translucent = NO;
    [mNavigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    mNavigationController.navigationBar.topItem.title=@"HereApp";
    mNavigationController.navigationBar.tintColor = [UIColor blackColor];
    
    _navigationController = mNavigationController;
    self.ventanaPrincipal.rootViewController=_navigationController;
    //[self.ventanaPrincipal makeKeyAndVisible];
    
}

-(void) refrescarPantalla{
    
    if (self.ESTADO_ACTUAL==Consts.SIN_LOGIN){
        [self mostrarLogin];
    }
    else {
        [self iniciaNavigationDrawer: _ControladorMapa];
        [self createToolbar: _ControladorMapa];
        
        return;
    }
    
}

-(void) mostrarUserSetup {
    
    [self refrescarViewControllers];
    
    if(![self.navigationController.topViewController isKindOfClass:[_UserSetupController class]]) {
        [self.navigationController pushViewController:_UserSetupController animated:true];
    }
    
}

- (void) mostrarGallery {
    
    [self refrescarViewControllers];
    
    if(![self.navigationController.topViewController isKindOfClass:[_GalleryController class]]) {
        [self.navigationController pushViewController:_GalleryController animated:true];
    }
}

- (void) mostrarCamera {
    
    [self refrescarViewControllers];
    
    if(![self.navigationController.topViewController isKindOfClass:[_CameraController class]]) {
        [self.navigationController pushViewController:_CameraController animated:true];
    }
    
    [self.navigationController setToolbarHidden:YES];
}

- (void) mostrarMapa {
    
    [self refrescarViewControllers];
    
    if(![self.navigationController.topViewController isKindOfClass:[_ControladorMapa class]]) {
        [self.navigationController pushViewController:_ControladorMapa animated:true];
    }
    
    //[_ControladorMapa viewDidLoad];
}

- (void) mostrarLogin {
    
    LoginController *lgc = [[LoginController alloc]init];
    lgc.controladorPrincipal = self;
    self.ventanaPrincipal.rootViewController = lgc;
    
    [self.ventanaPrincipal makeKeyAndVisible];
}

-(void) refrescarViewControllers {
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    if(allViewControllers.count > 1)
        [allViewControllers removeLastObject];
    
    self.navigationController.viewControllers = allViewControllers;
}

@end
