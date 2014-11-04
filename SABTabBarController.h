//
//  SABTabBarController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SABTabBarController : UITabBarController <UITabBarControllerDelegate>

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end
