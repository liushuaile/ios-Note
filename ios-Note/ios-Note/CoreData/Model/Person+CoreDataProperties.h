//
//  Person+CoreDataProperties.h
//  Note
//
//  Created by SL on 28/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nonatomic) int32_t age;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
