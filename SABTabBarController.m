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

    if (self.selectedViewController == self.viewControllers[0] || self.selectedViewController == self.viewControllers[2] || self.selectedViewController == self.viewControllers[3])
    {
        self.viewControllers[1];
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
