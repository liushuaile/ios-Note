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

/*
 Error：
 duplicate symbol _OBJC_CLASS_$_Person in:
 /Users/liu/Library/Developer/Xcode/DerivedData/ios-Note-dwkfdboyxgbgoycopzkyrdjdyllx/Build/Intermediates/ios-Note.build/Debug-iphonesimulator/ios-Note.build/Objects-normal/x86_64/Person+CoreDataClass.o
 duplicate symbol _OBJC_METACLASS_$_Person in:
 /Users/liu/Library/Developer/Xcode/DerivedData/ios-Note-dwkfdboyxgbgoycopzkyrdjdyllx/Build/Intermediates/ios-Note.build/Debug-iphonesimulator/ios-Note.build/Objects-normal/x86_64/Person+CoreDataClass.o
 ld: 2 duplicate symbols for architecture x86_64
 clang: error: linker command failed with exit code 1 (use -v to see invocation)

 Answer：
 I was getting the same type of error with a newly created app under Xcode 8. After much investigation I found reference to entries under Build Phases -> Compile Sources where I found that the data model was included in addition to the .m files. Removing this cleared the error and the app now builds and functions correctly.
 */
