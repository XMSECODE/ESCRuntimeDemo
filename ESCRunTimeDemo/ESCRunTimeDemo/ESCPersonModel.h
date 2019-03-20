//
//  ESCPersonModel.h
//  ESCRunTimeDemo
//
//  Created by xiang on 2019/3/20.
//  Copyright © 2019 xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESCPersonModel : NSObject

@property(nonatomic,copy)NSString* name;

@property(nonatomic,assign)int age;

- (void)function2;

+ (void)class_function2;

@end

NS_ASSUME_NONNULL_END
