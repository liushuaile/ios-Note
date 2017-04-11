//
//  GCDMethods.h
//  Note
//
//  Created by SL on 28/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDMethods : NSObject
- (void) syncConcurrent;
- (void) asyncConcurrent;
- (void) syncSerial;
- (void) asyncSerial;
- (void) syncMain;
- (void) asyncMain;
- (void) backMain;
- (void) barrier;
- (void) after;
- (void) once;
- (void) apply;
- (void) group;
@end
