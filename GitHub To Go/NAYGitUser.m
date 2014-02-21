//
//  NAYGitUser.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/28/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYGitUser.h"
#import "NAYNetworkController.h"

@implementation NAYGitUser

- (void)downloadUserImage
{
    [[NAYNetworkController sharedController] downloadImageDataWithUrl:self.imageURL forUser:self];
}

@end
