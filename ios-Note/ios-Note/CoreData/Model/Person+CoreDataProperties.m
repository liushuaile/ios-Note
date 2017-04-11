//
//  Person+CoreDataProperties.m
//  Note
//
//  Created by SL on 28/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic age;
@dynamic name;

@end
