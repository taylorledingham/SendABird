//
//  BirdTableViewController.m
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "BirdTableViewController.h"

@interface BirdTableViewController ()

@property (strong, nonatomic) NSMutableArray *birdArray;

@end

@implementation BirdTableViewController {
    NSIndexPath *lastSelectedPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.birdArray = [[NSMutableArray alloc]init];
    [self loadBirdArrayData];
    
    
}

-(void)loadBirdArrayData {

    PFQuery *query = [PFQuery queryWithClassName:@"Bird"];
    //[query whereKey:@"username" equalTo:@"Bobby"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error){
            
            NSLog(@"%@", error);
        }
        else {
            
          //  self.birdArray = objects;
            [self createBirdArray:objects];
            [self.tableView reloadData];
            
        }
        
        
    }];

    
}

-(void) createBirdArray:(NSArray *)objects {
    
    for (PFObject *obj in objects) {
        
        PFObject *bird = [PFObject objectWithClassName:@"Bird"];
        bird = obj;
        BirdCarrier *myBird = [[BirdCarrier alloc]init];
        myBird.name = bird[@"name"];
        myBird.speed = [bird[@"speed"] doubleValue];
        myBird.birdImage = [self getImageforBirdName:myBird.name];
        [self.birdArray addObject:myBird];
        
    }
    
}

-(UIImage *)getImageforBirdName:(NSString *)birdName {
    
    UIImage *pinImage;
    if ([birdName isEqual:@"Raven"]){
        pinImage = [UIImage imageNamed:@"ravenIcon"];
    }
    else if ([birdName isEqual:@"Pigeon"]){
        pinImage = [UIImage imageNamed:@"pigeonIcon"];
    }
    else if ([birdName isEqual:@"Goose"]){
        pinImage = [UIImage imageNamed:@"gooseIcon"];
    }
    else if ([birdName isEqual:@"Falcon"]){
        pinImage = [UIImage imageNamed:@"falconIcon"];
    }
    else {
        
        pinImage = [UIImage imageNamed:@"owlIcon"];
        
    }
    
    
    return pinImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.birdArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    BirdCarrier *bird = [self.birdArray objectAtIndex:indexPath.row]
    ;
    cell.textLabel.text = bird.name;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(lastSelectedPath != nil){
    UITableViewCell *cellLastChecked = [tableView cellForRowAtIndexPath:lastSelectedPath];
        cellLastChecked.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    BirdCarrier *bird = [self.birdArray objectAtIndex:indexPath.row];
    [self.delegate fetchNewBird:bird];

    lastSelectedPath = indexPath;
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
