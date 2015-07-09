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
#import "User.h"
#import "TwitterClient.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"

@interface ContainViewController ()


@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetsButton;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *ImageGesture;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDesc;

@property (strong, nonatomic) TweetsViewController *tweetsVC;
@property (strong, nonatomic) ProfileViewController *profileVC;
@property (strong, nonatomic) PushViewController *pushVC;
@end

@implementation ContainViewController

BOOL menuStatus;
static int Width = 300;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TwitterClient" bundle:nil];
    self.tweetsVC = [storyboard instantiateViewControllerWithIdentifier:@"tweetsVC"];
    self.profileVC = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    self.pushVC = [storyboard instantiateViewControllerWithIdentifier:@"pushVC"];
    //menuStatus = true;
    //[self switchMenu:nil];
    
    [[TwitterClient sharedInstance] userTimelineWithParams:nil completion:^(NSArray *profiles, NSError *error) {
        //NSLog(@"%@",profiles);
        
        Profile *MyProfile = profiles[0];
        self.userName.text = [NSString stringWithFormat:@"%@", MyProfile.user.screenName];
        self.userDesc.text = [NSString stringWithFormat:@"%@", MyProfile.user.tagline];
        [self.userImage setImageWithURL:[NSURL URLWithString:MyProfile.user.profileImageUrl]];

//        self.TweetsCount.text = [NSString stringWithFormat:@"%@", MyProfile.user.statuses_count];
//        self.FollowersCount.text = [NSString stringWithFormat:@"%@", MyProfile.user.followers_count];
//        self.FollowingCount.text = [NSString stringWithFormat:@"%@", MyProfile.user.friends_count];
//        self.ScreenName.text = [NSString stringWithFormat:@"%@", MyProfile.user.screenName];
//        [self.UserImage setImageWithURL:[NSURL URLWithString:MyProfile.user.profileImageUrl]];
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapButton:(id)sender {
    if (sender == self.profileButton || sender == self.ImageGesture) {
        [self displayViewController:self.profileVC];
        
    }
    if (sender == self.tweetsButton) {
        [self displayViewController:self.tweetsVC];
    }
    if (sender == self.pushButton) {
        [self displayViewController:self.pushVC];
    }
    [self switchMenu:sender];
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
