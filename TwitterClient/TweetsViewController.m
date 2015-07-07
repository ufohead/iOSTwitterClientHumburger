//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/6/30.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetsCell.h"
#import "UIImageView+AFNetworking.h"


@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *Tweets;
@property (nonatomic, strong) NSMutableArray *TweetDictionaries;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.TweetDictionaries = [[NSMutableArray alloc]init];
    self.Tweets = [[NSMutableArray alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetsCell" bundle:nil] forCellReuseIdentifier:@"TweetsCell"];
    self.tableView.estimatedRowHeight = 68.0; // Needed!!!
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    User *user = [User currentUser];
    if ( user != nil) {
        [self.LoginButton setTitle:@"Logout" forState:UIControlStateNormal];
        //self.LoginButton.hidden = YES;
        NSLog(@"Welcome %@", user.name);
        //        self.window.rootViewController =[[TweetsViewController alloc]init];
        
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            
            [self.Tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }];
        
    } else {
        [self.LoginButton setTitle:@"Login" forState:UIControlStateNormal];
        self.ComposeButton.hidden = YES;
        NSLog(@"Not logged in");
        //        self.window.rootViewController = [[LoginViewController alloc]init];
    }
    
    // Do any additional setup after loading the view from its nib.

    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)onLogout:(id)sender {
    
    [User logout];
    //self.LogoutButton.hidden = YES;
    //self.LoginButton.hidden = NO;
    NSLog(@"Logout & Clean!");
    self.Tweets = nil;
    [self.tableView reloadData];
}
*/

- (IBAction)onLogin:(id)sender {
    
    NSString *title = [(UIButton *)sender currentTitle];
    if ([title isEqual: @"Login"]) {
    
        [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
            if (user != nil) {
                //Modally present tweets view
                NSLog(@"Welcome to %@", user.name);
                //[self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
//                self.LoginButton.hidden = NO;
                self.ComposeButton.hidden = NO;
                [self.LoginButton setTitle:@"Logout" forState:UIControlStateNormal];
//                self.LogoutButton.hidden = NO;
                [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
                    NSLog(@"Login & Loading...");
                    [self.Tweets addObjectsFromArray:tweets];
                    [self.tableView reloadData];
                }];
                //[User currentUser]
            } else {
                //Present error view
            }
        }];
        
    }
    else {
        [User logout];
        //self.LogoutButton.hidden = YES;
        //self.LoginButton.hidden = NO;
        self.ComposeButton.hidden = YES;
        [self.LoginButton setTitle:@"Login" forState:UIControlStateNormal];
        NSLog(@"Logout & Clean!");
        self.Tweets = nil;
        [self.tableView reloadData];
    
    }
    

    

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.Tweets.count;
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetsCell"];
    Tweet *twitter = self.Tweets[indexPath.row];
    cell.tweetLabel.text = twitter.text;
    cell.userLabel.text = twitter.user.name;
    NSLog(@"%@", twitter.user.profileImageUrl);
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:twitter.user.profileImageUrl]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    NSString *createdDate = [formatter stringFromDate:twitter.createdAt];
    cell.timeLabel.text = createdDate;
    
    
    
//    cell.tweetLabel = self.Tweets[indexPath.row].text;
    
    
    cell.tweet = self.Tweets[indexPath.row];
    return cell;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        
        NSLog(@"Refresh ...");
        [self.Tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
    [refreshControl endRefreshing];
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
