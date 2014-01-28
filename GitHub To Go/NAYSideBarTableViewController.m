//
//  NAYSideBarTableViewController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYSidebarTableViewController.h"
#import "NAYPhoneContentViewController.h"
#import "UIColor+Crayola.h"

@interface NAYSideBarTableViewController ()

@property (nonatomic) NAYPhoneContentViewController *contentViewController;
@property (unsafe_unretained) id <NAYSideBarTableViewControllerDelegate> delegate;

@end

@implementation NAYSideBarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:CONTENT_VIEW_ID];
    [self addChildViewController:self.contentViewController];
    
    self.delegate = self.contentViewController;
    [self.view addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showSidebarWithPan:)];
    
    panGestureRecognizer.delegate = self;
    [self.contentViewController.view addGestureRecognizer:panGestureRecognizer];
}

- (void)showSidebarWithPan:(UIPanGestureRecognizer *)panGesture
{
    CGPoint velocity = [panGesture velocityInView:self.view];
    CGPoint translation = [panGesture translationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (self.contentViewController.view.frame.origin.x + translation.x >= 0) {
            if (velocity.x) {
                CGPoint newCenter = CGPointMake(self.contentViewController.view.center.x + translation.x, self.contentViewController.view.center.y);
                self.contentViewController.view.center = newCenter;
            }
        }
    }
    
    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.contentViewController.view.frame.origin.x > self.view.frame.size.width / 3) {
            [self openMenu];
        }
        
        if (self.contentViewController.view.frame.origin.x <= self.view.frame.size.width / 3) {
            [self closeMenu];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openMenu
{
    [UIView animateWithDuration:.4 animations:^{
        CGPoint finalCenter = CGPointMake(CGRectGetWidth(self.view.frame),
                                          self.contentViewController.view.center.y);
        self.contentViewController.view.center = finalCenter;
    }];
}

- (void)closeMenu
{
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectSidebarItem:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
}

@end
