//
//  AddFriendViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "AddFriendViewController.h"
#import <Parse/Parse.h>
#import "SearchFriendCell.h"

@interface AddFriendViewController ()<UISearchResultsUpdating> {
}
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation AddFriendViewController

//called only once when loaded from storyboard
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
 
    //
    
    self.definesPresentationContext = YES;
    //
    
    self.visibleUsers = nil;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    
    
}

//called whenever open view
- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        } else {
            self.allUsers = objects;
            self.visibleUsers = self.allUsers;

            //need to reload once get data - can only change UI in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];

}

//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [self.searchController.searchBar resignFirstResponder];
//    [self.searchController dismissViewControllerAnimated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.active)
    {
        // do search
        NSString *filterString = searchController.searchBar.text;
        [self filterContentForSearchText:filterString scope:nil];
        
        NSLog(@"user searched for: %@",filterString);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.visibleUsers.count;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSString *filteredSearchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (filteredSearchText.length> 0)
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.username contains[c] %@", filteredSearchText];
        self.visibleUsers = [self.allUsers filteredArrayUsingPredicate:resultPredicate];
    }
    else
    {
        self.visibleUsers = self.allUsers;
    }
    
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchFriendCell";
    SearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        PFUser *user = [self.visibleUsers objectAtIndex:indexPath.row];
        cell.friendLabel.text = user.username;
        NSLog(@"Username: %@", user.username);
    
    return cell;
}

#pragma mark - Table View Delegate

//ikon
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    //get user tapped on:
    PFUser *user = [self.visibleUsers objectAtIndex:indexPath.row];
    [friendsRelation addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error %@, %@", error, [error userInfo]);
        }
    }];
}

//when switch tab, exit out of search controller

/*
 #pragma mark - Property Overrides
 
 - (void)setFilterString:(NSString *)filterString {
 _filterString = filterString;
 
 if (!filterString || filterString.length <= 0) {
 self.visibleResults = self.allResults;
 }
 else {
 NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", filterString];
 self.visibleResults = [self.allResults filteredArrayUsingPredicate:filterPredicate];
 }
 
 [self.tableView reloadData];
 }
 
 #pragma mark - UITableViewDataSource
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return self.visibleResults.count;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AAPLSearchControllerBaseViewControllerTableViewCellIdentifier forIndexPath:indexPath];
 
 cell.textLabel.text = self.visibleResults[indexPath.row];
 
 return cell;
 }
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
