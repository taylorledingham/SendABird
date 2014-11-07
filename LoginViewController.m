//
//  LoginViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //don't want to be able to go back to inbox when on login page
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        // Present the next view controller without animation
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length]==0 || [password length]==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a valid username and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    } else {
        
        [PFUser logInWithUsernameInBackground:username password:password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                // Go back to inbox page.
//                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                
                                                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                                                
                                                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                                currentInstallation[@"userId"] = user.objectId;
                                                [currentInstallation saveInBackground];
                                                
                                                appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                                                
                                            } else {
                                                // The login failed. Check error to see why.
                                                NSString *errorString = [error userInfo][@"error"];
                                                // Show the errorString somewhere and let the user try again.
                                                
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                
                                                [alertView show];
                                            }
                                        }];
        
    }
}

- (void) commsDidLogin:(BOOL)loggedIn {
    // Re-enable the Login button
    [self.facebookLoginButton setEnabled:YES];
    
    // Stop the activity indicator
    // [_activityLogin stopAnimating];
    
    // Did we login successfully ?
    if (loggedIn) {
        // Seque to the Image Wall
        NSLog(@"fb logged in");
        // Show error alert
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSString *name = userData[@"name"];
                name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                currentInstallation[@"userId"] = [PFUser currentUser].objectId;
                [currentInstallation saveInBackground];
                [[PFUser currentUser] setUsername:name];
                [[PFUser currentUser] setEmail:userData[@"email"]];
                [[PFUser currentUser] saveEventually];
                
               
                
            }
        }];
        
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)facbebookLogin:(id)sender {
    
    [self.facebookLoginButton setEnabled:NO];
    
    [CommsLogin login:self];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
