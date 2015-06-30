//
//  LoginViewController.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/6/29.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            //Modally present tweets view
            NSLog(@"Welcome to %@", user.name);
            [self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
            //[User currentUser]
        } else {
            //Present error view
        }
    }];
    


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
