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

@implementation SentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.viewSegmentControl.selectedSegmentIndex = 0;
    
    self.tableView.hidden = YES;
    
    CLLocation *toronto = [[CLLocation alloc]initWithLatitude:43.6767 longitude:-79.6306];
    toronto = [[CLLocation alloc]initWithLatitude:49.281418 longitude:-123.126480];
    self.locations = [[NSMutableArray alloc]init];
    [self.locations addObject:@"toronto"];
    
    MKPointAnnotation *annotationStart = [[MKPointAnnotation alloc] init];
    annotationStart.coordinate = toronto.coordinate;
    [self.mapView addAnnotation:annotationStart];
    

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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
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
    //NSString *sender = message[@"sender"][@"username"];
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

-(void)calculateMessageCurrentLocation: (PFObject *)message withCompletion:(void (^)(CLLocationCoordinate2D location))completion{
    PFGeoPoint *senderLoc = message[@"senderLocation"];
    PFGeoPoint *recieverLoc = message[@"recieverLocation"];
    
    PFObject *bird = message[@"typeOfSender"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Bird"];
    [query getObjectInBackgroundWithId:bird.objectId block:^(PFObject *bird, NSError *error) {
        //
        NSLog(@"bird.objectId :%@", bird.objectId);
        NSLog(@"bird.updatedAt :%@", bird.updatedAt);
        NSLog(@"bird.createdAt :%@", bird.createdAt);
        NSLog(@"bird speed :%@", bird[@"speed"]);
        NSLog(@"bird.name :%@", bird[@"name"]);
        
        double birdSpeed = [bird[@"speed"] doubleValue];
        NSDate *dateSent = message[@"dateSent"];
        
        //double distance = 0;
        double distance = [self calculateDistanceTravelledAtVelocity:birdSpeed since:dateSent];
        
        CLLocation *sentLoc = [[CLLocation alloc]initWithLatitude:senderLoc.latitude longitude:senderLoc.longitude];
        CLLocation *recievedLoc = [[CLLocation alloc]initWithLatitude:recieverLoc.latitude longitude:recieverLoc.longitude];
        
        double bearing = [self getHeadingForDirectionFromCoordinate:sentLoc.coordinate toCoordinate:recievedLoc.coordinate];
        
        completion([self coordinateFromCoord:sentLoc.coordinate atDistanceKm:distance atBearingDegrees:bearing]);
        
    }];
    
    //double birdSpeed = bird[@"speed"];
    
    
}

-(void)addBirdAnnoations {
    
    
    for (PFObject * message in self.sentMessagesArray) {
        
        
        [self calculateMessageCurrentLocation:message withCompletion:^(CLLocationCoordinate2D location) {
            CLLocationCoordinate2D birdLoc = location;
            
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

                    NSString *recieverName = reciever[@"username"];
                   PFFile *imageFile = bird[@"birdPin"];
                    UIImage *image = [UIImage imageNamed:@"birdIcon"];
                MessageMapPin *myAnnotation = [[MessageMapPin alloc]initWithCoordinates:birdLoc placeName:recieverName subtitle:nil andPinImage:image];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:myAnnotation];
                    
                    
                });


            //PFUser *reciever = message[@"reciever"];
   
//            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//    
//                if(error){
//                    NSLog(@"%@", error);
//                }
//                else {
//                    UIImage *image = [UIImage imageWithData:data];
//                    MessageMapPin *myAnnotation = [[MessageMapPin alloc]initWithCoordinates:birdLoc placeName:recieverName subtitle:nil andPinImage:image];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.mapView addAnnotation:myAnnotation];
//                        
//                        
//                    });
//                }
//            }];


                }];
                }
            }];
        }];

    }
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //show direction
    
    MessageMapPin *myAnnotation = (MessageMapPin *)view;
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
    double timeInHours = timeInterval * 60 * 60;
    
    return velocity/timeInHours;
    
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
