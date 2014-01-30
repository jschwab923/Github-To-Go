//
//  NAYUserCollectionViewCell.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/28/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYUserCollectionViewCell.h"

@implementation NAYUserCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}




- (void)drawRect:(CGRect)rect
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 20;
    
}


@end
