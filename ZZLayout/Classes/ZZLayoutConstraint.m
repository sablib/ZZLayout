//
//  ZZLayoutConstraint.m
//  ZZLayout
//
//  Created by sablib on 15/11/29.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZLayoutConstraint.h"
#import "ZZLayoutItem.h"

@implementation ZZLayoutConstraint

- (instancetype)init {
    if (self = [super init]) {
        self.multiplier = 1;
        self.offset = 0;
    }
    return self;
}

@end