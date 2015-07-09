//
//  Profile.h
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/7/8.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface Profile : NSObject
@property (nonatomic, strong) User *user;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)profileWithArray: (NSArray *)array;


@end
