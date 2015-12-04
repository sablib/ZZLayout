//
//  ZZHelperConstraint.m
//  ZZLayout
//
//  Created by sablib on 15/11/29.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZHelperConstraint.h"
#import "ZZLayoutItem.h"

ZZHelperConstraintAttribute helperAttrFromLayoutAttr(ZZLayoutConstraintAttribute attr) {
    return 1 << attr;
}

@interface ZZHelperConstraint ()

@end

@implementation ZZHelperConstraint

- (instancetype)init {
    if (self = [super init]) {
        self.zz_multiplier = 1;
        self.zz_offset = 0;
    }
    return self;
}

- (ZZHelperConstraint * (^)(CGFloat offset))offset {
    NSAssert(self.secondItem != nil, @"must be called after bind to second item");
    return ^id(CGFloat offset) {
        self.zz_offset = offset;
        return self;
    };
}

- (ZZHelperConstraint * (^)(CGFloat multiplier))multipliedBy {
    NSAssert(self.secondItem != nil, @"must be called after bind to second item");
    return ^id(CGFloat multiplier) {
        self.zz_multiplier = multiplier;
        return self;
    };
}

- (ZZHelperConstraint * (^)(id obj))equalTo {
    return ^ZZHelperConstraint *(id obj) {
        if ([obj isKindOfClass:[ZZLayoutItem class]]) {
            self.secondItem = (ZZLayoutItem *)obj;
            self.secondAttributes = self.firstAttributes;
            return self;
        } else if ([obj isKindOfClass:[ZZHelperConstraint class]]) {
            self.secondItem = [(ZZHelperConstraint *)obj firstItem];
            self.secondAttributes = [(ZZHelperConstraint *)obj firstAttributes];
            return self;
        } else {
            NSAssert(NO, @"argument should be ZZLayoutItem or ZZHelperConstraint");
            return self;
        }
    };
}

- (ZZHelperConstraint *)with {
    return self;
}

- (ZZHelperConstraint *)and {
    return self;
}

- (ZZHelperConstraint *)left {
    self.firstAttributes |= ZZHelperConstraintAttributeLeft;
    return self;
}

- (ZZHelperConstraint *)top {
    self.firstAttributes |= ZZHelperConstraintAttributeTop;
    return self;
}

- (ZZHelperConstraint *)right {
    self.firstAttributes |= ZZHelperConstraintAttributeRight;
    return self;
}

- (ZZHelperConstraint *)bottom {
    self.firstAttributes |= ZZHelperConstraintAttributeBottom;
    return self;
}

- (ZZHelperConstraint *)width {
    self.firstAttributes |= ZZHelperConstraintAttributeWidth;
    return self;
}

- (ZZHelperConstraint *)height {
    self.firstAttributes |= ZZHelperConstraintAttributeHeight;
    return self;
}

- (ZZHelperConstraint *)centerX {
    self.firstAttributes |= ZZHelperConstraintAttributeCenterX;
    return self;
}

- (ZZHelperConstraint *)centerY {
    self.firstAttributes |= ZZHelperConstraintAttributeCenterY;
    return self;
}

- (NSArray *)getLayoutAttributes:(ZZHelperConstraintAttribute)attributes {
    NSMutableArray *layoutAttributes = @[].mutableCopy;
    for (int i = 1; i < 9; i++) {
        if ((1 << i) & attributes) {
            [layoutAttributes addObject:@(i)];
        }
    }
    return layoutAttributes;
}

- (void)install {
    NSAssert(self.firstItem && self.secondItem, @"there must be a first item and a second item");
    
    NSArray *firstLayoutAttributes = [self getLayoutAttributes:self.firstAttributes];
    NSArray *secondLayoutAttributes = [self getLayoutAttributes:self.secondAttributes];
    
    NSAssert(firstLayoutAttributes.count > 0 && secondLayoutAttributes.count > 0, @"the count of specified attributes must be greater than 0");
    
    ZZLayoutConstraintAttribute attr = [secondLayoutAttributes.firstObject integerValue];
    [firstLayoutAttributes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZLayoutConstraintAttribute attribute = [obj integerValue];
        ZZLayoutConstraint *constraint = [[ZZLayoutConstraint alloc] init];
        constraint.firstItem = self.firstItem;
        constraint.firstAttribute = attribute;
        constraint.secondItem = self.secondItem;
        constraint.secondAttribute = attr;
        constraint.multiplier = self.zz_multiplier;
        constraint.offset = self.zz_offset;
        [self.firstItem addConstraint:constraint];
    }];
    
    if (secondLayoutAttributes.count > 1) {
        secondLayoutAttributes = [secondLayoutAttributes subarrayWithRange:NSMakeRange(1, secondLayoutAttributes.count - 1)];
        [secondLayoutAttributes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZZLayoutConstraintAttribute attribute = [obj integerValue];
            ZZLayoutConstraint *constraint = [[ZZLayoutConstraint alloc] init];
            constraint.firstItem = self.secondItem;
            constraint.firstAttribute = attribute;
            constraint.secondItem = self.secondItem;
            constraint.secondAttribute = attr;
            constraint.multiplier = self.zz_multiplier;
            constraint.offset = self.zz_offset;
            [self.firstItem addConstraint:constraint];
        }];
    }
}

@end
