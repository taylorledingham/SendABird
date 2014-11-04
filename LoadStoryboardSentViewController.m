//
//  LoadStoryboardSentViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-03.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "LoadStoryboardSentViewController.h"

@interface LoadStoryboardSentViewController ()

@end

@implementation LoadStoryboardSentViewController{
    UIStoryboard *aStoryBoard;
    UIViewController *defaultScene;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    aStoryBoard = [UIStoryboard storyboardWithName:@"SentStoryboard" bundle:nil];
    defaultScene = [[aStoryBoard instantiateInitialViewController] topViewController]; // This will instatiate the first scene in the storyboard.
    // If you want to load some other scene then you must profide the name of the scene as an identifer like this:
    //EditProfileViewController *aNamedScene = [aStoryBoard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    
    // push the scene onto the navigation stack or wherever you want it on the stack
    [self.navigationController setViewControllers:@[defaultScene]];
    
    // Do any additional setup after loading the view.
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
