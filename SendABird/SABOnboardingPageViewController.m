//
//  SABOnboardingPageViewController.m
//  SendABird
//
//  Created by Taylor Ledingham on 2015-06-15.
//  Copyright © 2015 sendabird. All rights reserved.
//

#import "SABOnboardingPageViewController.h"

@interface SABOnboardingPageViewController () <UIPageViewControllerDataSource>
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, strong) NSArray *viewControllerIndex;
@end

@implementation SABOnboardingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerIndex = @[@"FirstOnboardingView", @"SecondOnboardingView", @"ThirdOnboardingView"];
    self.index = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (self.index == 0) {
        self.index = self.viewControllerIndex.count - 1;
    } else {
        self.index -= 1;
    }

    return  [self viewControllerForIndex:self.index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (self.index == self.viewControllerIndex.count - 1) {
        self.index = 0;
    } else {
        self.index += 1;
    }
    
    return  [self viewControllerForIndex:self.index];

}

- (UIViewController *)viewControllerForIndex:(NSInteger)index
{
    NSString *storyboardId = [self.viewControllerIndex objectAtIndex:index];
    
    return [[UIStoryboard storyboardWithName:@"Onboarding" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:storyboardId];
}

@end
