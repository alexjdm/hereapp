//
//  ControladorNotificaciones.m
//  HereApp
//
//  Created by Alex Diaz on 1/11/17.
//  Copyright © 2017 Alex Diaz. All rights reserved.
//

#import "ControladorNotificaciones.h"
#import <UIKit/UIKit.h>
#import "PrincipalController.h"
#import "Helpers.h"

@implementation ControladorNotificaciones


+(void) crearNotificacionNuevaImagen:(NSTimeInterval *) duracion : (NSDate *) fecha_inicio{
    
    NSDate *startDate = fecha_inicio;
    
    NSTimeInterval interval = *duracion;
    NSDate *localFireDate = [startDate dateByAddingTimeInterval:interval];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = localFireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = @"Nueva imagen";
    localNotif.alertTitle = @"Hay una nueva imagen disponible para ver.";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"NuevaImagen" forKey:@"TipoNotificacion"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


+(void) borrarNotificacionNuevaImagen{
    
    [self borrarNotificacion:@"NuevaImagen"];
}


+(void) borrarNotificacion: (NSString *) notificacionStr{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *notificaciones = [app scheduledLocalNotifications];
    for (int i=0; i<[notificaciones count]; i++)
    {
        UILocalNotification* notificacion = [notificaciones objectAtIndex:i];
        if([notificacion.alertBody isEqualToString:[[NSBundle mainBundle] localizedStringForKey:notificacionStr value:@"" table:nil]] == true)
        {
            [app cancelLocalNotification:notificacion];
        }
    }
}

@end
