#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSInteger type;
	NSString *_title;
}

//@property (nonatomic, retain) NSString *title;
@property NSInteger type;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
