//
//  GalleryController.m
//  HereApp
//
//  Created by Alex Diaz on 1/19/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "GalleryController.h"
#import "Media_DTO.h"
#import "Media_DAO.h"
#import "ItemGalleryController.h"
#import "Helpers.h"
#import "User_Setup_DAO.h"

@interface GalleryController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation GalleryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    _mTable.delegate = self;
    _mTable.dataSource = self;
    _mTable.layer.borderWidth = 1;
    _mTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
}

- (void) viewWillAppear:(BOOL)animated{
    [self loadData];
}

- (void)loadData {
    _medios = [Media_DAO getMedios];
    
    
    //Filtro de 50 m a la redonda
    if(_controladorPrincipal.ubicacionActual != nil)
    {
        CLLocationDistance meters;
        NSMutableArray * arrayFotos = [[NSMutableArray alloc] init];
        CLLocation *location;
        for(Media_DTO* medio in _medios)
        {
            location = [[CLLocation alloc] initWithLatitude:[medio.ubicacion.lat floatValue] longitude:[medio.ubicacion.lon floatValue]];
            meters = [_controladorPrincipal.ubicacionActual distanceFromLocation:location];
            if(meters < 50)
                [arrayFotos addObject:medio];
        }
        _medios = arrayFotos;
    }
    
    
    [_mTable reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([_medios count] > 0)
        return [_medios count];
    else
        return 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemGalleryController"];
    NSObject *mObject;
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemGalleryController" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    mObject = _medios[indexPath.row];
    return [self cellWithMedia:(Media_DTO *)mObject forTable:tableView:indexPath.row];
}

-(UITableViewCell *) cellWithMedia:(Media_DTO *) medio forTable:(UITableView *)table :(NSInteger) identificador{
    
    static NSString *simpleTableIdentifier = @"ItemGalleryController";
    ItemGalleryController *cell = (ItemGalleryController *)[table dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemGalleryController" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //[cell.contentView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    //[cell.contentView.layer setBorderWidth:1.0f];
    //[cell.contentView.layer setCornerRadius:5.0f];
    //cell.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //cell.mLugar.text = @"Mall Plaza";
    
    cell.mLugar.text = [NSString stringWithFormat:@"Latitud: %@ | Longitud: %@", medio.ubicacion.lat, medio.ubicacion.lon];
    cell.mComentario.text = medio.comentario;
    cell.mFecha.text = [Helpers dateString2String:medio.ubicacion.fecha_string];
    cell.mUsuario.text = [User_Setup_DAO getUserSetup].nombres;
    
    NSString *path = medio.urlLocal;
    NSArray *namesArray = [path componentsSeparatedByString:@"/"];
    NSString *imageName = [namesArray lastObject];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:getImagePath];
    
    cell.mImagen.image = image;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}


@end
