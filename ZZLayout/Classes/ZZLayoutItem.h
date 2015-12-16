//
//  ZZLayoutItem.h
//  ZZLayout
//
//  Created by 张凯 on 15/11/25.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZLayoutConstraint.h"

@class ZZLayoutConstraintMaker;

@interface ZZLayoutItem : NSObject

@property (nonatomic, weak, readonly) ZZLayoutItem *parent;
@property (nonatomic, strong, readonly) NSMutableArray<ZZLayoutItem *> *children;

@property (nonatomic, readonly) NSMutableArray *constraints;

@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic) CGRect frame;


- (void)constraintAt:(ZZLayoutConstraintAttribute)attribute
              toItem:(ZZLayoutItem *)item
                  at:(ZZLayoutConstraintAttribute)attribute1
            relation:(ZZLayoutRelation)relation
           multipyBy:(CGFloat)factor
          withOffset:(CGFloat)offset;

- (void)addConstraint:(ZZLayoutConstraint *)constraint;

- (void)makeConstraints:(void(^)(ZZLayoutConstraintMaker *make))block;

//- (void)activateConstraint:(ZZLayoutConstraint *)constraint;
//- (void)deactivateConstraint:(ZZLayoutConstraint *)constraint;

- (void)addSubItem:(ZZLayoutItem *)item;

- (void)layout;

@end
