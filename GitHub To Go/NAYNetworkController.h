//
//  NAYNetworkController.h
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAYNetworkController : NSObject

+ (NAYNetworkController *)sharedController;

- (NSArray *)reposForSearchString:(NSString *)searchString;
- (NSArray *)usersForSearchString:(NSString *)searchString;

@end
