//
//  InboxDetailViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "InboxDetailViewController.h"
#import "GotPictureViewController.h"

@interface InboxDetailViewController ()

@end

@implementation InboxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *mySentDate = self.message[@"dateSent"];
    NSDate *myRecDate = self.message[@"dateRecieved"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM.dd.yyyy (HH:mm:ss ZZZZZZ)"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *stringFromSentDate = [formatter stringFromDate:mySentDate];
    NSString *stringFromRecDate = [formatter stringFromDate:myRecDate];
    PFUser *sender = self.message[@"sender"];
    PFObject *bird = self.message[@"typeOfSender"];
    [self updateSender:sender];
    [self updateTypeOfSender:bird];
    self.dateSentLabel.text = stringFromSentDate;
    self.dateRecievedLabel.text = stringFromRecDate;
    [self.messageTextView setEditable:NO];
    self.messageTextView.text = self.message[@"message"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateSender:(PFUser *)sender {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:sender.objectId];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            PFUser *userSender = objects.firstObject;
            NSString *senderName = userSender.username;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.senderLabel.text = senderName;
                self.testLabel.text = senderName;
            });
        }
    }];

}

-(void)updateTypeOfSender:(PFObject *)bird {
    PFQuery *query = [PFQuery queryWithClassName:@"Bird"];
    [query whereKey:@"objectId" equalTo:bird.objectId];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            PFObject *birdObject = objects.firstObject;
            NSString *birdName = birdObject[@"name"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.typeOfSenderLabel.text = birdName;
            });
        }
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"SeePic"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        GotPictureViewController *gotPicViewController = (GotPictureViewController *)[navigationController topViewController];
        gotPicViewController.message = self.message;
    }
}

- (IBAction)goBack:(id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
