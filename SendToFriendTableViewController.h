//
//  SendToFriendTableViewController.h
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"

@interface SendToFriendTableViewController : UITableViewController

@property (weak, nonatomic) id <SetRecieverProtocol> delegate;

@property (strong, nonatomic) PFUser *currentUser;

@end
