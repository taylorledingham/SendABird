//
//  SABOnboardingViewController.m
//  SendABird
//
//  Created by Taylor Ledingham on 2015-03-29.
//  Copyright (c) 2015 sendabird. All rights reserved.
//

#import "SABOnboardingViewController.h"
#import "SABOnboardingPageViewController.h"


@interface SABOnboardingViewController ()
@property (strong, nonatomic) IBOutlet UIButton *presentLoginView;
@property (strong, nonatomic) IBOutlet UIButton *presentSignUp;
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

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"OnboardingVC"]) {
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
