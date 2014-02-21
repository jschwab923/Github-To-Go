//
//  NAYUserCollectionViewCell.h
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/28/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAYUserCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
