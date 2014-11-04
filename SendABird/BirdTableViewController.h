//
//  BirdTableViewController.h
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BirdCarrier.h"
#import "ComposeViewController.h"

@interface BirdTableViewController : UITableViewController

@property (weak, nonatomic) id <SetBirdProtocol> delegate;
@property (strong, nonatomic) BirdCarrier *currentBird;

@end
