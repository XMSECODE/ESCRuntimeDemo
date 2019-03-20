//
//  ESCPersonModel+Test.m
//  ESCRunTimeDemo
//
//  Created by xiang on 2019/3/20.
//  Copyright © 2019 xiang. All rights reserved.
//

#import "ESCPersonModel+Test.h"
#import <objc/runtime.h>

@implementation ESCPersonModel (Test)

- (void)setWeight:(float)weight {
    objc_setAssociatedObject(self, "weight", @(weight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)getWeight {
    return [objc_getAssociatedObject(self, "weight") floatValue];
}

@end
