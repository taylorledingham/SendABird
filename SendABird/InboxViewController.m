//
//  InboxViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "InboxMessageCell.h"
#import "BirdCarrier.h"
#import "InboxDetailViewController.h"

@interface InboxViewController ()

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *recievedMessagesArray;

@end

@implementation InboxViewController {
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    self.messageArray = [[NSMutableArray alloc]init];
    self.recievedMessagesArray = [[NSMutableArray alloc]init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];

//    PFUser *currentUser = [PFUser currentUser];
}

-(void)loadMessageArray {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error){
            NSLog(@"%@", error);
        }
        else {
            self.messageArray = [objects mutableCopy];
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser==nil) {
        //no one is logged in, go to login page
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
    } else {
        //if CurrentUser is logged in
       // NSLog(@"Current user: %@", currentUser.username);
        [self loadMessageArray];
        [self checkForNewMessages];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkForNewMessages {
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSDate *date2 = [dateFormatter dateFromString:dateString];
    
    NSPredicate *messageDatePredicate = [NSPredicate predicateWithFormat:
                              @"dateRecieved <= %@", date2];
    PFQuery *query = [PFQuery queryWithClassName:@"Message" predicate:messageDatePredicate];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
    [query includeKey:@"sender"];
    [query includeKey:@"typeOfSender"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            
            NSLog(@"%@", error);
        }
        else {
            
            self.recievedMessagesArray = [objects mutableCopy];
            [self.tableView reloadData];
            
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.recievedMessagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InboxMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxMessageCell" forIndexPath:indexPath];
    PFObject *message = [self.recievedMessagesArray objectAtIndex:indexPath.row];
    NSDate *mySentDate = message[@"dateSent"];
    NSDate *myRecDate = message[@"dateRecieved"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM.dd.yyyy (HH:mm:ss ZZZZZZ)"];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *stringFromSentDate = [formatter stringFromDate:mySentDate];
    NSString *stringFromRecDate = [formatter stringFromDate:myRecDate];
    
    PFUser *sender = message[@"sender"];
    NSString *senderName = sender[@"username"];
    PFObject *bird = message[@"typeOfSender"];
    NSString *birdName = bird[@"name"];
    
    cell.senderLabel.text = senderName;
    cell.typeOfSenderLabel.text = birdName;
    cell.messageLabel.text = message[@"message"];
    cell.dateSentLabel.text = stringFromSentDate;
    cell.dateRecievedLabel.text = stringFromRecDate;
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self checkForNewMessages];

    
}

#pragma mark - Segues

//if go to login page, don't want tabs to be accessible
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    if ([segue.identifier isEqualToString:@"showLogin"]) {
    //        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    //    }
    
    if ([[segue identifier] isEqualToString:@"messageDetail"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        InboxDetailViewController *tableViewController = (InboxDetailViewController *)[navigationController topViewController];
        tableViewController.message = [self.recievedMessagesArray objectAtIndex:indexPath.row];
    }
}



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

@end
