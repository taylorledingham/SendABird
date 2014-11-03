//
//  CommsLogin.h
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseFacebookUtils/PFFacebookUtils.h"
#import <Parse/Parse.h>


@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface CommsLogin : NSObject
+ (void) login:(id<CommsDelegate>)delegate;
@end
