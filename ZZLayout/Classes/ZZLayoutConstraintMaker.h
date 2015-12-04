//
//  ZZLayoutConstraintMaker.h
//  ZZLayout
//
//  Created by sablib on 15/11/29.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZHelperConstraint.h"

@interface ZZLayoutConstraintMaker : NSObject

@property (nonatomic, strong, readonly) ZZHelperConstraint *left;
@property (nonatomic, strong, readonly) ZZHelperConstraint *top;
@property (nonatomic, strong, readonly) ZZHelperConstraint *right;
@property (nonatomic, strong, readonly) ZZHelperConstraint *bottom;
@property (nonatomic, strong, readonly) ZZHelperConstraint *width;
@property (nonatomic, strong, readonly) ZZHelperConstraint *height;
@property (nonatomic, strong, readonly) ZZHelperConstraint *centerX;
@property (nonatomic, strong, readonly) ZZHelperConstraint *centerY;


@property (nonatomic, readonly) NSMutableArray *constraints;


- (instancetype)initWithItem:(ZZLayoutItem *)item;

- (void)install;

@end
