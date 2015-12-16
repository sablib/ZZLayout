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

@property (nonatomic, assign) rhea::simplex_solver *_zz_solver;

@property (nonatomic, strong, readwrite) NSMutableArray *constraints;

@property (nonatomic, weak, readwrite) ZZLayoutItem *parent;
@property (nonatomic, strong, readwrite) NSMutableArray<ZZLayoutItem *> *children;

//helper property
@property (nonatomic, readonly) CGRect coor;

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
    delete self._zz_solver;
}

- (instancetype)init {
    if (self = [super init]) {
        self.constraints = @[].mutableCopy;
        self.children = @[].mutableCopy;
        
        self._zz_left = new rhea::variable();
        self._zz_right = new rhea::variable();
        self._zz_top = new rhea::variable();
        self._zz_bottom = new rhea::variable();
        self._zz_width = new rhea::variable();
        self._zz_height = new rhea::variable();
        self._zz_centerX = new rhea::variable();
        self._zz_centerY = new rhea::variable();

        self._zz_solver = new rhea::simplex_solver();
        self._zz_solver->set_autosolve(true);
        self.sharedsolver->add_constraints({
            *self._zz_width == *self._zz_right - *self._zz_left,
            *self._zz_height == *self._zz_bottom - *self._zz_top,
            *self._zz_centerX == (*self._zz_left + *self._zz_right) / 2,
            *self._zz_centerY == (*self._zz_top + *self._zz_bottom) / 2
        });
    }
    return self;
}

- (ZZLayoutItem *)_commonAncestorWithItem:(ZZLayoutItem *)item {
    NSAssert(item != nil, @"item must not be nil");
    
    NSMutableArray *tempArray = @[].mutableCopy;
    ZZLayoutItem *tempItem = self;
    while (1) {
        if (tempItem) {
            [tempArray addObject:tempItem];
            tempItem = tempItem.parent;
        } else {
            break;
        }
    }
    tempItem = item;
    while (1) {
        if (tempItem) {
            if ([tempArray containsObject:tempItem]) {
                return tempItem;
            } else {
                tempItem = tempItem.parent;
            }
        } else {
            return nil;
        }
    }
}

- (void)constraintAt:(ZZLayoutConstraintAttribute)attribute
              toItem:(ZZLayoutItem *)item
                  at:(ZZLayoutConstraintAttribute)attribute1
            relation:(ZZLayoutRelation)relation
           multipyBy:(CGFloat)factor
          withOffset:(CGFloat)offset {
    ZZLayoutConstraint *constraint = [ZZLayoutConstraint new];
    constraint.firstItem = self;
    constraint.firstAttribute = attribute;
    constraint.secondItem = item;
    constraint.secondAttribute = attribute1;
    constraint.relation = relation;
    constraint.multiplier = factor;
    constraint.offset = offset;
    [self addConstraint:constraint];
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

- (void)addConstraint:(ZZLayoutConstraint *)constraint {
    NSAssert(constraint.firstItem != nil && constraint.secondItem != nil, @"two item should have the same ancestor.");
    
    ZZLayoutItem *ancestor = [self _commonAncestorWithItem:constraint.secondItem];
    NSAssert(ancestor != nil, @"the two item should hava a common ancestor.");
    
    if ([ancestor.constraints containsObject:constraint]) {
        return;
    }

    [ancestor activateConstraint:constraint];
    [ancestor.constraints addObject:constraint];
    
    [ancestor layout];
}

- (void)removeConstraint:(ZZLayoutConstraint *)constraint {
    NSAssert(constraint.firstItem != nil && constraint.secondItem != nil, @"two item should have the same ancestor.");
    
    ZZLayoutItem *ancestor = [self _commonAncestorWithItem:constraint.secondItem];
    NSAssert(ancestor != nil, @"the two item should hava a common ancestor.");
    
    if (![ancestor.constraints containsObject:constraint]) {
        return;
    }
    
    [ancestor deactivateConstraint:constraint];
    [ancestor.constraints removeObject:constraint];
    
    [ancestor layout];
}

- (void)makeConstraints:(void(^)(ZZLayoutConstraintMaker *make))block {
    ZZLayoutConstraintMaker *maker = [[ZZLayoutConstraintMaker alloc] initWithItem:self];
    block(maker);
    [maker install];
}

- (rhea::constraint *)rhea_constraintFromZZLayoutConstraint:(ZZLayoutConstraint *)constraint {
    NSAssert(constraint.firstItem != nil && constraint.secondItem != nil, @"two item should have the same ancestor.");
    
    ZZLayoutItem *ancestor = [constraint.firstItem _commonAncestorWithItem:constraint.secondItem];
    NSAssert(ancestor != nil, @"the two item should hava a common ancestor.");
    
    rhea::variable *var1 = [constraint.firstItem variableForConstraintAttribute:constraint.firstAttribute];
    rhea::variable *var2 = [constraint.secondItem variableForConstraintAttribute:constraint.secondAttribute];
    
    rhea::linear_expression lhs = *var1;
    rhea::linear_expression rhs = *var2 * constraint.multiplier + constraint.offset;
    
    rhea::constraint *rhea_constraint;
    switch (constraint.relation) {
        case ZZLayoutRelationEqual:
            rhea_constraint = new rhea::constraint(lhs == rhs);
            break;
        case ZZLayoutRelationLessThanOrEqual:
            rhea_constraint = new rhea::constraint(lhs <= rhs);
            break;
        case ZZLayoutRelationGreaterThanOrEqual:
            rhea_constraint = new rhea::constraint(lhs >= rhs);
            break;
    }
    
    return rhea_constraint;
}

- (void)activateConstraint:(ZZLayoutConstraint *)constraint {
    ZZLayoutItem *ancestor = [constraint.firstItem _commonAncestorWithItem:constraint.secondItem];
    NSAssert(ancestor != nil, @"the two item should hava a common ancestor.");
    
    rhea::constraint *rhea_constraint = [self rhea_constraintFromZZLayoutConstraint:constraint];
    rhea::constraint tmp_constraint = *rhea_constraint;
    ancestor.sharedsolver->add_constraint(tmp_constraint);
    delete rhea_constraint;
}

- (void)deactivateConstraint:(ZZLayoutConstraint *)constraint {
    ZZLayoutItem *ancestor = [constraint.firstItem _commonAncestorWithItem:constraint.secondItem];
    NSAssert(ancestor != nil, @"the two item should hava a common ancestor.");
    
    rhea::constraint *rhea_constraint = [self rhea_constraintFromZZLayoutConstraint:constraint];
    rhea::constraint tmp_constraint = *rhea_constraint;
    ancestor.sharedsolver->remove_constraint(tmp_constraint);
    delete rhea_constraint;
}

- (CGRect)frame {
    if (self.parent) {
        CGRect coor = [self coor];
        CGRect parentCoor = [self.parent coor];
        return CGRectOffset(coor, -parentCoor.origin.x, -parentCoor.origin.y);
    } else {
        return [self coor];
    }
}

- (void)setFrame:(CGRect)frame {
    self._zz_width->set_value(CGRectGetWidth(frame));
    self._zz_height->set_value(CGRectGetHeight(frame));
    self.sharedsolver->add_stays({
        *self._zz_width,
        *self._zz_height
    });

    if (self.parent) {
        self.sharedsolver->add_constraint(*self._zz_left == *self.parent._zz_left + frame.origin.x);
        self.sharedsolver->add_constraint(*self._zz_top == *self.parent._zz_top + frame.origin.y);
    } else {
        self._zz_left->set_value(CGRectGetMinX(frame));
        self._zz_top->set_value(CGRectGetMinY(frame));
        self.sharedsolver->add_stays({
            *self._zz_left,
            *self._zz_top,
        });
    }
    
    [self layout];
}

- (CGRect)coor {
    return CGRectMake(self._zz_left->value(), self._zz_top->value(), self._zz_width->value(), self._zz_height->value());
}

- (CGRect)bounds {
    return CGRectMake(0, 0, self._zz_width->value(), self._zz_height->value());
}

- (void)addSubItem:(ZZLayoutItem *)item {
    [self.children addObject:item];
    item.parent = self;
}

- (void)layout {
    self.sharedsolver->solve();
}

@end
