//
//  GalleryController.h
//  HereApp
//
//  Created by Alex Diaz on 1/19/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ViewController.h"
#import "PrincipalController.h"
#import "Media_DTO.h"

@interface GalleryController : ViewController

@property PrincipalController * controladorPrincipal;
@property NSMutableArray *medios;

@property (weak, nonatomic) IBOutlet UITableView *mTable;


@end
