//
//  SentViewController.m
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "SentViewController.h"

@interface SentViewController ()

@property (nonatomic, strong) NSMutableArray *locations;

@end

@implementation SentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.hidden = YES;
    
    CLLocation *toronto = [[CLLocation alloc]initWithLatitude:43.6767 longitude:-79.6306];
    toronto = [[CLLocation alloc]initWithLatitude:49.281418 longitude:-123.126480];
    self.locations = [[NSMutableArray alloc]init];
    [self.locations addObject:@"toronto"];
    
    MKPointAnnotation *annotationStart = [[MKPointAnnotation alloc] init];
    annotationStart.coordinate = toronto.coordinate;
    [self.mapView addAnnotation:annotationStart];
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
    NSString *loc = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text =  loc;
    
    return cell;
    
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
