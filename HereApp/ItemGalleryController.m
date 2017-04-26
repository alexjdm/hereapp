//
//  ItemGalleryController.m
//  HereApp
//
//  Created by Alex Diaz on 1/19/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ItemGalleryController.h"

@implementation ItemGalleryController

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
