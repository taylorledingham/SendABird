//
//  InboxViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>

@interface InboxViewController ()

@property (strong, nonatomic) NSMutableArray *messageArray;
@property (strong, nonatomic) NSMutableArray *recievedMessagesArray;

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    self.messageArray = [[NSMutableArray alloc]init];
    self.recievedMessagesArray = [[NSMutableArray alloc]init];
    
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser==nil) {
    //no one is logged in, go to login page
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    } else {
    //if CurrentUser is logged in
        NSLog(@"Current user: %@", currentUser.username);
    }
    
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
        [self performSegueWithIdentifier:@"showLogin" sender:self];
        
    } else {
        //if CurrentUser is logged in
        NSLog(@"Current user: %@", currentUser.username);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkForNewMessages {
    
    NSPredicate *messageDatePredicate = [NSPredicate predicateWithFormat:
                              @"dateRecieved <= '%@'", [NSDate date]];
    PFQuery *query = [PFQuery queryWithClassName:@"Message" predicate:messageDatePredicate];
    [query whereKey:@"reciever" equalTo:[PFUser currentUser]];
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


//if go to login page, don't want tabs to be accessible
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *message = [self.recievedMessagesArray objectAtIndex:indexPath.row];
    PFObject *reciever = message[@"reciever"];
    cell.textLabel.text = reciever[@"name"];
    
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self checkForNewMessages];

    
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
