//
//  ZZLayoutConstraintMaker.m
//  ZZLayout
//
//  Created by sablib on 15/11/29.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZLayoutConstraintMaker.h"

@interface ZZLayoutConstraintMaker ()

@property (nonatomic, strong) ZZLayoutItem *item;

@property (nonatomic, strong, readwrite) NSMutableArray *constraints;

@end

@implementation ZZLayoutConstraintMaker

- (instancetype)initWithItem:(ZZLayoutItem *)item {
    if (self = [super init]) {
        self.constraints = @[].mutableCopy;
        self.item = item;
    }
    return self;
}

- (void)install {
    for (ZZHelperConstraint *constraint in self.constraints) {
        [constraint install];
    }
}

- (ZZHelperConstraint *)left {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeLeft;
    [self.constraints addObject:constraint];
    return constraint;
}

- (ZZHelperConstraint *)right {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeRight;
    [self.constraints addObject:constraint];
    return constraint;
}

- (ZZHelperConstraint *)top {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeTop;
    [self.constraints addObject:constraint];
    return constraint;
}

- (ZZHelperConstraint *)bottom {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeBottom;
    [self.constraints addObject:constraint];
    return constraint;
}

- (ZZHelperConstraint *)width {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeWidth;
    [self.constraints addObject:constraint];
    return constraint;
}

- (ZZHelperConstraint *)height {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeHeight;
    [self.constraints addObject:constraint];
    return constraint;
}

- (ZZHelperConstraint *)centerX {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeCenterX;
    [self.constraints addObject:constraint];
    return constraint;
}

- (ZZHelperConstraint *)centerY {
    ZZHelperConstraint *constraint = [[ZZHelperConstraint alloc] init];
    constraint.firstItem = self.item;
    constraint.firstAttributes = ZZHelperConstraintAttributeCenterY;
    [self.constraints addObject:constraint];
    return constraint;
}

@end
