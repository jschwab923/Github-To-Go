//
//  NAYCollectionViewController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/28/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYUserContentViewController.h"
#import "NAYUserCollectionViewCell.h"
#import "NAYNetworkController.h"
#import "NAYGitUser.h"

#import "NAYDetailViewController.h"

@interface NAYUserContentViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSMutableArray *users;
@property (nonatomic) NSArray *searchResults;

@end

@implementation NAYUserContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Listen for when User finishes setting it's image property after downloaded
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userImageSet:) name:USER_IMAGE_SET object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate Methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NAYUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    
    NAYGitUser *currentUserForCell = self.users[indexPath.row];
    cell.userNameLabel.text = currentUserForCell.userName;
    if (currentUserForCell.userImage){
        
        cell.userImageView.image = currentUserForCell.userImage;
        
    } else {
        NSOperationQueue *backgroundQueue = [NSOperationQueue new];
        [backgroundQueue addOperationWithBlock:^{
            [currentUserForCell downloadUserImage];
        }];
    }
    
    return cell;
}

// For iPad with split view controller
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NAYDetailViewController *destinationViewController = (NAYDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        
        NSIndexPath *selectedIndexPath = [[self.userCollectionView indexPathsForSelectedItems] firstObject];
        
        //TODO: Work on selection indication
//        NAYUserCollectionViewCell *selectedCell = (NAYUserCollectionViewCell *)[self.userCollectionView cellForItemAtIndexPath:selectedIndexPath];
            destinationViewController.detailItem = self.searchResults[indexPath.row];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.searchResults count];;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchResults = [[NAYNetworkController sharedController] usersForSearchString:searchBar.text];
    [self createUsersFromArray:self.searchResults];
    [self.userCollectionView reloadData];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Convenience Methods
- (void)createUsersFromArray:(NSArray *)searchResults
{
    self.users = [NSMutableArray new];
    for (NSDictionary *currentUserJSON in searchResults) {
        NAYGitUser *newUser = [NAYGitUser new];
        newUser.userName = currentUserJSON[@"login"];
        newUser.profileURL = currentUserJSON[@"html_url"];
        newUser.imageURL = [NSURL URLWithString:currentUserJSON[@"avatar_url"]];
        
        [self.users addObject:newUser];
    }
}

#pragma mark - Notification Center Methods
- (void)userImageSet:(id)sender
{
    NAYGitUser *updatedUser = [[sender userInfo] objectForKey:USER_KEY];
    NSInteger cellRow = [self.users indexOfObject:updatedUser];
    NSIndexPath *cellPath = [NSIndexPath indexPathForRow:cellRow inSection:0];
    [self.userCollectionView reloadItemsAtIndexPaths:@[cellPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NAYDetailViewController *destinationViewController = (NAYDetailViewController *)segue.destinationViewController;
    NSIndexPath *selectedIndexPath = [[self.userCollectionView indexPathsForSelectedItems] firstObject];
    
    destinationViewController.detailItem = self.searchResults[selectedIndexPath.row];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.view.frame = self.parentViewController.view.frame;
}

@end
