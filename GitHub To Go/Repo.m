//
//  Repo.m
//  GitHub To Go
//
//  Created by Jeff Schwab on 2/11/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "Repo.h"


@implementation Repo

@dynamic name;
@dynamic html_url;


- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJSONDictionary:(NSDictionary *)json
{
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
        self.name = json[@"name"];
        self.html_url = json[@"html_url"];
    }
    return self;
}


@end
