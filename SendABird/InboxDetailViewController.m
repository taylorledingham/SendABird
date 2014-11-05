//
//  InboxDetailViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "InboxDetailViewController.h"

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
    NSString *senderName = sender[@"username"];
    PFObject *bird = self.message[@"typeOfSender"];
    NSString *birdName = bird[@"name"];
    
    NSLog(@"This is the sender name: %@", senderName);
    
    self.senderLabel.text = senderName;
    self.testLabel.text = senderName;
    self.typeOfSenderLabel.text = birdName;
    self.dateSentLabel.text = stringFromSentDate;
    self.dateRecievedLabel.text = stringFromRecDate;
    [self.messageTextView setEditable:NO];
    self.messageTextView.text = self.message[@"message"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)goBack:(id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
