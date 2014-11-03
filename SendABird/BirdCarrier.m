//
//  BirdCarrier.m
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "BirdCarrier.h"

@implementation BirdCarrier

-(double)getDistanceOverTime:(double)hours{
    
    double distance = self.speed / hours;
    return distance;
    
}

@end
