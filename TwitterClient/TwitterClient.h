//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/6/29.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+(TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)tweet:(NSString *)text repliesTo:(NSString *)idToBeReplied completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)unfavorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)tweetDetail:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)deletTweete:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
