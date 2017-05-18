//
//  CameraController.m
//  HereApp
//
//  Created by Alex Diaz on 1/21/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "CameraController.h"
#import "Media_DTO.h"
#import "Media_DAO.h"
#import "Ubicacion_DTO.h"
#import "Ubicacion_DAO.h"
#import "User_Setup_DAO.h"
#import "Helpers.h"

@interface CameraController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@end

@implementation CameraController

static NSInteger const MAX_RESOLUTION = 3000000;

-(void) visualizacion: (bool) value {
    
    _mComment.hidden = value;
    _mAcceptButton.hidden = value;
    _mCancelButton.hidden = value;
    _mPlace.hidden = value;
    _mGPSLocation.hidden = value;
    
    if(value)
    {
       [_mRetryButton setTitle:@"Take photo" forState:UIControlStateNormal];
        UIImage *img = [UIImage imageNamed:@"Camara"];
        _mImage.image = img;
    }
    else
        [_mRetryButton setTitle:@"Retry" forState:UIControlStateNormal];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self visualizacion:YES];
    
    _mComment.delegate = self;
    _mComment.placeholder = @"Write a caption...";
    [_mComment setReturnKeyType:UIReturnKeyDone];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self inicializarGps];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        // Do your stuff here
        [_controladorPrincipal.navigationController setToolbarHidden:NO];
    }
}

-(void)getPhoto{
    
    UIImagePickerController *mImagePicker = [[UIImagePickerController alloc]init];
    mImagePicker.delegate = self;
    mImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:mImagePicker animated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img)
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _mImage.image = img;
    _mGPSLocation.text = [NSString stringWithFormat:@"Latitud: %f - Longitud:%f", _best_location.coordinate.latitude, _best_location.coordinate.longitude];
    
    
    NSInteger nPixels = img.size.height*img.size.width;
    if(nPixels>MAX_RESOLUTION){
        float scale=((float)MAX_RESOLUTION)/nPixels;
        img = [self resizeImage:img toSize:CGSizeMake(img.size.width*scale, img.size.height*scale)];
    }
    
    
    [self visualizacion:NO];
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect: imageRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (IBAction)acceptButtonAction:(id)sender {
    
    NSString *urlLocal =  [self saveImage];
    
    Media_DTO *medio = [[Media_DTO alloc] init];
    medio.urlLocal = urlLocal;
    medio.idUsuario = [[User_Setup_DAO getUserSetup].idUsuario integerValue];
    medio.comentario = _mComment.text;
    medio.isUploaded = 0;
    medio.type = MEDIA_IMAGE;
    
    [Media_DAO insertMedia:medio];
    
    
    NSString *latitud = [NSString stringWithFormat:@"%f", _best_location.coordinate.latitude];
    NSString *longitud = [NSString stringWithFormat:@"%f", _best_location.coordinate.longitude];
    NSString *accuracy = [NSString stringWithFormat:@"%f", _best_location.horizontalAccuracy];

    Ubicacion_DTO *ubi = [[Ubicacion_DTO alloc] init];
    ubi.fecha = [NSDate date];
    ubi.idMedio = [NSNumber numberWithInteger:medio.idMedio];
    ubi.lat = latitud;
    ubi.lon = longitud;
    ubi.gpserror = accuracy;
    
    [Ubicacion_DAO insertUbicacion:ubi];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)retryButtonAction:(id)sender {
    
    [self getPhoto];
}

- (NSString *) saveImage {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"here-%f.%@", CACurrentMediaTime(),@"jpg"]];
    NSData *imageData = UIImagePNGRepresentation(_mImage.image);
    [imageData writeToFile:savedImagePath atomically:NO];
     
    return savedImagePath;
    
}

/*
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
- (IBAction)commentEndEditing:(id)sender {
    [_mComment resignFirstResponder];
}
 */

-(void) inicializarGps{
    
    if ([CLLocationManager locationServicesEnabled]){
        
        if (nil == _locationManager)
            _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.activityType = CLActivityTypeFitness;
        [_locationManager requestAlwaysAuthorization];
        [_locationManager startUpdatingLocation];
    }
    else{
        // [self locationManagerUnavailable];
    }
    
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    _ubicaciones = [[NSMutableArray alloc] initWithArray:locations];
    
    if([locations count] > 0)
    {
        bool primero = false;
        for (CLLocation * l in locations) {
            
            if(primero == false)
            {
                primero = true;
                _best_location = l;
            }
            else {
                if (l.horizontalAccuracy<_best_location.horizontalAccuracy && l.horizontalAccuracy>0)
                    _best_location = l;
            }
            
            CLLocationCoordinate2D myCoordinate = {_best_location.coordinate.latitude, _best_location.coordinate.longitude};
        }
    }
}

@end
