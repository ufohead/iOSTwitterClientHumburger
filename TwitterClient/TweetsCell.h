//
//  TweetsCell.h
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/7/1.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetsCell : UITableViewCell

@property (nonatomic, strong) Tweet * tweet;

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
