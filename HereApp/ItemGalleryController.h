//
//  ItemGalleryController.h
//  HereApp
//
//  Created by Alex Diaz on 1/19/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemGalleryController : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImagen;

@property (weak, nonatomic) IBOutlet UILabel *mUsuario;
@property (weak, nonatomic) IBOutlet UILabel *mFecha;
@property (weak, nonatomic) IBOutlet UITextView *mComentario;
@property (weak, nonatomic) IBOutlet UILabel *mLugar;

@end
