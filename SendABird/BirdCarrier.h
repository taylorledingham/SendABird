//
//  BirdCarrier.h
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BirdCarrier : NSObject

@property (strong, nonatomic)NSString *name;
@property (nonatomic) double speed;
@property (nonatomic, strong) UIImage *birdImage;

-(double)getDistanceOverTime:(double)hours;

@end
