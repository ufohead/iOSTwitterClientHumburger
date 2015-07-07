//
//  ContainViewController.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/7/7.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "ContainViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "PushViewController.h"

@interface ContainViewController ()


@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetsButton;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *containView;


@property (strong, nonatomic) TweetsViewController *tweetsVC;
@property (strong, nonatomic) ProfileViewController *profileVC;
@property (strong, nonatomic) PushViewController *pushVC;
@end

@implementation ContainViewController

BOOL menuStatus;
static int Width = 400;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TwitterClient" bundle:nil];
    self.tweetsVC = [storyboard instantiateViewControllerWithIdentifier:@"tweetsVC"];
    self.profileVC = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    self.pushVC = [storyboard instantiateViewControllerWithIdentifier:@"pushVC"];
    menuStatus = false;
    [self switchMenu:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapButton:(id)sender {
    if (sender == self.profileButton) {
        [self displayViewController:self.profileVC];
    }
    if (sender == self.tweetsButton) {
        [self displayViewController:self.tweetsVC];
    }
    if (sender == self.pushButton) {
        [self displayViewController:self.pushVC];
    }
}

- (void)displayViewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    viewController.view.frame = self.containView.bounds;
    [self.containView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void) enableButtons {
    self.profileButton.userInteractionEnabled = YES;
    self.tweetsButton.userInteractionEnabled = YES;
    self.pushButton.userInteractionEnabled = YES;
}

- (void) disableButtons {
    self.profileButton.userInteractionEnabled = NO;
    self.tweetsButton.userInteractionEnabled = NO;
    self.pushButton.userInteractionEnabled = NO;
}

- (IBAction)switchMenu:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (menuStatus == false) {
            NSLog(@"Show hamburger!");
            self.menuView.center = CGPointMake(self.menuView.center.x+Width, self.menuView.center.y);
            menuStatus = true;
            [self enableButtons];
        }
        else {
            NSLog(@"No Show hamburger!");
            self.menuView.center = CGPointMake(self.menuView.center.x-Width, self.menuView.center.y);
            menuStatus = false;
            [self disableButtons];
        }
    }];
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
