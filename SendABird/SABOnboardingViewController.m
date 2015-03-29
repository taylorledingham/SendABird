//
//  SABOnboardingViewController.m
//  SendABird
//
//  Created by Taylor Ledingham on 2015-03-29.
//  Copyright (c) 2015 sendabird. All rights reserved.
//

#import "SABOnboardingViewController.h"
#import <OnboardingViewController.h>
#import <OnboardingContentViewController.h>

@interface SABOnboardingViewController ()
@property (strong, nonatomic) IBOutlet UIButton *presentLoginView;
@property (strong, nonatomic) IBOutlet UIButton *presentSignUp;
@property (strong, nonatomic) OnboardingViewController *onboardingVC;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSArray *onBoardingContentVCs;

@end

@implementation SABOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
//    [self createOnboardingContentViewController];
//    OnboardingViewController *onboardVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"onboardBackground"] contents:self.onBoardingContentVCs];
//    self.onboardingVC = onboardVC;
//    self.onboardingVC.shouldMaskBackground = NO;
//    [self addChildViewController:onboardVC];
//    [self.view addSubview:onboardVC.view];
//    onboardVC.view.frame = self.containerView.frame;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if([identifier isEqualToString:@"OnboardingVC"]) {
        self.onboardingVC = (OnboardingViewController*)sender;
    }
}

-(void)createOnboardingContentViewController
{
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Page Title" body:@"Page body goes here." image:[UIImage imageNamed:@"ravenIcon1"] buttonText:@"Text For Button" action:^{
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
    }];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Page Title 2 " body:@"Page body goes here 2." image:[UIImage imageNamed:@"owlIcon1"] buttonText:@"Text For Button" action:^{
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
    }];
    
    self.onBoardingContentVCs = @[firstPage, secondPage];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"OnboardingVC"]) {
        self.onboardingVC = (OnboardingViewController*)sender;
    }
}
- (IBAction)displayLoginView:(id)sender
{
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:rootController animated:YES completion:nil];
}

- (IBAction)displaySignupView:(id)sender {
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self presentViewController:rootController animated:YES completion:nil];
}



@end
