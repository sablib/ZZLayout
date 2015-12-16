//
//  ZZHelperConstraint.h
//  ZZLayout
//
//  Created by sablib on 15/11/29.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ZZLayoutConstraint.h"

typedef NS_OPTIONS(NSInteger, ZZHelperConstraintAttribute) {
    ZZHelperConstraintAttributeLeft = 1 << ZZLayoutConstraintAttributeLeft,
    ZZHelperConstraintAttributeRight = 1 << ZZLayoutConstraintAttributeRight,
    ZZHelperConstraintAttributeTop = 1 << ZZLayoutConstraintAttributeTop,
    ZZHelperConstraintAttributeBottom = 1 << ZZLayoutConstraintAttributeBottom,
    ZZHelperConstraintAttributeWidth = 1 << ZZLayoutConstraintAttributeWidth,
    ZZHelperConstraintAttributeHeight = 1 << ZZLayoutConstraintAttributeHeight,
    ZZHelperConstraintAttributeCenterX = 1 << ZZLayoutConstraintAttributeCenterX,
    ZZHelperConstraintAttributeCenterY = 1 << ZZLayoutConstraintAttributeCenterY,
};


@interface ZZHelperConstraint : NSObject

@property (nonatomic, weak) ZZLayoutItem *firstItem;
@property (nonatomic, assign) ZZHelperConstraintAttribute firstAttributes;
@property (nonatomic, weak) ZZLayoutItem *secondItem;
@property (nonatomic, assign) ZZHelperConstraintAttribute secondAttributes;
@property (nonatomic, assign) ZZLayoutRelation relation;
@property (nonatomic, assign) CGFloat zz_multiplier;
@property (nonatomic, assign) CGFloat zz_offset;


- (ZZHelperConstraint * (^)(CGFloat offset))offset;
- (ZZHelperConstraint * (^)(CGFloat multiplier))multipliedBy;
- (ZZHelperConstraint * (^)(id obj))equalTo;
- (ZZHelperConstraint * (^)(id obj))lessThanOrEqualTo;
- (ZZHelperConstraint * (^)(id obj))greaterThanOrEqualTo;
- (ZZHelperConstraint *)with;
- (ZZHelperConstraint *)and;
- (ZZHelperConstraint *)left;
- (ZZHelperConstraint *)top;
- (ZZHelperConstraint *)right;
- (ZZHelperConstraint *)bottom;
- (ZZHelperConstraint *)width;
- (ZZHelperConstraint *)height;
- (ZZHelperConstraint *)centerX;
- (ZZHelperConstraint *)centerY;

- (void)install;

@end
