//
//  ZZLayoutItem+ZZConstraint.m
//  ZZLayout
//
//  Created by sablib on 15/12/4.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZLayoutItem+ZZConstraint.h"

@implementation ZZLayoutItem (ZZConstraint)

- (ZZHelperConstraint *)left {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeLeft;
    return constraint;
}

- (ZZHelperConstraint *)top {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeTop;
    return constraint;
}

- (ZZHelperConstraint *)right {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeRight;
    return constraint;
}

- (ZZHelperConstraint *)bottom {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeBottom;
    return constraint;
}

- (ZZHelperConstraint *)width {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeWidth;
    return constraint;
}

- (ZZHelperConstraint *)height {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeHeight;
    return constraint;
}

- (ZZHelperConstraint *)centerX {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeCenterX;
    return constraint;
}

- (ZZHelperConstraint *)centerY {
    ZZHelperConstraint *constraint = [ZZHelperConstraint new];
    constraint.firstItem = self;
    constraint.firstAttributes = ZZHelperConstraintAttributeCenterY;
    return constraint;
}

@end
