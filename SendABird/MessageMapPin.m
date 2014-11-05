//
//  MessageMapPin.m
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "MessageMapPin.h"

@implementation MessageMapPin

@synthesize coordinate;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName subtitle:(NSString *)subtitle andPinImage:(UIImage *)pinImage;
{
    self = [super init];
    if (self) {
        
        _title = placeName;
        coordinate = location;
        _subtitle = subtitle;
        _pinImage = pinImage;
        
    }
    return self;
}

-(MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"BirdAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
    annotationView.calloutOffset = CGPointMake(-5, 5);
    [annotationView setImage:self.pinImage];
    
    return annotationView;
    
}

@end
