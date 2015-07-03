//
//  Tweet.h
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/6/29.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;


@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *idStr;
@property int favorite_count;
@property (nonatomic, strong) NSString *displayDate;
@property int favorited;
@property (nonatomic, strong) NSDictionary *rawDict;


- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)tweetsWithArray: (NSArray *)array;

@end
