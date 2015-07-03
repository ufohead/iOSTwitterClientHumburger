//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Ufohead Tseng on 2015/6/29.
//  Copyright (c) 2015年 Ufohead Tseng. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"


NSString * const kTwitterConsumerKey =@"i1FGB5bnYQhI5jEWPNDisXA9X";
NSString * const kTwitterConsumerSecret = @"Z7f5nEQ98vSk5KOTnfJsWtuaFmiBPHWj7DIinMva5soiA6fg3x";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end


@implementation TwitterClient


+(TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl]
                                                  consumerKey:kTwitterConsumerKey
                                               consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
 
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"GET"
                        callbackURL:[NSURL URLWithString:@"ufoheadtc://oauth"]
                              scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                      NSLog(@"got the request token!");
                                                          
                                      NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat: @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                      [[UIApplication sharedApplication] openURL:authURL];
                                                          
                          } failure:^(NSError *error) {
                                      NSLog(@"Failed to get the request token!");
                                      self.loginCompletion(nil, error);
    }];
}


- (void)openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
                           success:^(BDBOAuth1Credential *accessToken) {
                                    NSLog(@"got the access token");
                                    [self.requestSerializer saveAccessToken:accessToken];
                               
                                    [self GET:@"1.1/account/verify_credentials.json"
                                   parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          //NSLog(@"current user: %@", responseObject);
                                          User *user = [[User alloc] initWithDictionary:responseObject];
                                          [User setCurrentUser:user];
                                          NSLog(@"current user: %@", user.name);
                                          self.loginCompletion(user, nil);
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"failed getting current user");
                                        self.loginCompletion(nil, error);
                                   }];
                               
                        } failure:^(NSError *error) {
                            NSLog(@"failed to get the access token!");
                            NSLog(@"error : %@", error);
                            self.loginCompletion(nil, error);
    }];

}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        
        completion(tweets,nil);
        NSLog(@"Get Timeline successful");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];


}

- (void)favorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweetId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

- (void)unfavorite:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", tweetId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

- (void)tweetDetail:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/show/%@.json?include_my_retweet=1", tweetId];
    [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

- (void)deletTweete:(NSString *)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json?include_my_retweet=1", tweetId];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"call %@ failed", url);
        completion(nil, error);
    }];
}

- (void)tweet:(NSString *)text repliesTo:(NSString *)idToBeReplied completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/update.json"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": text}];
    if (idToBeReplied != nil) {
        [params setValue:idToBeReplied forKey:@"in_reply_to_status_id"];
    }
    NSLog(@"TWitterClient on tweet");
    [self POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"raw data is %@", responseObject);
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ERROR] %@ retrieval failed", url);
        completion(nil, error);
    }];
}

@end
