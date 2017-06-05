//
//  UIViewController+Tracking.m
//  ios-Note
//
//  Created by SL on 07/05/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>


void xxx_swizzleMethod(Class class,SEL originalSelector, SEL swizzledSelector){

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //Class class = [self class];
        
        //SEL originalSelector = @selector(viewWillAppear:);
        //SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

void new_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    //the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    //the method doesn't exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIViewController (Tracking)

/*
 +load: 是个特例，当一个类被读到内存的时候， runtime 会给这个类及它的每一个类别都发送一个 +load: 消息。
 */

+ (void)load {
    xxx_swizzleMethod([self class], @selector(viewWillAppear:), @selector(xxx_viewWillAppear:));
    //new_swizzleMethod([self class], @selector(viewWillAppear:), @selector(new_viewWillAppear:));
}

#pragma mark - Method Swizzling

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"Tracking: %@", self);
}

- (void)new_viewWillAppear:(BOOL)animated {
    NSLog(@"Logging: %@", self);
    [self new_viewWillAppear:animated];
}


@end
