//
//  Media_DTO.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ubicacion_DTO.h"

@interface Media_DTO : NSObject

typedef enum {
    MEDIA_IMAGE,
    MEDIA_AUDIO,
    MEDIA_SIGNATURE}
MEDIA_TYPE;

@property NSInteger idMedio;
@property MEDIA_TYPE type;
@property NSString *urlLocal;
@property NSString *urlFinal;
@property NSString *comentario;
@property BOOL isUploaded;
@property NSInteger idUsuario;

@property Ubicacion_DTO *ubicacion;
@property NSData *data;

@end
