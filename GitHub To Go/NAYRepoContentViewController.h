//
//  NAYTopPhoneViewController.h
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAYSidebarTableViewController.h"

@interface NAYRepoContentViewController : UIViewController
<UISearchBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end
