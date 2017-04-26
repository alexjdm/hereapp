//
//  ClienteHTTP.h
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User_Setup_DTO.h"
#import <UIKit/UIKit.h>
#import "Ubicacion_DTO.h"
#import "Media_DTO.h"

@protocol LoginHttpDelegate <NSObject>
@required
- (void) endUploadTrackProcess:(bool) validacion;
- (void) endLoginCheckProcess:(bool)validacion;
- (void) endCheckData:(NSInteger)hashCode;
@end

@protocol UploadFileHttpDelegate <NSObject>
@required
- (void) endUploadingFile:(NSInteger)idMedio succeded:(bool)validacion withURL:(NSString *)url;
- (void) progressUploadingFile:(NSInteger) progress withId:(NSInteger)idMedio;
@end

@protocol UploadReportHttpDelegat <NSObject>
@required
-(void) endUploadingReport:(BOOL)success idReporte:(NSInteger)idReporte;
@end


@interface ClienteHTTP : NSObject{
    // Delegate to respond back
    // id <LoginHttpDelegate> _delegate;
}

@property (nonatomic,strong) id delegate;

+(User_Setup_DTO*) doLogin:(User_Setup_DTO *) user ;
+(NSString *) createJsonForDataCheck;
-(void)uploadPendingFileToServer:(Media_DTO *)media;
-(void)uploadFileToServer:(Media_DTO *)mData;
+(void) subeBaseDeDatosSincrona;
+(BOOL) upLoadLocationSincrona:(NSMutableArray *) ubicaciones;
+(Media_DTO *) uploadMediaSincrona:(Media_DTO*)media;
+(NSInteger)getDataHash:(User_Setup_DTO *)user;
+(void) DownloadEssentialDataSincrono:(User_Setup_DTO *) user;
+(NSMutableArray *) getUbicaciones:(NSDate*)fechaInicio fechaFin:(NSDate*)fechaFin;
+(void) subirLog:(NSMutableArray *) logs;

@end
