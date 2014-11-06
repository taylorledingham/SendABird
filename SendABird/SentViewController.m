//
//  SentViewController.m
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "SentViewController.h"
#import "MessageMapPin.h"


#define earthsRadius 6371.0

@interface SentViewController ()

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *sentMessagesArray;

@end

@implementation SentViewController {
    
    NSDateFormatter *messageDateFormatter;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.viewSegmentControl.selectedSegmentIndex = 0;
    
    self.tableView.hidden = YES;
    
    messageDateFormatter = [[NSDateFormatter alloc] init];
    [messageDateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];

}

-(void)viewDidAppear:(BOOL)animated {
    [self loadSentMessages];
    self.viewSegmentControl.selectedSegmentIndex = 1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSentMessages {
    
    NSDate *date = [NSDate date];
    NSString *dateString = [messageDateFormatter stringFromDate:date];
    NSDate *date2 = [messageDateFormatter dateFromString:dateString];
    
    
    
    NSPredicate *messageDatePredicate = [NSPredicate predicateWithFormat:@"dateRecieved >= %@", date2];
    PFQuery *query = [PFQuery queryWithClassName:@"Message" predicate:messageDatePredicate];

    
    [query whereKey:@"sender" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error){
            
            NSLog(@"%@", error);
        }
        else {
            
            self.sentMessagesArray = [objects mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];

                
            });
            [self.mapView removeAnnotations:self.mapView.annotations];

            [self addBirdAnnoations];

            
        }
    }];

    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sentMessagesArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    PFObject *message = [self.sentMessagesArray objectAtIndex:indexPath.row];
    PFUser *reciever = message[@"reciever"];
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    [userQuery getObjectInBackgroundWithId:reciever.objectId block:^(PFObject *reciever, NSError *error) {
        if(error){
            NSLog(@"user error: %@", error);
            
        }
        
        cell.textLabel.text =  reciever[@"username"];
        cell.detailTextLabel.text = message[@"message"];
        
    }];

    
    return cell;
    
}


-(CLLocation *)getCLLocationFromPFGeoPoint:(PFGeoPoint *)point {
    CLLocation *location = [[CLLocation alloc]initWithLatitude:point.latitude longitude:point.longitude];
    
    return location;
}

-(CLLocationCoordinate2D)calculateMessageCurrentLocation: (PFObject *)message andBird:(PFObject *)bird{
    PFGeoPoint *senderLoc = message[@"senderLocation"];
    PFGeoPoint *recieverLoc = message[@"recieverLocation"];

        
    double birdSpeed = [bird[@"speed"] doubleValue];
    NSDate *dateSent = message[@"dateSent"];
    
    double distance = [self calculateDistanceTravelledAtVelocity:birdSpeed since:dateSent];
        
      CLLocation *sentLoc = [self getCLLocationFromPFGeoPoint:senderLoc];
      CLLocation *recievedLoc = [self getCLLocationFromPFGeoPoint:recieverLoc];
        
    double bearing = [self getHeadingForDirectionFromCoordinate:sentLoc.coordinate toCoordinate:recievedLoc.coordinate];
    
    return [self coordinateFromCoord:sentLoc.coordinate atDistanceKm:distance atBearingDegrees:bearing];
        
    
    
}

-(double)calculateRemainingTimeToBeDeliveredWithMessage:(PFObject *)message andBird:(PFObject *)bird {
    
    double birdSpeed = [bird[@"speed"] doubleValue];
    
    PFGeoPoint *senderLoc = message[@"senderLocation"];
    PFGeoPoint *recieverLoc = message[@"recieverLocation"];
    
    double distanceInKm = [[self getCLLocationFromPFGeoPoint:senderLoc] distanceFromLocation:[self getCLLocationFromPFGeoPoint:recieverLoc]]/1000;

    double timeRemaining = distanceInKm / birdSpeed;
    
    return timeRemaining;
    
    
}

-(void)addBirdAnnoations {
    
    
    for (PFObject * message in self.sentMessagesArray) {
        
        
            // birdLoc = location;
            
            PFObject *bird = message[@"typeOfSender"];
            PFUser *reciever = message[@"reciever"];


            PFQuery *query = [PFQuery queryWithClassName:@"Bird"];
            PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
            [query getObjectInBackgroundWithId:bird.objectId block:^(PFObject *bird, NSError *error) {
                if(error){
                    NSLog(@"bird error: %@", error);
                }
                else {
                [userQuery getObjectInBackgroundWithId:reciever.objectId block:^(PFObject *reciever, NSError *error) {
                    if(error){
                        NSLog(@"user error: %@", error);

                    }
                    CLLocationCoordinate2D birdLoc =  [self calculateMessageCurrentLocation:message andBird:bird];
                    

                    NSString *recieverName = [NSString stringWithFormat:@"Receiver: %@",reciever[@"username"]];
                    UIImage *image = [UIImage imageNamed:@"birdIcon"];
                    NSString *timeRemaining = [NSString stringWithFormat:@"Time till delivery: %.4f hours", [self calculateRemainingTimeToBeDeliveredWithMessage:message andBird:bird]];
                    NSLog(@" message id : %@", message.objectId);
                    NSLog(@" bird name : %@", bird[@"name"]);
                MessageMapPin *myAnnotation = [[MessageMapPin alloc]initWithCoordinates:birdLoc placeName:recieverName subtitle:timeRemaining andPinImage:image];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:myAnnotation];
                    
                    
                });



                }];
                }
        }];

    }
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //show direction
    
    //MessageMapPin *myAnnotation = (MessageMapPin *)view;
   // MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];

    
}



-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MessageMapPin class]]){
        
        MessageMapPin *myMessage = (MessageMapPin *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"BirdAnnotation"];
        
        if(annotationView == nil){
            annotationView = myMessage.annotationView;
        }
        else
            annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    else {
        return nil;
    }
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    NSLog(@"selected: %@", view.description);
    
    
}

- (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

- (CLLocationCoordinate2D)coordinateFromCoord:
(CLLocationCoordinate2D)fromCoord
                                 atDistanceKm:(double)distanceKm
                             atBearingDegrees:(double)bearingDegrees
{
    double distanceRadians = distanceKm / earthsRadius;
    //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    return result;
}

-(double)calculateDistanceTravelledAtVelocity:(double)velocity since:(NSDate *)time {
    
    NSTimeInterval timeInterval = [time timeIntervalSinceNow];
    double timeInHours = (timeInterval  / 3600)*-1;
    
    return velocity*timeInHours;
    
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = [self radiansFromDegrees:fromLoc.latitude];
    float fLng = [self radiansFromDegrees:fromLoc.longitude];
    float tLat = [self radiansFromDegrees:toLoc.latitude];
    float tLng = [self radiansFromDegrees:toLoc.longitude];
    
    
    float degree = [self degreesFromRadians:atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng))];
    
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)segmentViewChanged:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0){
        self.tableView.hidden = NO;
        self.mapView.hidden = YES;
        
    }
    else {
        self.tableView.hidden = YES;
        self.mapView.hidden = NO;
    }
}
@end
