//
//  NAYDetailViewController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYDetailViewController.h"

@interface NAYDetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
- (void)configureView;

@end

@implementation NAYDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSString *htmlURLString = [self.detailItem objectForKey:@"html_url"];
        NSURL *url = [NSURL URLWithString:htmlURLString];
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
