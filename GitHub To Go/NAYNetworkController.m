//
//  NAYNetworkController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYNetworkController.h"

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

@end
