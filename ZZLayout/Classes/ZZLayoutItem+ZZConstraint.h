//
//  ZZLayoutItem+ZZConstraint.h
//  ZZLayout
//
//  Created by sablib on 15/12/4.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ZZLayoutItem.h"
#import "ZZHelperConstraint.h"

@interface ZZLayoutItem (ZZConstraint)

- (ZZHelperConstraint *)left;
- (ZZHelperConstraint *)top;
- (ZZHelperConstraint *)right;
- (ZZHelperConstraint *)bottom;
- (ZZHelperConstraint *)width;
- (ZZHelperConstraint *)height;
- (ZZHelperConstraint *)centerX;
- (ZZHelperConstraint *)centerY;

@end
