//
//  ComposeViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "ComposeViewController.h"
#import "BirdTableViewController.h"
#import "SendToFriendTableViewController.h"


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
    
    
    self.messageTextView.delegate = self;
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector( doneSendMessage)];
    self.navigationItem.rightBarButtonItem = sendButton;
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
}

-(void)doneSendMessage {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"objectId == %@", self.reciever.objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"_User" predicate:predicate];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            
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
                    [self schedulePushNotifcationWithUser:reciever AndDate:recievedDate];
                    message[@"dateRecieved"] = recievedDate;
                    message[@"message"] = self.messageTextView.text;
                    [message setObject:[PFUser currentUser] forKey:@"sender"];
                    [message setObject: reciever forKey:@"reciever"];
                    message[@"senderLocation"] = [PFUser currentUser][@"lastLocation"];
                    message[@"recieverLocation"] = reciever[@"lastLocation"];
                    NSDate *myDate = [NSDate date];
                    message[@"dateSent"] = myDate;
                    [message saveInBackground];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }
            }];
            
        }
    }];
    
    
    
    
    
}

-(void)schedulePushNotifcationWithUser:(PFUser *)user AndDate:(NSDate*)myDate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];

    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc]init];
    
    NSString *dateStr =  [dateFormatter stringFromDate:myDate];
    
    NSDate *formattedDate = [dateFormatter dateFromString:dateStr];
    
    // June's code
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"DDXGlvgKOTm6LVrkQseHgKTpnRJLUOex2ZcOB4gj" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [serializer setValue:@"mObK8jJXxchROdulj5z2Re972hYknXJIrcUGzD7u" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    

    NSString *userID = [PFUser currentUser].objectId;
    userID = [NSString stringWithFormat:@"%@%@%@", @"[", userID,@"]"];
    [requestParams setObject:@{@"userId": @{@"$in" : userID }} forKey:@"where"];
       [requestParams setObject: dateStr forKey:@"push_time"];
    [requestParams setObject:@{@"alert":[NSString stringWithFormat:@"%@  push!",[PFUser currentUser].username]} forKey:@"data"];
    //[req setValuesForKeysWithDictionary:requestParams];
    manager.requestSerializer = serializer;
    //
    
    [manager POST:@"https://api.parse.com/1/push" parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"AFHTTPRequestOperation: %@", [operation response]);
        NSLog(@"%@", user.objectId);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"AFHTTPRequestOperation: %@", [operation response]);
        NSLog(@"Error: %@", error);
    }];
    
    
}

//POST \
//>   -H "X-Parse-Application-Id: DDXGlvgKOTm6LVrkQseHgKTpnRJLUOex2ZcOB4gj" \
//>   -H "X-Parse-REST-API-Key: mObK8jJXxchROdulj5z2Re972hYknXJIrcUGzD7u" \
//>   -H "Content-Type: application/json" \
//>   -d '{
//>         "where": {
//    >           "deviceType": "winrt"
//    >         },
//>         "data": {
//    >           "alert": "Your suitcase has been filled with tiny glass!"
//    >         }
//>       }' \
//>   https://api.parse.com/1/push

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
    
    else if ([segue.identifier isEqualToString:@"showFriendsToSendTo"]){
        
        SendToFriendTableViewController *sendFriendTVC = segue.destinationViewController;
        sendFriendTVC.delegate = self;
        sendFriendTVC.currentUser = self.reciever;
        
    }
    
    
}

-(void)fetchMessageReciever:(PFUser *)reciever {
    self.reciever = reciever;
    NSString *username = reciever[@"username"];
    self.senderLabel.text = username;
    [self.tableView reloadData];
}


-(void)fetchNewBird:(BirdCarrier *)bird {
    
    self.bird = bird;
    self.typeOfBirdLabel.text = self.bird.name;
    [self.tableView reloadData];
}

#pragma mark - Picture Actions



- (IBAction)refresh:(id)sender {
    
}
- (IBAction)cameraButtonTapped:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
    } else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    // Show image picker
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
//    [self.imagePicker dismissModalViewControllerAnimated:YES];
    [self.imagePicker dismissViewControllerAnimated:NO completion:nil];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.imagePicker dismissViewControllerAnimated:NO completion:nil];
}

- (void)uploadImage:(NSData *)imageData {
    
}
- (void)setUpImages:(NSArray *)images {
    
}
- (void)buttonTouched:(id)sender {
    
}

- (IBAction)goBack:(id)sender {
    [self dismissSelf];
}

@end
