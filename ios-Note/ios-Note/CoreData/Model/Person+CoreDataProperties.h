//
//  Person+CoreDataProperties.h
//  ios-Note
//
//  Created by SL on 07/05/2017.
//  Copyright © 2017 Sam. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t age;

@end

NS_ASSUME_NONNULL_END
