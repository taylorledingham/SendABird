//
//  ComposeViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    NSString *user2 = @"Bobby";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"email = 'bobby@mail.com'"];
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
            message[@"message"] = @"hello world";
            [message setObject:[PFUser currentUser] forKey:@"sender"];
            [message setObject: reciever forKey:@"reciever"];
           // message[@"Reciept"] = object;
            message[@"dateSent"] = [NSDate date];
            [message saveInBackground];

        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

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
@end
