//
//  PrincipalController.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class LogViewController;
@class LoginController;
@class LocationHistoryViewController;
@class BackgroundWorker_Business;
@class ControladorNotificaciones;
@class ControladorGPS;
@class ControladorMapa;
@class CameraController;
@class GalleryController;
@class UserSetupController;
@class NavigationViewController;

@interface PrincipalController : UIViewController <CLLocationManagerDelegate>

typedef enum{
    SIN_LOGIN,
    CON_LOGIN,
    PANTALLA_MAPA
} APPLICATION_STATE;
@property APPLICATION_STATE  ESTADO_ACTUAL;

typedef enum{
    MAPA,
    USER_ACCOUNT,
    PUBLICAR_INFO,
    GALLERY
}SCREEN;

@property UIWindow *ventanaPrincipal;
@property LogViewController * logViewController;
@property ControladorGPS * ControladorGPS;
@property LoginController * LoginController;
@property ControladorMapa * ControladorMapa;
@property CameraController * CameraController;
@property GalleryController * GalleryController;
@property UserSetupController * UserSetupController;
@property LocationHistoryViewController * lh;
@property BackgroundWorker_Business * TrabajadorBackground;
@property ControladorNotificaciones * ControladorNotificaciones;
@property NSNumber * idUsuario;
@property UINavigationController *navigationController;
@property NavigationViewController * navToolBarController;
@property SCREEN PANTALLA_ACTUAL;
@property SCREEN PANTALLA_ANTERIOR;
@property CLLocation* ubicacionActual;
@property CLLocation* ultimaUbicacionConMedios;

-(void) IniciarApp; //Funcion Principal de la APP.
-(void) refrescarPantalla;
-(void) mostrarGallery;
-(void) button3Tap:(UIButton*)sender;

@end
