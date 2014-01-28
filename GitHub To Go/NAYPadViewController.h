//
//  NAYMasterViewController.h
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NAYDetailViewController;

@interface NAYPadViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) NAYDetailViewController *detailViewController;

@end
