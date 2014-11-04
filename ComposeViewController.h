//
//  ComposeViewController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BirdCarrier.h"

@protocol SetBirdProtocol <NSObject>

-(void)fetchNewBird:(BirdCarrier *)bird;

@end

@interface ComposeViewController : UITableViewController <UITableViewDelegate, SetBirdProtocol, UITextViewDelegate>
- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeOfBirdLabel;
@property (strong, nonatomic) BirdCarrier *bird;

@end
