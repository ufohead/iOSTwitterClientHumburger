//
//  Profile.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/7/8.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "Profile.h"

@implementation Profile


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];        
    }
    return self;
}

+ (NSArray *)profileWithArray: (NSArray *)array {
    NSMutableArray *profile = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [profile addObject:[[Profile alloc] initWithDictionary:dictionary]];
    }
    
    return profile;
}


@end
