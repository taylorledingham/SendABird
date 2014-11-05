//
//  InboxDetailViewController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InboxDetailViewController : UITableViewController
- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) PFObject *message;

@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfSenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateSentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateRecievedLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;


@end
