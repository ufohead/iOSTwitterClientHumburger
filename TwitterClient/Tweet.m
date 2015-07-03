//
//  Tweet.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/6/29.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *languageID = [[NSBundle mainBundle] preferredLocalizations].firstObject;
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:languageID]];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.displayDate = [self getTweetCellDisplayTimeStringSince:self.createdAt];
        self.favorite_count = [dictionary[@"favorite_count"] intValue];
        self.idStr = dictionary[@"id_str"];
        self.favorited = [dictionary[@"favorited"] intValue];
        self.rawDict = dictionary;
        
    }
    return self;
}


+ (NSArray *)tweetsWithArray: (NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}


- (NSString *) getTweetCellDisplayTimeStringSince:(NSDate*)date {
    NSString *retString = nil;
    float epoch = [[NSDate date] timeIntervalSinceDate:date];
    int hoursPassed = floor(epoch/3600);
    if (hoursPassed > 23) {
        int daysPassed = floor(hoursPassed/24);
        if (daysPassed > 100) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy/MM/dd";
            retString = [formatter stringFromDate:date];
        } else {
            retString = [NSString stringWithFormat:@"%dd", daysPassed];
        }
    } else {
        if (hoursPassed == 0) {
            retString = [NSString stringWithFormat:@"%dm", (int)floor(epoch/60)];
        } else {
            retString = [NSString stringWithFormat:@"%dh", hoursPassed];
        }
    }
    //NSLog(@"ret display string is %@", date);
    return retString;
}

@end
