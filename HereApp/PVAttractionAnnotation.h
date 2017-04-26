#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, PVAttractionType) {
    ActualLocation,
    OldLocation,
    ProjectLocation
};

@interface PVAttractionAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *nombre;
@property (nonatomic, copy) NSString *fecha;
@property (nonatomic,copy) NSString *identificador;
@property (nonatomic) PVAttractionType type;

@end
