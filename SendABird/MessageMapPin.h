//
//  MessageMapPin.h
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MessageMapPin : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) UIImage *pinImage;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName subtitle:(NSString *)subtitle andPinImage:(UIImage *)pinImage;

-(MKAnnotationView *)annotationView;

//New line

@end
