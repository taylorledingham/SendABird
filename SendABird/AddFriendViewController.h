//
//  AddFriendViewController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-02.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendViewController : UITableViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) NSArray *visibleUsers;

@end
