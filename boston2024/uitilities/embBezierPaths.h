//
//  embBezierPaths.h
//  embAnimatedPath
//
//  Created by Evan Buxton on 2/19/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "embBezierItem.h"

@interface embBezierPaths : NSMutableArray
{
	embBezierItem *pathItem;
}
@property NSMutableArray *bezierPaths;

@end
