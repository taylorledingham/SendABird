//
//  SentViewController.h
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "SentMessageTableViewCell.h"

@interface SentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSegmentControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)segmentViewChanged:(UISegmentedControl *)sender;

@end
