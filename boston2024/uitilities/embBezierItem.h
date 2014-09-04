//
//  embBezierItem.h
//  embAnimatedPath
//
//  Created by Evan Buxton on 2/19/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface embBezierItem : NSObject

@property CGFloat		pathDelay;
@property CGFloat		pathSpeed;
@property UIColor		*pathColor;
@property CGFloat		pathWidth;
@property UIBezierPath	*embPath;

@end
