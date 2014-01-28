//
//  NAYSideBarTableViewController.h
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NAYSideBarTableViewControllerDelegate <NSObject>

- (void)didSelectSidebarItem:(NSString *)title;

@end

@interface NAYSideBarTableViewController : UITableViewController <UIGestureRecognizerDelegate>

@end
