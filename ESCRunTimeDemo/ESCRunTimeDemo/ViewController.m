//
//  ViewController.m
//  ESCRunTimeDemo
//
//  Created by xiang on 2019/3/20.
//  Copyright © 2019 xiang. All rights reserved.
//

#import "ViewController.h"
#import "ESCPersonModel.h"
#import "ESCPersonModel+Test.h"
#import <objc/runtime.h>

@interface ViewController ()

//声明没有实现的方法
- (void)function1;

+ (void)class_function1;

- (void)function2;

+ (void)class_function2;

- (void)function3;

+ (void)class_function3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ESCPersonModel *personModel = [[ESCPersonModel alloc] init];
    personModel.name = @"jake";
    personModel.age = 18;
    
    //动态添加获取属性
    [personModel setWeight:50];
    NSLog(@"%lf",[personModel getWeight]);
    
    //动态创建方法，function1方法没有实现，会调用resolveInstanceMethod：方法，我们在resolveInstanceMethod：方法里面对function1方法进行替换为functionMethod1方法
    [self function1];
    [ViewController class_function1];
    
    //动态替换执行的对象，把function2的执行对象替换为ESCPersonModel
    [self function2];
    [ViewController class_function2];
    
    //动态替换执行对象和执行方法:执行对象替换为ESCPersonModel对象，执行方法替换为function2
    [self function3];
    [ViewController class_function3];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}
void functionMethod1(id obj, SEL _cmd) {
    NSLog(@"Doing functionMethod1   %@",obj);
}

void classFunctionMethod1(id obj, SEL _cmd) {
    NSLog(@"Doing classFunctionMethod1   %@",obj);
}

/*********************1、动态方法解析******************************/
//处理类方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    if (sel == @selector(class_function1)) {
        class_addMethod(object_getClass(self), sel, (IMP)classFunctionMethod1, "v@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

//处理实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(function1)) {
        class_addMethod([self class], sel, (IMP)functionMethod1, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

/*********************2、重定向消息接收者******************************/
//处理类方法
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(class_function2)) {
        return [ESCPersonModel class];
    }
    return [super forwardingTargetForSelector:aSelector];
}

//处理实例方法
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(function2)) {
        return [ESCPersonModel new];
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

/*********************3、重定向消息接收者和方法******************************/
//处理类方法
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"class_function3"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];//签名，进入forwardInvocation
    }
    
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    if (sel_isEqual(sel, NSSelectorFromString(@"class_function3"))) {
        anInvocation.selector = NSSelectorFromString(@"class_function2");
        Class p = [ESCPersonModel class];
        if([p respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:p];
        }else {
            [self doesNotRecognizeSelector:sel];
        }
    }
}

//处理实例方法
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"function3"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];//签名，进入forwardInvocation
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    if (sel_isEqual(sel, NSSelectorFromString(@"function3"))) {
        anInvocation.selector = NSSelectorFromString(@"function2");
        ESCPersonModel *p = [ESCPersonModel new];
        if([p respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:p];
        }else {
            [self doesNotRecognizeSelector:sel];
        }
    }
}

@end
