//
//  ZZLayoutItem.m
//  ZZLayout
//
//  Created by 张凯 on 15/11/25.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZLayoutItem.h"
#import "ZZLayoutConstraint.h"
#import "ZZLayoutConstraintMaker.h"
#import <Rhea/simplex_solver.hpp>
#import <Rhea/iostream.hpp>
#import <Rhea/variable.hpp>

@interface ZZLayoutItem ()

@property (nonatomic, assign) rhea::variable *_zz_left;
@property (nonatomic, assign) rhea::variable *_zz_right;
@property (nonatomic, assign) rhea::variable *_zz_top;
@property (nonatomic, assign) rhea::variable *_zz_bottom;
@property (nonatomic, assign) rhea::variable *_zz_width;
@property (nonatomic, assign) rhea::variable *_zz_height;
@property (nonatomic, assign) rhea::variable *_zz_centerX;
@property (nonatomic, assign) rhea::variable *_zz_centerY;

@property (nonatomic, strong, readwrite) NSMutableArray *constraints;

@end

@implementation ZZLayoutItem

+ (rhea::solver *)sharedsolver {
    static rhea::simplex_solver *solver = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        solver = new rhea::simplex_solver();
        solver->set_autosolve(false);
    });
    return solver;
}

- (rhea::solver *)sharedsolver {
    return [[self class] sharedsolver];
}


- (void)dealloc {
    delete self._zz_left;
    delete self._zz_right;
    delete self._zz_top;
    delete self._zz_bottom;
    delete self._zz_height;
    delete self._zz_width;
    delete self._zz_centerX;
    delete self._zz_centerY;
}

- (instancetype)init {
    if (self = [super init]) {
        self.constraints = @[].mutableCopy;
        
        self._zz_left = new rhea::variable();
        self._zz_right = new rhea::variable();
        self._zz_top = new rhea::variable();
        self._zz_bottom = new rhea::variable();
        self._zz_width = new rhea::variable();
        self._zz_height = new rhea::variable();
        self._zz_centerX = new rhea::variable();
        self._zz_centerY = new rhea::variable();
        
        [self sharedsolver]->add_constraints({
            *self._zz_width == *self._zz_right - *self._zz_left,
            *self._zz_height == *self._zz_bottom - *self._zz_top,
            *self._zz_centerX == (*self._zz_left + *self._zz_right) / 2,
            *self._zz_centerY == (*self._zz_top + *self._zz_bottom) / 2
        });
    }
    return self;
}

- (void)constraintAt:(ZZLayoutConstraintAttribute)attribute
              toItem:(ZZLayoutItem *)item
                  at:(ZZLayoutConstraintAttribute)attribute1
           multipyBy:(CGFloat)factor
          withOffset:(CGFloat)offset {
    rhea::variable *var1 = [self variableForConstraintAttribute:attribute];
    rhea::variable *var2 = [item variableForConstraintAttribute:attribute1];
    [self sharedsolver]->add_constraint(*var1 == *var2 * factor + offset);
}

- (rhea::variable *)variableForConstraintAttribute:(ZZLayoutConstraintAttribute)attribute {
    switch (attribute) {
        case ZZLayoutConstraintAttributeTop:
            return self._zz_top;
        case ZZLayoutConstraintAttributeLeft:
            return self._zz_left;
        case ZZLayoutConstraintAttributeRight:
            return self._zz_right;
        case ZZLayoutConstraintAttributeBottom:
            return self._zz_bottom;
        case ZZLayoutConstraintAttributeWidth:
            return self._zz_width;
        case ZZLayoutConstraintAttributeHeight:
            return self._zz_height;
        case ZZLayoutConstraintAttributeCenterY:
            return self._zz_centerY;
        case ZZLayoutConstraintAttributeCenterX:
            return self._zz_centerX;
    }
}

- (void)addAspectRateForSize:(CGFloat)rate {
    NSAssert(rate > 0, @"rate must be positive");
    
    [self sharedsolver]->add_constraint(*self._zz_height == *self._zz_width * rate);
}

- (void)addConstraint:(ZZLayoutConstraint *)constraint {
    [constraint.firstItem constraintAt:constraint.firstAttribute
                                toItem:constraint.secondItem
                                    at:constraint.secondAttribute
                             multipyBy:constraint.multiplier
                            withOffset:constraint.offset];
    
    [self.constraints addObject:constraint];
}

- (void)makeConstraints:(void(^)(ZZLayoutConstraintMaker *make))block {
    ZZLayoutConstraintMaker *maker = [[ZZLayoutConstraintMaker alloc] initWithItem:self];
    block(maker);
    [maker install];
}

- (CGRect)frame {
    return CGRectMake(self._zz_left->value(), self._zz_top->value(), self._zz_width->value(), self._zz_height->value());
}

- (void)setFrame:(CGRect)frame {
    self._zz_left->set_value(CGRectGetMinX(frame));
    self._zz_top->set_value(CGRectGetMinY(frame));
    self._zz_width->set_value(CGRectGetWidth(frame));
    self._zz_height->set_value(CGRectGetHeight(frame));
    [self sharedsolver]->add_stays({
        *self._zz_left,
        *self._zz_top,
        *self._zz_width,
        *self._zz_height
    });
}

+ (void)layout {
    [self sharedsolver]->solve();
}

@end
