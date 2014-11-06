//
//  EditProfileViewController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLPlacemark.h>

@interface EditProfileViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>

- (IBAction)logout:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)updateLocation:(id)sender;

@property (nonatomic, strong) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *locationText;

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSString *myAddress;
- (void)reverseGeocodeLocation:(PFGeoPoint *)geopoint;

@end
