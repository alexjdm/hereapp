#import "PVAttractionAnnotationView.h"
#import "PVAttractionAnnotation.h"

@implementation PVAttractionAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        PVAttractionAnnotation *attractionAnnotation = self.annotation;
        _tipo = attractionAnnotation.type;
        switch (attractionAnnotation.type) {
                
            
            case ActualLocation:
                //self.image = [UIImage imageNamed:@"user_location"];
                self.image = [UIImage imageNamed:@"person_on_map"];
                break;
            case OldLocation:
                self.image = [UIImage imageNamed:@"user_location"];
                
                break;
            case ProjectLocation:
                self.image = [UIImage imageNamed:@"ic_home"];
                break;
        }
    }
    
    return self;
}

@end