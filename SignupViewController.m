//
//  SignupViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length]==0 || [password length]==0 || [email length]==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a valid username, password and email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;

        
        //create a new user and save it in the backend
        //in block so sign up is done asynchronously - parse background operation
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now - go back to Inbox Page
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                currentInstallation[@"userId"] = newUser.objectId;
                [currentInstallation saveInBackground];
//                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissSelf];
                
            } else {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
    
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end