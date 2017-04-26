#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CalloutMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSString *title;
    NSString *nombre;
    NSString *fecha;
    NSString *identificador;
    NSInteger type;
}

//@property (nonatomic, retain) NSString *title;
@property NSInteger type;

@property (nonatomic, copy) NSString *nombre;
@property (nonatomic, copy) NSString *fecha;
@property (nonatomic,copy) NSString *identificador;


@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
