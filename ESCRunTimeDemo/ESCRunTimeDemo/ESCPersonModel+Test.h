//
//  ESCPersonModel+Test.h
//  ESCRunTimeDemo
//
//  Created by xiang on 2019/3/20.
//  Copyright © 2019 xiang. All rights reserved.
//

#import "ESCPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESCPersonModel (Test)

//动态添加属性
- (void)setWeight:(float)weight;

//动态获取属性
- (float)getWeight;

@end

NS_ASSUME_NONNULL_END
