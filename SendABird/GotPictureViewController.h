//
//  GotPictureViewController.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-05.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GotPictureViewController : UIViewController

@property (strong, nonatomic) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *picView;

- (IBAction)goBack:(id)sender;

@end
