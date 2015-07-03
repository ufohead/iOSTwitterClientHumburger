//
//  TweetsCell.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/7/1.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "TweetsCell.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"

@implementation TweetsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    //[self.thumbImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
}

@end
