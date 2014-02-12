//
//  NAYNetworkController.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 1/27/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYNetworkController.h"
#import "NAYGitUser.h"
#import "Repo.h"

@interface NAYNetworkController () 

@property (nonatomic) NSManagedObjectContext *managedObjectContext;


@end

@implementation NAYNetworkController

+ (NAYNetworkController *)sharedController
{
    static NAYNetworkController *sharedController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    
    return sharedController;
}

- (void)reposForSearchString:(NSString *)searchString
{
    [self searchForString:searchString type:@"repositories"];
}

- (void)usersForSearchString:(NSString *)searchString
{
     [self searchForString:searchString type:@"users"];
}

- (void)searchForString:(NSString *)searchString type:(NSString *)type
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/%@?q=%@", type, searchString];
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *searchURL = [NSURL URLWithString:searchString];
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    
    NSError *error;
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
    
    //TODO: TESTING CORE DATA
    // Save repos in core data
    if ([type isEqualToString:@"repositories"]) {
        for (NSDictionary *repo in searchDictionary[@"items"]) {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Repo"
                                                      inManagedObjectContext:self.managedObjectContext];
            
            Repo *newRepo = [[Repo alloc] initWithEntity:entity
                          insertIntoManagedObjectContext:self.managedObjectContext
                                      withJSONDictionary:repo];
            NSError *saveError;
            [newRepo.managedObjectContext save:&saveError];
            if (saveError) {
                NSLog(@"%@", [saveError userInfo]);
            } else {
                NSLog(@"Core data save success");
            }
        }
    } else {
        
    }
}



- (void)downloadImageDataWithUrl:(NSURL *)imageUrl forUser:(NAYGitUser *)user withCompletionBlock:(void (^)(UIImage *))blockName
{
    __block UIImage *downloadedImage;
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
   
    NSURLSessionDataTask *imageDataTask = [urlSession dataTaskWithURL:imageUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            downloadedImage = [UIImage imageWithData:data];
            user.userImage = downloadedImage;
        } else {
            NSLog(@"%@", error);
        }
    }];
    [imageDataTask resume];
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

- (NSFetchedResultsController *)fetchedResultsControllerRepos
{
    if (_fetchedResultsControllerRepos) {
        return _fetchedResultsControllerRepos;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Repo"
                                              inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptorArray = @[nameSort];
    
    [fetchRequest setSortDescriptors:sortDescriptorArray];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsControllerRepos = fetchedResultsController;
    
    return _fetchedResultsControllerRepos;
}

- (NSFetchedResultsController *)fetchedResultsControllerUsers
{
    if (_fetchedResultsControllerUsers) {
        return _fetchedResultsControllerUsers;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                              inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchBatchSize:20];
    [fetchRequest setEntity:entity];
    
    //    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //    NSArray *sortDescriptorArray = @[nameSort];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return fetchedResultsController;
}


@end
