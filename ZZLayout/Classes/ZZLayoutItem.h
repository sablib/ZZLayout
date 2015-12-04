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

@property (nonatomic, readonly) NSMutableArray *constraints;

- (CGRect)frame;

- (void)setFrame:(CGRect)frame;

- (void)constraintAt:(ZZLayoutConstraintAttribute)attribute
              toItem:(ZZLayoutItem *)item
                  at:(ZZLayoutConstraintAttribute)attribute1
           multipyBy:(CGFloat)factor
          withOffset:(CGFloat)offset;

- (void)addConstraint:(ZZLayoutConstraint *)constraint;

- (void)makeConstraints:(void(^)(ZZLayoutConstraintMaker *make))block;

+ (void)layout;

@end
