//
//  CoreDataManager.h
//  Note
//
//  Created by SL on 28/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"
//#import <UIKit/UIKit.h>

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;

//@property (weak, nonatomic) UIViewController *parentViewController;


- (void)saveContext;
@end
