//
//  LoginViewController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ParseFacebookUtils/PFFacebookUtils.h"
#import "CommsLogin.h"


@interface LoginViewController : UIViewController <FBLoginViewDelegate, CommsDelegate >
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) CommsLogin *commsLogin;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;

- (IBAction)login:(id)sender;
- (IBAction)facbebookLogin:(id)sender;

@end
