//
//  NAYNetworkController.h
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAYGitUser.h"

@interface NAYNetworkController : NSObject <NSURLSessionDataDelegate>

+ (NAYNetworkController *)sharedController;

- (void)reposForSearchString:(NSString *)searchString;
- (void)usersForSearchString:(NSString *)searchString;
- (void)downloadImageDataWithUrl:(NSURL *)imageUrl forUser:(NAYGitUser *)user withCompletionBlock:(void (^)(UIImage *image))blockName;

@property (nonatomic) NSFetchedResultsController *fetchedResultsControllerRepos;
@property (nonatomic) NSFetchedResultsController *fetchedResultsControllerUsers;


@end
