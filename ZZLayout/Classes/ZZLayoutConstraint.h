//
//  ZZLayoutConstraint.h
//  ZZLayout
//
//  Created by sablib on 15/11/29.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ZZLayoutConstraintAttribute) {
    ZZLayoutConstraintAttributeLeft = 1,
    ZZLayoutConstraintAttributeRight,
    ZZLayoutConstraintAttributeTop,
    ZZLayoutConstraintAttributeBottom,
    ZZLayoutConstraintAttributeWidth,
    ZZLayoutConstraintAttributeHeight,
    ZZLayoutConstraintAttributeCenterX,
    ZZLayoutConstraintAttributeCenterY,
};



@class ZZLayoutItem;

@interface ZZLayoutConstraint : NSObject

@property (nonatomic, weak) ZZLayoutItem *firstItem;
@property (nonatomic, assign) ZZLayoutConstraintAttribute firstAttribute;
@property (nonatomic, weak) ZZLayoutItem *secondItem;
@property (nonatomic, assign) ZZLayoutConstraintAttribute secondAttribute;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, assign) CGFloat offset;

@end
