//
//  NAYGitUser.h
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/28/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAYGitUser : NSObject 

@property (nonatomic) NSString *userName;
@property (nonatomic) NSURL *profileURL;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) UIImage *userImage;

@property (nonatomic) BOOL imageIsDownloaded;

- (void)downloadUserImage;

@end
