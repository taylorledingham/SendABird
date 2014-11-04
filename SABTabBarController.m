//
//  SABTabBarController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "SABTabBarController.h"

@interface SABTabBarController ()

@end

@implementation SABTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    self.delegate = self;

}

//Goes back to Friends view controller not AddFriends view controller if click on Friends tab.
//STRETCH GOAL: figure out how to change UISearchBar not to be in nav, because if cursor is selected in UISearchBar while navigate to diff page, when come back to Friends tab, nav is gone.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController  {
    if (tabBarController.selectedIndex == 1) {
        //YOUR_TAB_INDEX is the index of the tab bar item for which you want to show the rootView controller
        UINavigationController *navController = (UINavigationController*)viewController;
        [navController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
