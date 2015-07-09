//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/7/7.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *TweetsCount;
@property (weak, nonatomic) IBOutlet UILabel *FollowingCount;
@property (weak, nonatomic) IBOutlet UILabel *FollowersCount;
//@property (nonatomic, strong) Profile *MyProfile;
//@property (nonatomic, strong) NSMutableArray *Profiles;
@property (weak, nonatomic) IBOutlet UILabel *ScreenName;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.Profiles = [[NSMutableArray alloc] init];

    User *user = [User currentUser];
    if ( user != nil) {

        [[TwitterClient sharedInstance] userTimelineWithParams:nil completion:^(NSArray *profiles, NSError *error) {
            //NSLog(@"%@",profiles);
            
            Profile *MyProfile = profiles[0];
            
            self.TweetsCount.text = [NSString stringWithFormat:@"%@", MyProfile.user.statuses_count];
            self.FollowersCount.text = [NSString stringWithFormat:@"%@", MyProfile.user.followers_count];
            self.FollowingCount.text = [NSString stringWithFormat:@"%@", MyProfile.user.friends_count];
            self.ScreenName.text = [NSString stringWithFormat:@"%@", MyProfile.user.screenName];
            [self.UserImage setImageWithURL:[NSURL URLWithString:MyProfile.user.profileImageUrl]];
            
        }];
        
        
    } else {
        NSLog(@"Not logged in");

    }
    
    
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
