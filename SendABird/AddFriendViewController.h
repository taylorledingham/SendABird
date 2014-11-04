//
//  AddFriendViewController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddFriendViewController : UITableViewController<UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) NSArray *visibleUsers;
@property (nonatomic, strong) PFUser *currentUser;

@end
