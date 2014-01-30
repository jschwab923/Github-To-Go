//
//  NAYTopPhoneViewController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYRepoContentViewController.h"
#import "NAYNetworkController.h"
#import "NAYDetailViewController.h"

@interface NAYRepoContentViewController () 

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSString *searchType;
@property (nonatomic) NSArray *searchResults;


@end

@implementation NAYRepoContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
    if (self.searchResults) {
        cell.textLabel.text = [self.searchResults[indexPath.row] objectForKey:@"name"];
    }
    return cell;
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchResults = [[NAYNetworkController sharedController] reposForSearchString:self.searchBar.text];
    [searchBar resignFirstResponder];
    [self.contentTableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.contentTableView indexPathForSelectedRow];
    NAYDetailViewController *detailViewController = (NAYDetailViewController *)segue.destinationViewController;
    detailViewController.detailItem = self.searchResults[indexPath.row];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.view.frame = self.parentViewController.view.frame;
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

@end
