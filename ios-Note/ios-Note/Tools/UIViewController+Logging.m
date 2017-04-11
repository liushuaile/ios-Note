//
//  UIViewController+Logging.m
//  Note
//
//  Created by SL on 30/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "UIViewController+Logging.h"
#import<objc/runtime.h>

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
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

@implementation UIViewController (Logging)
/*
 +load: 是个特例，当一个类被读到内存的时候， runtime 会给这个类及它的每一个类别都发送一个 +load: 消息。
 */
+ (void)load {
    swizzleMethod([self class], @selector(viewWillAppear:), @selector(new_viewWillAppear:));
}

- (void)new_viewWillAppear:(BOOL)animated {
    NSLog(@"Logging --> [%@]", [self class]);

//    [self new_viewWillAppear:animated];
}

@end
