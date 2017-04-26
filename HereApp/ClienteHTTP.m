//
//  ClienteHTTP.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ClienteHTTP.h"
#import "AFNetworking.h"
#import "User_Setup_DTO.h"
#import "Helpers.h"
#import "Location_Business.h"
#import "Log_DAO.h"
#import "User_Setup_DAO.h"
#import "User_Setup_DTO.h"
#import "User_Setup_DAO.h"
#import "Ubicacion_DTO.h"
#import "BackgroundWorker_Business.h"
#import "Helpers.h"
#import "Ubicacion_DAO.h"
#import "User_Setup_DAO.h"
#import "ControladorNotificaciones.h"

// Local
//static NSString * const BaseURLString = @"http://localhost.fiddler:49640/xrt2021app.svc/";
//static NSString * const BaseURLString = @"http://192.168.0.122:49640/xrt2021app.svc/";

// Staging
static NSString * const BaseURLString = @"http://a58f0c0b43b14918af3c08e9baae0515.cloudapp.net/xrt2021app.svc/";

// Produccion
//static NSString * const BaseURLString = @"http://apiusgeovic.cloudapp.net/xrt2021app.svc/";

static NSString * const insertShift = @"insertShift/";
static NSString * const insertShift2 = @"insertShift2/";
static NSString * const insertActivity = @"insertActivity/";
static NSString * const subeBD = @"recibirBd/";
static NSString * const getShifts = @"GetWeek/";
static NSString * const UploadFileUrl=@"subeArchivo?nuevo4/";
static NSString * const UploadFileUrl2=@"UploadFile/";
static NSString * const UploadReportUrl=@"AddReporte";
static NSString * const UploadReportUrl2=@"UploadReport/";
static NSString * const UploadReportUrl3=@"UploadReport3/";
static NSString * const AddLocationUrl= @"InsertLocation/";
static NSString * const AddLogsUrl= @"appUsageLog/";
static NSString * const getsupervisedusers=@"GetSupervisedUsers/";
static NSString * const getUbicaciones=@"getUbicaciones/";
static NSString * const getsuperviseduserslocation=@"getsuperviseduserslocation/";
static NSString * const GetScheduledEvents=@"GetScheduledEvents/";
static NSString * const UserLogin=@"UserLogin/";
static NSString * const updateReport = @"updateReport/";


@implementation ClienteHTTP


+(User_Setup_DTO*) doLogin:(User_Setup_DTO *) user {
    
    NSString * PostingUrl=[NSString stringWithFormat:@"%@%@", BaseURLString, UserLogin];
    NSURL *url = [NSURL URLWithString: PostingUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *postString = [ClienteHTTP createJsonForLogin:user];
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op start];
    [op waitUntilFinished];
    User_Setup_DTO *userRet = [[User_Setup_DTO alloc] init];
    
    if([op.response statusCode] == 200)
    {
        
        NSDictionary *responseObject= [[NSDictionary alloc] init];
        responseObject = [NSJSONSerialization JSONObjectWithData:op.responseObject
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
        
        userRet.correo_electronico=[responseObject valueForKey:@"CORREO_ELECTRONICO"] ;
        userRet.apellidos = [responseObject valueForKey:@"APELLIDO"];
        userRet.nombres= [responseObject valueForKey:@"NOMBRE"];
        userRet.idUsuario=[NSNumber numberWithInt:[[responseObject valueForKey:@"ID_USUARIO"]intValue]];
        userRet.password=user.password;
        
        return userRet;
    }
    else {
        if(op.responseObject == nil)
        {
            // Mensaje de Sin conexion a internet
            userRet.msg_feedback_login = @"errorDeRed";
        }
        else if([op.response statusCode] == 401)
        {
            // Mensaje de Credenciales malas
            userRet.msg_feedback_login = @"credencialesMalas";
        }
        else
        {
            
        }
        return userRet;
    }
    
}

+(NSString *) createJsonForDownloadUbicaciones:(NSDate*)fechaInicio fechaFin:(NSDate*)fechaFin{
    
    NSString * jsonString = @"";
    
    User_Setup_DTO * udto = [[User_Setup_DTO alloc] init];
    udto = [User_Setup_DAO getUserSetup];
    
    NSDictionary *infoAenviar;
    infoAenviar = [NSDictionary dictionaryWithObjectsAndKeys:
                   udto.idUsuario, @"USER_ID",
                   [Helpers date2VictoriaString:fechaInicio], @"INITIAL_DATE_STRING",
                   [Helpers date2VictoriaString:fechaFin], @"FINAL_DATE_STRING",
                   nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoAenviar
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return  jsonString;
    
}

+ (NSMutableArray *) getUbicaciones:(NSDate*)fechaInicio fechaFin:(NSDate*)fechaFin{
    
    NSString * PostingUrl=[NSString stringWithFormat:@"%@%@", BaseURLString, getUbicaciones];
    
    NSURL *url = [NSURL URLWithString: PostingUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *postString = [ClienteHTTP createJsonForDownloadUbicaciones: fechaInicio fechaFin:fechaFin ];
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op start];
    [op waitUntilFinished];
    
    NSMutableArray *ubicaciones = [[NSMutableArray alloc] init];
    
    if([op.response statusCode] == 200 &&  [op.responseObject isKindOfClass:[NSNull class]] == false)
    {
        NSDictionary *responseObject= [[NSDictionary alloc] init];
        responseObject = [NSJSONSerialization JSONObjectWithData:op.responseObject
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
        
        //        NSString *devuelta=[op responseString];
        //        NSMutableArray * ubicacionesRecibidas = [responseObject valueForKey:@"ubicaciones"];
        
        
        Ubicacion_DTO * udto;
        for (NSMutableArray *dict in responseObject) {
            
            udto = [[Ubicacion_DTO alloc] init];
            //            [udto setFecha:[dict valueForKey:@"FECHA_UBICACION_APP"]];
            //udto.fecha = [Helpers stringToDateDDMMAAAA:[dict valueForKey:@"FECHA_UBICACION_APP_STRING"]];
            //            udto.fecha = [dict valueForKey:@"FECHA_UBICACION_APP"];
            udto.lat = [dict valueForKey:@"LATITUD_UBICACION_APP"];
            udto.lon = [dict valueForKey:@"LONGITUD_UBICACION_APP"];
            udto.gpserror = [dict valueForKey:@"PRECISION_UBICACION_APP"];
            udto.idUbicacion = [dict valueForKey:@"ID_UBICACION"];
            udto.fecha_string = [dict valueForKey:@"FECHA_UBICACION_APP_STRING"];
            
            [ubicaciones addObject:udto];
            
        }
        
    }
    
    return ubicaciones;
    
}

+(NSString *) createJsonForDownloadData{
    
    NSString * jsonString = @"";
    User_Setup_DTO * udto = [[User_Setup_DTO alloc] init];
    udto = [User_Setup_DAO getUserSetup];
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc]init];
    [contentDictionary setValue:udto.correo_electronico forKey:@"usuario"];
    [contentDictionary setValue:udto.password forKey:@"password"];
    [contentDictionary setValue:@"v1.2Iphone" forKey:@"versionApp"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return  jsonString;
    
}

+ (void) DownloadEssentialDataSincrono:(User_Setup_DTO *) user{
    
    NSString * PostingUrl=[NSString stringWithFormat:@"%@%@", BaseURLString, @"DataUpdate/" ];
    NSURL *url = [NSURL URLWithString: PostingUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *postString = [ClienteHTTP createJsonForDownloadData];
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op start];
    [op waitUntilFinished];
    
    if([op.response statusCode] == 200 &&  [op.responseObject isKindOfClass:[NSNull class]] == false)
    {
        
        NSDictionary *responseObject= [[NSDictionary alloc] init];
        responseObject = [NSJSONSerialization JSONObjectWithData:op.responseObject
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
        NSString *devuelta=[op responseString];
        
        User_Setup_DTO *userRet=[[User_Setup_DTO alloc] init];
        userRet.apellidos = [User_Setup_DAO getUserSetup].apellidos;
        userRet.correo_electronico=  [User_Setup_DAO getUserSetup].correo_electronico;
        userRet.nombres= [User_Setup_DAO getUserSetup].nombres;
        userRet.idUsuario= [User_Setup_DAO getUserSetup].idUsuario;
        userRet.password= [User_Setup_DAO getUserSetup].password;
        userRet.password= [User_Setup_DAO getUserSetup].password;
        
        if([[responseObject valueForKey:@"APELLIDO"] isKindOfClass:[NSNull class]] == false)
            userRet.apellidos = [responseObject valueForKey:@"APELLIDO"];
        
        if([[responseObject valueForKey:@"CORREO_ELECTRONICO"] isKindOfClass:[NSNull class]] == false)
            userRet.correo_electronico= [responseObject valueForKey:@"CORREO_ELECTRONICO"];
        
        if([[responseObject valueForKey:@"NOMBRE"] isKindOfClass:[NSNull class]] == false)
            userRet.nombres= [responseObject valueForKey:@"NOMBRE"];
        
        userRet.idUsuario= [User_Setup_DAO getUserSetup].idUsuario;
        userRet.password= [User_Setup_DAO getUserSetup].password;
        
             //   userRet.ultimo_login=[Helpers getCurrentTime];
        
        [User_Setup_DAO update:userRet];
        //[User_Setup_DAO StoreEssentialData:syncObject:proyectos:tareas];
        
    }
    else{
        
        
        
    }
    
}




+(NSInteger)getDataHash:(User_Setup_DTO *)user{
    
    NSString * PostingUrl=[NSString stringWithFormat:@"%@%@", BaseURLString,@"DataCheck/" ];
    NSURL *url = [NSURL URLWithString: PostingUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *postString = [ClienteHTTP createJsonForDataCheck];
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op start];
    [op waitUntilFinished];
    NSInteger mInt=0;
    if([op.response statusCode] == 200)
    {
        NSString *devuelta=[op responseString];
        mInt=[devuelta integerValue];
        //[[BackgroundWorker_Business sharedInstance] saveNewHashCode:mInt];
        
    }
    else
        if([op.response statusCode] == 401)
        {
            //  [BackgroundWorker_Business sharedInstance].debe_cerrar_sesion = true;
            
        }
        else
        {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CHECKSYNC" object:@(false)];
        }
    
    return mInt;
}
+(void) subirLog:(NSMutableArray *) logs{
    
    
    /*  NSMutableArray *logs=[[NSMutableArray alloc]init];
     
     Log_DTO *ll=[[Log_DTO alloc]init];
     ll.fechaEventoLocal=@"20160615190900";
     ll.correo=@"bossita@geovictoria.com";
     ll.version=@"noseque version";
     
     [logs addObject:ll];
     */
    NSString * PostingUrl=[NSString stringWithFormat:@"%@%@", BaseURLString,AddLogsUrl];
    NSURL *url = [NSURL URLWithString: PostingUrl];
    // NSDictionary * u_dto_i = [ubicaciones objectAtIndex:0];
    // NSDictionary * u_dto_f = [ubicaciones objectAtIndex:[ubicaciones count]-1];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    
    NSString *postString = [ClienteHTTP createJsonFromLogs: logs];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    // NSLog(@"%@",postString);
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op start];
    [op waitUntilFinished];
    
    //NSString * responseString=[op responseString];
    
    if ([[op response] statusCode]==200){
        
        //if ([responseString containsString:@"OK"]){
        //Estamos bien, y marcamos punch como subida.
        //  NSLog(@"Ubicaciones enviadas correctamente %d %d",r_i,r_f);
        [Log_DAO setLogAsUploaded:logs];
    }
    else{
        
        // [Log_business insertarLog:[NSString stringWithFormat:@"error: %@ al subir ubicaciones: %@",responseString,postString]];
    }
    
    
    
}

+(void) subeBaseDeDatosSincrona{
    
    
    NSString * PostingString=[NSString stringWithFormat:@"%@%@", BaseURLString,subeBD ];
    
    NSURL *mUrl= [NSURL URLWithString:PostingString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    NSString *filePath = [Helpers getDatabasePath];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    NSData *postData=[NSData dataWithData:data];
    [request setHTTPBody: postData];
    [request addValue: [[User_Setup_DAO getUserSetup].idUsuario stringValue] forHTTPHeaderField:@"id_usuario"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op start];
    [op waitUntilFinished];
    
    if ([op.response statusCode]==200){
        
        
        //if([BackgroundWorker_Business sharedInstance].debe_cerrar_sesion == true)
        //  [BackgroundWorker_Business sharedInstance].logro_enviar_la_bd = true;
        
    }
    else {
        
        
    }
    
}

-(void)uploadPendingFileToServer:(Media_DTO *)media{
    
    
    NSString * PostingString=[NSString stringWithFormat:@"%@%@", BaseURLString,UploadFileUrl2 ];
    
    NSURL *mUrl= [NSURL URLWithString:PostingString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    NSData *postData=[NSData dataWithData:media.data];
    NSString *tipoArchivo;
    
    if(media.type==MEDIA_IMAGE)tipoArchivo=@"image/jpeg";
    if(media.type==MEDIA_AUDIO)tipoArchivo=@"audio/wav";
    
    NSString *categoria;
    
    //signature
    //image
    //audio
    
    if(media.type==MEDIA_IMAGE){tipoArchivo=@"image/jpeg";categoria=@"image";}
    if(media.type==MEDIA_AUDIO){tipoArchivo=@"audio/wav";categoria=@"audio";}
    if(media.type==MEDIA_SIGNATURE){tipoArchivo=@"image/jpeg";categoria=@"signature";}
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody: postData];
    [request addValue: [@(media.idUsuario) stringValue] forHTTPHeaderField:@"id_usuario"];
    // [request addValue:media.mediaDescription forHTTPHeaderField:@"descripcion"];
    [request addValue:tipoArchivo forHTTPHeaderField:@"tipoarchivo"];
    [request addValue:categoria forHTTPHeaderField:@"categoria"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *fileUrlString=[operation responseString];
        NSArray * mArray=[fileUrlString componentsSeparatedByString:@","];
        //NSString *mString=[mArray[0]stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        //Expresion horrible, ignora todos los caracteres no numericos y los parsea.
        NSNumber *myNumber = [f numberFromString:[[mArray[1] componentsSeparatedByCharactersInSet:
                                                   [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                                  componentsJoinedByString:@""]];
        
        
        //media.idVictoria=[myNumber intValue];
        //VALIDAR LA MEDIA
        
        //[BackgroundWorker_Business ]
        
        //[[BackgroundWorker_Business sharedInstance] defineMedioComoSubido:media :mString :true];
        
        //[Reporte_DAO updateMedia:media :mString :true]
        //[_delegate endUploadingFile:media.idMedio succeded:true withURL:mString];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setTerminoSubirMedias" object:nil];
        NSLog(@"Error: %@", [error localizedDescription]);
        //    [[BackgroundWorker_Business sharedInstance] defineMedioComoPendiente:media];
        //[Reporte_DAO updateMedia:media :@"" :false];
    }];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalbytesWritten,long long totalBytesExpectedToWrite) {
        
        
    }];
    
    [op start];
    
    
}

-(void)uploadFileToServer:(Media_DTO *)media{
    
    
    NSString * PostingString=[NSString stringWithFormat:@"%@%@", BaseURLString,UploadFileUrl2 ];
    
    NSURL *mUrl= [NSURL URLWithString:PostingString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    NSData *postData=[NSData dataWithData:media.data];
    NSString *tipoArchivo;
    
    if(media.type==MEDIA_IMAGE)tipoArchivo=@"image/jpeg";
    if(media.type==MEDIA_AUDIO)tipoArchivo=@"audio/wav";
    
    NSString *categoria;
    
    //signature
    //image
    //audio
    
    if(media.type==MEDIA_IMAGE){tipoArchivo=@"image/jpeg";categoria=@"image";}
    if(media.type==MEDIA_AUDIO){tipoArchivo=@"audio/wav";categoria=@"audio";}
    if(media.type==MEDIA_SIGNATURE){tipoArchivo=@"image/jpeg";categoria=@"signature";}
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody: postData];
    [request addValue: [@(media.idUsuario) stringValue] forHTTPHeaderField:@"id_usuario"];
    [request addValue:tipoArchivo forHTTPHeaderField:@"tipoarchivo"];
    [request addValue:categoria forHTTPHeaderField:@"categoria"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"]; AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *fileUrlString=[operation responseString];
        NSArray * mArray=[fileUrlString componentsSeparatedByString:@","];
        NSString *mString=[mArray[0]stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        //Expresion horrible, ignora todos los caracteres no numericos y los parsea.
        NSNumber *myNumber = [f numberFromString:[[mArray[1] componentsSeparatedByCharactersInSet:
                                                   [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                                  componentsJoinedByString:@""]];
        
        //media.idMedio=[myNumber intValue];
        //media.idVictoria = [myNumber intValue];
        [_delegate endUploadingFile:media.idMedio succeded:true withURL:mString];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [_delegate endUploadingFile:media.idMedio succeded:false withURL:nil];
    }];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalbytesWritten,long long totalBytesExpectedToWrite) {
        int progress=(int)(totalbytesWritten*100/totalBytesExpectedToWrite);
        static int lastProgress;
        if(lastProgress!=progress){
            [_delegate progressUploadingFile:progress withId:media.idMedio];
            lastProgress=progress;
        }
        
    }];
    
    [op start];
    
    
}

+(NSString *) createJsonForLogin:(User_Setup_DTO *) user {
    
    NSDictionary *parameters = @{@"usuario": user.correo_electronico,@"password":user.password,@"versionApp":@"v1.2Iphone"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    NSString *jsonString;
    jsonString = @"";
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+(NSString *) createJsonForDataCheck{
    
    NSString * jsonString = @"";
    User_Setup_DTO * udto = [[User_Setup_DTO alloc] init];
    udto = [User_Setup_DAO getUserSetup];
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc]init];
    [contentDictionary setValue:udto.correo_electronico forKey:@"usuario"];
    [contentDictionary setValue:udto.password forKey:@"password"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return  jsonString;
    
}

+(NSString *) createJsonFromLogs:(NSMutableArray *) logs {
    NSString *jsonString;
    
    NSMutableArray *logArray = [[NSMutableArray alloc] init];
    for (Log_DTO *l in logs){
        NSDictionary *logsDic;
        
        
        NSString * idusuarioSubeLog =[[User_Setup_DAO getUserSetup].idUsuario stringValue];
        NSString * correo=[User_Setup_DAO getUserSetup].correo_electronico;
        l.evento=@"";
        l.version=@"";
        logsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                   [Helpers date2VictoriaString:l.Fecha],@"fechaEventoLocal",
                   correo,@"correo",
                   l.evento,@"evento",
                   l.mensaje,@"mensaje",
                   l.version,@"version",
                   l.bateria,@"bateria",
                   l.permisoubicacion,@"permisoubicacion",
                   idusuarioSubeLog,@"idusuario",
                   nil
                   ];
        
        [logArray addObject:logsDic];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:logArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    
    return jsonString;
    
}



+(NSString *) createJsonFromUbicaciones:(NSMutableArray *) ubicaciones {
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSString *jsonString;
    
    NSMutableArray *ubicacionArray = [[NSMutableArray alloc] init];
    
    NSDictionary *ubicacionDic;
    
    NSString * iduser=[[User_Setup_DAO getUserSetup].idUsuario stringValue];
    for (Ubicacion_DTO * ubicacion in ubicaciones){
        //     NSLog(@"%@",ubicacion.gpserror);
        //     NSLog(@"%@",ubicacion.lat);
        //     NSLog(@"%@",ubicacion.lon);
        
        NSString * versionProveedor= [NSString stringWithFormat:@"iOS: %@ (%@)", appVersionString, appBuildString];
        
        if(ubicacion.gpserror == nil && ubicacion.lat==nil && ubicacion.lon == nil)
        {
            
            ubicacionDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Helpers date2VictoriaString:ubicacion.fecha],@"FECHA_UBICACION_APP_STRING",
                            [NSNull null],@"LATITUD_UBICACION_APP",
                            [NSNull null],@"LONGITUD_UBICACION_APP",
                            ubicacion.idUbicacion,@"idUbicacion",
                            [NSNull null],@"PRECISION_UBICACION_APP",
                            iduser,@"ID_USUARIO",
                            versionProveedor,@"PROVEEDOR_UBICACION_APP",
                            nil
                            // [[User_Setup_DAO getUserSetup].id_usuario stringValue],@"ID_USUARIO",
                            // [NSString stringWithFormat:@"iOS: %@ (%@)", appVersionString, appBuildString],@"PROVEEDOR_UBICACION_APP",
                            ];
        }
        else
        {
            ubicacionDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Helpers date2VictoriaString:ubicacion.fecha],@"FECHA_UBICACION_APP_STRING",
                            ubicacion.lat,@"LATITUD_UBICACION_APP",
                            ubicacion.lon,@"LONGITUD_UBICACION_APP",
                            ubicacion.idUbicacion,@"idUbicacion",
                            ubicacion.gpserror,@"PRECISION_UBICACION_APP",
                            iduser,@"ID_USUARIO",
                            versionProveedor,@"PROVEEDOR_UBICACION_APP",
                            nil
                            // [[User_Setup_DAO getUserSetup].id_usuario stringValue],@"ID_USUARIO",
                            // [NSString stringWithFormat:@"iOS: %@ (%@)", appVersionString, appBuildString],@"PROVEEDOR_UBICACION_APP",
                            ];
        }
        
        
        
        [ubicacionArray addObject:ubicacionDic];
        
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ubicacionArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    return jsonString;
}

+(BOOL) upLoadLocationSincrona:(NSMutableArray *) ubicaciones {
    // return false;
    NSString * PostingUrl=[NSString stringWithFormat:@"%@%@", BaseURLString,AddLocationUrl];
    NSURL *url = [NSURL URLWithString: PostingUrl];
    NSDictionary * u_dto_i = [ubicaciones objectAtIndex:0];
    NSDictionary * u_dto_f = [ubicaciones objectAtIndex:[ubicaciones count]-1];
    
    int r_i = [[u_dto_i valueForKey:@"idUbicacion"] intValue];
    int r_f = [[u_dto_f valueForKey:@"idUbicacion"] intValue];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    
    NSString *postString = [ClienteHTTP createJsonFromUbicaciones: ubicaciones];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    // NSLog(@"%@",postString);
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op start];
    [op waitUntilFinished];
    
    NSString * responseString=[op responseString];
    
    if ([responseString containsString:@"OK"]){
        //Estamos bien, y marcamos punch como subida.
        [Ubicacion_DAO setUbicacionAsUploaded:r_i :r_f];
    }
    else{
        
        [Helpers logToDb:[NSString stringWithFormat:@"error: %@ al subir ubicaciones: %@",responseString,postString] : @"NO EVENT"];
    }
    return true;
    
}

+(Media_DTO *) uploadMediaSincrona:(Media_DTO*)media {
    
    NSString * PostingString=[NSString stringWithFormat:@"%@%@", BaseURLString,UploadFileUrl2 ];
    
    NSURL *mUrl= [NSURL URLWithString:PostingString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mUrl
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:60];
    NSData *postData=[NSData dataWithData:media.data];
    NSString *tipoArchivo;
    
    if(media.type==MEDIA_IMAGE)tipoArchivo=@"image/jpeg";
    if(media.type==MEDIA_AUDIO)tipoArchivo=@"audio/wav";
    
    NSString *categoria;
    
    //signature
    //image
    //audio
    
    if(media.type==MEDIA_IMAGE){tipoArchivo=@"image/jpeg";categoria=@"image";}
    if(media.type==MEDIA_AUDIO){tipoArchivo=@"audio/wav";categoria=@"audio";}
    if(media.type==MEDIA_SIGNATURE){tipoArchivo=@"image/jpeg";categoria=@"signature";}
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody: postData];
    [request addValue: [@(media.idUsuario) stringValue] forHTTPHeaderField:@"id_usuario"];
    [request addValue:tipoArchivo forHTTPHeaderField:@"tipoarchivo"];
    [request addValue:categoria forHTTPHeaderField:@"categoria"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [op start];
    [op waitUntilFinished];
    
    if ([op.response statusCode]==200){
        NSString *fileUrlString=[op responseString];
        NSArray * mArray=[fileUrlString componentsSeparatedByString:@","];
        NSString *mString=[mArray[0]stringByReplacingOccurrencesOfString:@"/" withString:@""];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        //Expresion horrible, ignora todos los caracteres no numericos y los parsea.
        NSNumber *myNumber = [f numberFromString:[[mArray[1] componentsSeparatedByCharactersInSet:
                                                   [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                                  componentsJoinedByString:@""]];
        
        //media.urlVictoria=mString;
        //media.idVictoria=[myNumber intValue];
        NSLog(@"Medio Subido Correctamente");
        return media;
        //  return true;
    }
    else {
        
        //[Helpers logToDb:[NSString stringWithFormat:@"error: %@ al subir media con id: %@", op.responseString,@(media.idProyecto)] : @"NO EVENT"];
        NSLog(@"Falló el subir medios");
        return nil;
    }
    
    
}

@end
