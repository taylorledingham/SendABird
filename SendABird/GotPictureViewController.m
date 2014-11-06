//
//  GotPictureViewController.m
//  SendABird
//
//  Created by Audrey Jun on 2014-11-05.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import "GotPictureViewController.h"

@interface GotPictureViewController ()

@end

@implementation GotPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.message[@"pic"]) {
        PFFile *picFile = self.message[@"pic"];
        NSData *picData = [picFile getData];
        UIImage *myPic = [UIImage imageWithData:picData];
        self.picView.image = myPic;
    } else {
        self.picView.image = [UIImage imageNamed:@"nopic"];
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

- (IBAction)goBack:(id)sender {
    [self dismissSelf];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
