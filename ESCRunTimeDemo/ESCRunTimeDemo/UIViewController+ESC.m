//
//  CC.m
//  ESCSwizzleSelectorDome
//
//  Created by xiatian on 2024/1/14.
//

#import "UIViewController+ESC.h"
#import <objc/runtime.h>

@implementation UIViewController (ESC)

+ (void)swizzlerViewDidAppear {
    [self instanceSwizzleSelector:@selector(viewDidAppear:) originalSelector:@selector(escViewDidAppear:)];

}

+ (void)instanceSwizzleSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector {
    
    Class klass = [UIViewController class];
    
    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(klass, swizzledSelector);

    //交换方法
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    
}

//+ (void)instanceSwizzleSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector {
//    
//    Class klass = [UIViewController class];
//    
//    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(klass, swizzledSelector);
//    
//    BOOL success = class_addMethod(klass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    
//    if (success) {
//        class_replaceMethod(klass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        //交换方法
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//    
//}
- (void)escViewDidAppear:(BOOL)animated{
    [self escViewDidAppear:animated];
    NSLog(@"escViewDidAppear");
}

@end
