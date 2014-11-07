//
//  EditProfileViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "EditProfileViewController.h"
#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"

@interface EditProfileViewController (){
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    float oldX;
}


@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //*****have to add any changes to viewWillAppear - viewDidLoad never gets called if you log out and log in as a different person.
    //also have to reset currentUser within viewWillAppear, otherwise self.currentUser will be the previously logged out user.
    self.currentUser = [PFUser currentUser];
    NSLog(@"Current user in Profile: %@", self.currentUser.username);
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.emailField.delegate = self;
    
    if (self.currentUser !=nil) {
        self.usernameField.text = self.currentUser.username;
        self.passwordField.text = self.currentUser.password;
        self.emailField.text = self.currentUser.email;
        
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if (self.currentUser[@"lastLocation"]==nil) {
            [_locationManager startUpdatingLocation];
            [self getLocation];
        } else {
            [self getLocation];
        }
        
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Location Services

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations firstObject];
    CLLocationCoordinate2D coordinate = [currentLocation coordinate];
    PFGeoPoint *setGeopoint = [[PFGeoPoint alloc] init];
    setGeopoint.latitude = coordinate.latitude;
    setGeopoint.longitude = coordinate.longitude;
    NSLog(@"The coordinates are: %f, %f", setGeopoint.latitude, setGeopoint.longitude);
    
    [self.currentUser setObject:setGeopoint forKey:@"lastLocation"];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            NSLog(@"Your location has been updated!");
//            PFGeoPoint *myGeopoint = [self.currentUser objectForKey:@"lastLocation"];
//            [self reverseGeocodeLocation:myGeopoint];
            [self getLocation];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
    }];

    [manager stopUpdatingLocation];
}

- (void)reverseGeocodeLocation:(PFGeoPoint *)geopoint {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:geopoint.latitude longitude:geopoint.longitude];
    [geoCoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks) {
            for (CLPlacemark * placemark in placemarks) {
                self.myAddress = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
                self.locationText.text = self.myAddress;
            }
        }
    }];
}

#pragma mark - IBActions
    
- (IBAction)save:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length]==0 || [password length]==0 || [email length]==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a valid username, password and email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    } else {
        
        self.currentUser.username = username;
        self.currentUser.password = password;
        self.currentUser.email = email;
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Your profile has been updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
                
            } else {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
}

- (void)getLocation {
    PFGeoPoint *myGeopoint = [self.currentUser objectForKey:@"lastLocation"];
    [self reverseGeocodeLocation:myGeopoint];
}

- (IBAction)updateLocation:(id)sender {
//    _locationManager = [[CLLocationManager alloc] init];
//    [_locationManager requestWhenInUseAuthorization];
//    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingLocation];
    [self getLocation];
    
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser]; // this will now be nil
    NSLog(@"Current logged out user: %@", currentUser.username);
    
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
}
- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [aScrollView setContentOffset: CGPointMake(oldX, aScrollView.contentOffset.y)];
}
    
@end
