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
#import "Repo.h"

@interface NAYRepoContentViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSString *searchType;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic) NSMutableArray *pastSearchTerms;

//Core Data stuff
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;


@end

@implementation NAYRepoContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *searchTermsFilePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"pastsearchterms"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:searchTermsFilePath isDirectory:NO]) {
        self.pastSearchTerms =
            [[NSKeyedUnarchiver unarchiveObjectWithFile:searchTermsFilePath] mutableCopy];
    } else {
        self.pastSearchTerms = [NSMutableArray new];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSString *searchTermsFilePath = [[self documentsDirectoryPath] stringByAppendingPathComponent:@"pastsearchterms"];
    [NSKeyedArchiver archiveRootObject:self.pastSearchTerms toFile:searchTermsFilePath];
}

- (NSString *)documentsDirectoryPath
{
     NSURL *documentUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentUrl path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[NAYNetworkController sharedController] fetchedResultsControllerRepos] sections][section];
    
    return [sectionInfo numberOfObjects];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
    
    Repo *repoForIndexPath = [[[NAYNetworkController sharedController] fetchedResultsControllerRepos] objectAtIndexPath:indexPath];
    
    cell.textLabel.text = repoForIndexPath.name;
    NSString *cellStringUppercase = [cell.textLabel.text uppercaseString];
    
    if ([cellStringUppercase rangeOfString:[self.searchBar.text uppercaseString]].location != NSNotFound) {
        cell.textLabel.textColor = [UIColor colorWithRed:1.000 green:0.350 blue:0.282 alpha:1.000];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - UISearchBarDelegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Searches for repos and saves them in core data
    if (![self.pastSearchTerms containsObject:searchBar.text]) {
        NSURL *internetCheck = [NSURL URLWithString:@"http://google.com"];
        NSData *internetCheckData = [NSData dataWithContentsOfURL:internetCheck];
        if (internetCheckData){
            [[NAYNetworkController sharedController] reposForSearchString:self.searchBar.text];
            [self.pastSearchTerms addObject:searchBar.text];
        }
    }

    //Retrives the controller to retrieve the data from core data
    [NAYNetworkController sharedController].fetchedResultsControllerRepos.delegate = self;
    
    NSError *fetchError;
    [[[NAYNetworkController sharedController] fetchedResultsControllerRepos] performFetch:&fetchError];

    [self.contentTableView reloadData];

    [searchBar resignFirstResponder];
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

#pragma mark - Core Data accessor methods
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NAYAppDelegate *appDelegate = (NAYAppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext = appDelegate.managedObjectContext;
    
    return _managedObjectContext;
}


@end
