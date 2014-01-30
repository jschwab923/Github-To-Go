//
//  NAYNetworkController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYNetworkController.h"
#import "NAYGitUser.h"

@interface NAYNetworkController ()

@end

@implementation NAYNetworkController

+ (NAYNetworkController *)sharedController
{
    static NAYNetworkController *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    
    return sharedController;
}

- (NSArray *)reposForSearchString:(NSString *)searchString
{
    return [self searchForString:searchString type:@"repositories"];
}

- (NSArray *)usersForSearchString:(NSString *)searchString
{
    return [self searchForString:searchString type:@"users"];
}

- (NSArray *)searchForString:(NSString *)searchString type:(NSString *)type
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/%@?q=%@", type, searchString];
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *searchURL = [NSURL URLWithString:searchString];
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    
    NSError *error;
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    return searchDictionary[@"items"];
}

- (void)downloadImageDataWithUrl:(NSURL *)imageUrl forUser:(NAYGitUser *)user
{
    __block UIImage *downloadedImage;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
   
    NSURLSessionDataTask *imageDataTask = [urlSession dataTaskWithURL:imageUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            downloadedImage = [UIImage imageWithData:data];
            user.userImage = downloadedImage;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_IMAGE_SET object:nil userInfo:@{USER_KEY:user}];
            }];
        } else {
            NSLog(@"%@", error);
        }
    }];
    [imageDataTask resume];
}
@end
