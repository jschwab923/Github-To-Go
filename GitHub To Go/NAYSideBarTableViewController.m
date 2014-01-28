//
//  NAYSideBarTableViewController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYSidebarTableViewController.h"
#import "NAYRepoContentViewController.h"
#import "UIColor+Crayola.h"

@interface NAYSideBarTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *sidebarTableView;
@property (nonatomic) UIViewController *currentChildViewController;

@property (nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) NSInteger selectedRow;
@property (nonatomic) NSArray *contentViewIDS;

@end

@implementation NAYSideBarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Set default selectedRow to view repo content view on first open
        self.selectedRow = 0;
        // Set up array that contains ids of the storyboard files to load
        // depending on current selectedRow.
        self.contentViewIDS = @[REPO_CONTENT_VIEW_ID, USER_CONTENT_VIEW_ID];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.currentChildViewController) {
        
        self.currentChildViewController = [self.storyboard instantiateViewControllerWithIdentifier:REPO_CONTENT_VIEW_ID];
        
        [self addChildViewController:self.currentChildViewController];
        [self.currentChildViewController .view.layer setShadowOpacity:.5];
        [self.currentChildViewController didMoveToParentViewController:self];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showSidebarWithPan:)];
        
        panGestureRecognizer.delegate = self;
        [self.currentChildViewController.view addGestureRecognizer:panGestureRecognizer];
    }
    
    [self.sidebarTableView setScrollEnabled:NO];
    [self.view addSubview:self.currentChildViewController.view];
}

- (void)showSidebarWithPan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint velocity = [panGesture velocityInView:self.view];
    CGPoint translation = [panGesture translationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (self.currentChildViewController.view.frame.origin.x + translation.x >= 0) {
            if (velocity.x) {
                CGPoint newCenter = CGPointMake(self.currentChildViewController.view.center.x + translation.x, self.currentChildViewController.view.center.y);
                self.currentChildViewController.view.center = newCenter;
            }
        }
    }
    
    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.currentChildViewController.view.frame.origin.x > self.view.frame.size.width / 3) {
            [self openMenu];
        }
        
        if (self.currentChildViewController.view.frame.origin.x <= self.view.frame.size.width / 3) {
            [self closeMenu];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Convenience Methods
- (void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        CGPoint finalCenter = CGPointMake(CGRectGetWidth(self.view.frame) + 50,
                                          self.currentChildViewController.view.center.y);
        self.currentChildViewController.view.center = finalCenter;
    }];
}

- (void)closeMenu
{
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.currentChildViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        
    }];
}


@end
