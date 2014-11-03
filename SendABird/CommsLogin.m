//
//  CommsLogin.m
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "CommsLogin.h"

@implementation CommsLogin

+ (void) login:(id<CommsDelegate>)delegate
{
    // Basic User information and your friends are part of the standard permissions
    // so there is no reason to ask for additional permissions
    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        // Was login successful ?
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
            } else {
                NSLog(@"An error occurred: %@", error.localizedDescription);
            }
            
            // Callback - login failed
            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                [delegate commsDidLogin:NO];
            }
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");

            } else {
                NSLog(@"User logged in through Facebook!");
            }
            
            // Callback - login successful
            

            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
                [delegate commsDidLogin:YES];
            }
        }
    }];
}

@end
