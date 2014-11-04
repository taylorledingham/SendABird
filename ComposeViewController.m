//
//  ComposeViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "ComposeViewController.h"
#import "BirdTableViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController {
    UITapGestureRecognizer *tapRecognizer;
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.tableView.delegate = self;
    
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector( doneSendMessage)];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
}

-(void)doneSendMessage {
    
        PFUser *currentUser = [PFUser currentUser];
//        NSString *user2 = @"Bobby";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                                  @"email = 'bobby@mail.com'"];
        PFQuery *query = [PFUser query];
        //PFQuery *query = [PFQuery queryWithClassName:@"User" predicate:predicate];
        //PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"username" equalTo:@"Bobby"];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
                // The find succeeded.
               // NSLog(@"Successfully retrieved %d scores.", objects.count);
                // Do something with the found objects
    
            } else {
                // The find succeeded.
                NSLog(@"Successfully retrieved the object.");
                PFObject *message = [PFObject objectWithClassName:@"Message"];
                PFUser *reciever =  (PFUser *)object;
                PFQuery *birdQuery = [PFQuery queryWithClassName:@"Bird"];
                [birdQuery whereKey:@"name" equalTo:self.bird.name];
                [birdQuery getFirstObjectInBackgroundWithBlock:^(PFObject *bird, NSError *error) {
                if(error){
                    NSLog(@"The get bird request failed.");

                }
                else {
                message[@"typeOfSender"] = bird;
                double distance = [self calculateDistanceBetweenSenderAndReciever:reciever];
                    
                NSDate *recievedDate = [self calculateRecievedDate:[bird[@"speed"] doubleValue]andDistance:distance];
                    message[@"dateRecieved"] = recievedDate;
                message[@"message"] = self.messageTextView.text;
                [message setObject:[PFUser currentUser] forKey:@"sender"];
                [message setObject: reciever forKey:@"reciever"];
                message[@"senderLocation"] = [PFUser currentUser][@"lastLocation"];
                message[@"recieverLocation"] = reciever[@"lastLocation"];
                NSDate *myDate = [NSDate date];
                    message[@"dateSent"] = myDate;
                [message saveInBackground];
                }
                }];
    
            }
        }];

    [self dismissSelf];
    
}


-(double)calculateDistanceBetweenSenderAndReciever:(PFUser *)reciever {
    PFUser *currentUser = [PFUser currentUser];
    
    PFGeoPoint *senderLoc = currentUser[@"lastLocation"];
    PFGeoPoint *recieverLoc = reciever[@"lastLocation"];
    
    CLLocation *senderLocation = [[CLLocation alloc]initWithLatitude:senderLoc.latitude longitude:senderLoc.longitude];
     CLLocation *recieverLocation = [[CLLocation alloc]initWithLatitude:recieverLoc.latitude longitude:recieverLoc.longitude];
    
    double distanceInKm = [senderLocation distanceFromLocation:recieverLocation]/1000;
    
    return distanceInKm;
    
}

-(NSDate *)calculateRecievedDate:(double)speed andDistance:(double)distance {
    
    NSDate *today = [NSDate date];
    
    double timeInHours = distance / speed;
    
   NSTimeInterval secondsInHours = timeInHours * 60 * 60;
    NSDate *dateHoursAhead = [today dateByAddingTimeInterval:secondsInHours];
    
    return dateHoursAhead;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - text field delegates




-(void)textViewDidBeginEditing:(UITextView *)textView {
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    
}


-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.messageTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapRecognizer];
    [self.view endEditing:YES];
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if([segue.identifier isEqual:@"showBirdsToSelect"]){
        
        BirdTableViewController *birdTVC = segue.destinationViewController;
        birdTVC.delegate = self;
        birdTVC.currentBird = self.bird;
        
    }
    
    
}


-(void)fetchNewBird:(BirdCarrier *)bird {
    
    self.bird = bird;
    self.typeOfBirdLabel.text = self.bird.name;
    [self.tableView reloadData];
}

- (IBAction)goBack:(id)sender {
    [self dismissSelf];
}
@end
