//
//  embBezierPathItems.m
//  embAnimatedPath
//
//  Created by Evan Buxton on 2/19/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "embDirections.h"
@implementation embDirections

- (id) init
{
    if (self = [super init]) {
		
		// setup
		_bezierPaths = [[NSMutableArray alloc] init];
		
		UIColor* existing = [UIColor colorWithRed: 0.545 green: 0.165 blue: 0.498 alpha: 1];
		UIColor* blue = [UIColor colorWithRed: 0.149 green: 0.702 blue: 0.89 alpha: 1];
		UIColor* green = [UIColor colorWithRed: 0.349 green: 0.702 blue: 0.208 alpha: 1];
		UIColor* color = [UIColor colorWithRed: 0.063 green: 0.361 blue: 0.675 alpha: 1];
		UIColor* color2 = [UIColor colorWithRed: 0.812 green: 0.608 blue: 0.722 alpha: 1];

		CGFloat pathWidth = 7.0;
		CGFloat pathSpeed = 3.5;

		// Bezier paths created in paintcode
		// COPY FROM PAINTCODE
		
		UIBezierPath* bezierPath = [UIBezierPath bezierPath];
		[bezierPath moveToPoint: CGPointMake(443.5, 60.5)];
		[bezierPath addLineToPoint: CGPointMake(438, 65.5)];
		[bezierPath addLineToPoint: CGPointMake(429.5, 64.5)];
		[bezierPath addCurveToPoint: CGPointMake(418.5, 76.5) controlPoint1: CGPointMake(429.5, 64.5) controlPoint2: CGPointMake(418.43, 76.16)];
		[bezierPath addCurveToPoint: CGPointMake(415.5, 81.5) controlPoint1: CGPointMake(418.57, 76.84) controlPoint2: CGPointMake(415.5, 81.5)];
		[bezierPath addLineToPoint: CGPointMake(403.5, 108.5)];
		[bezierPath addLineToPoint: CGPointMake(402.5, 121.5)];
		[bezierPath addLineToPoint: CGPointMake(399.5, 140.5)];
		[bezierPath addLineToPoint: CGPointMake(381.5, 191.5)];
		[bezierPath addLineToPoint: CGPointMake(381.5, 218.5)];
		[bezierPath addLineToPoint: CGPointMake(399.5, 233.5)];
		[bezierPath addLineToPoint: CGPointMake(401.5, 241.5)];
		[bezierPath addLineToPoint: CGPointMake(404.5, 247.5)];
		[bezierPath addLineToPoint: CGPointMake(413.5, 251.5)];
		[bezierPath addLineToPoint: CGPointMake(415.5, 261.5)];
		
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
		[bezier2Path moveToPoint: CGPointMake(376.5, 225.5)];
		[bezier2Path addLineToPoint: CGPointMake(392.5, 237.5)];
		[bezier2Path addLineToPoint: CGPointMake(395.5, 248.5)];
		[bezier2Path addLineToPoint: CGPointMake(398.5, 252.5)];
		[bezier2Path addLineToPoint: CGPointMake(407.5, 256.5)];
		[bezier2Path addLineToPoint: CGPointMake(408.5, 264.5)];

		
		//// Bezier 3 Drawing
		UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
		[bezier3Path moveToPoint: CGPointMake(416, 263)];
		[bezier3Path addLineToPoint: CGPointMake(418.5, 275)];
		[bezier3Path addLineToPoint: CGPointMake(418.5, 280)];
		[bezier3Path addLineToPoint: CGPointMake(414.5, 299)];
		[bezier3Path addLineToPoint: CGPointMake(414, 304.5)];
		[bezier3Path addLineToPoint: CGPointMake(434, 388)];
		[bezier3Path addLineToPoint: CGPointMake(432.5, 434.5)];

		
		//// Bezier 6 Drawing
		UIBezierPath* bezier6Path = [UIBezierPath bezierPath];
		[bezier6Path moveToPoint: CGPointMake(437.5, 435.5)];
		[bezier6Path addLineToPoint: CGPointMake(433, 450.5)];
		[bezier6Path addLineToPoint: CGPointMake(434, 454)];
		[bezier6Path addLineToPoint: CGPointMake(451, 472)];
		[bezier6Path addLineToPoint: CGPointMake(461.5, 489.5)];
		[bezier6Path addLineToPoint: CGPointMake(473, 504.5)];
		[bezier6Path addLineToPoint: CGPointMake(459.5, 524.5)];
		[bezier6Path addLineToPoint: CGPointMake(444.5, 542)];
		[bezier6Path addLineToPoint: CGPointMake(416, 560)];
		[bezier6Path addLineToPoint: CGPointMake(412.5, 563.5)];
		[bezier6Path addLineToPoint: CGPointMake(401, 588)];
		[bezier6Path addLineToPoint: CGPointMake(392.5, 597)];
		[bezier6Path addLineToPoint: CGPointMake(387, 612)];

		
		
		//// Bezier 7 Drawing
		UIBezierPath* bezier7Path = [UIBezierPath bezierPath];
		[bezier7Path moveToPoint: CGPointMake(472.5, 504.5)];
		[bezier7Path addLineToPoint: CGPointMake(491, 528)];
		[bezier7Path addLineToPoint: CGPointMake(508, 575)];
		[bezier7Path addLineToPoint: CGPointMake(523.5, 620)];
		[bezier7Path addLineToPoint: CGPointMake(525, 623.5)];
		[bezier7Path addLineToPoint: CGPointMake(527, 638.5)];
		[bezier7Path addLineToPoint: CGPointMake(536, 658)];

		
		//// Bezier 4 Drawing
		UIBezierPath* bezier4Path = [UIBezierPath bezierPath];
		[bezier4Path moveToPoint: CGPointMake(431.5, 435.5)];
		[bezier4Path addLineToPoint: CGPointMake(427, 450.5)];
		[bezier4Path addLineToPoint: CGPointMake(428, 454)];
		[bezier4Path addLineToPoint: CGPointMake(445, 472)];
		[bezier4Path addLineToPoint: CGPointMake(455.5, 489.5)];
		[bezier4Path addLineToPoint: CGPointMake(467, 504.5)];
		[bezier4Path addLineToPoint: CGPointMake(453.5, 524.5)];
		[bezier4Path addLineToPoint: CGPointMake(438.5, 542)];
		[bezier4Path addLineToPoint: CGPointMake(410, 560)];
		[bezier4Path addLineToPoint: CGPointMake(406.5, 563.5)];
		[bezier4Path addLineToPoint: CGPointMake(395, 588)];
		[bezier4Path addLineToPoint: CGPointMake(386.5, 597)];
		[bezier4Path addLineToPoint: CGPointMake(381, 612)];
		
		
		
		//// Bezier 5 Drawing
		UIBezierPath* bezier5Path = [UIBezierPath bezierPath];
		[bezier5Path moveToPoint: CGPointMake(467.5, 505.5)];
		[bezier5Path addLineToPoint: CGPointMake(486, 529)];
		[bezier5Path addLineToPoint: CGPointMake(503, 576)];
		[bezier5Path addLineToPoint: CGPointMake(518.5, 621)];
		[bezier5Path addLineToPoint: CGPointMake(520, 624.5)];
		[bezier5Path addLineToPoint: CGPointMake(522, 639.5)];
		[bezier5Path addLineToPoint: CGPointMake(531, 659)];
		
		
		//// Oval Drawing
		//// Oval Drawing
		UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(437, 54, 10, 10)];
		
		
		//// Oval 2 Drawing
		UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(426, 62, 6, 6)];
		
		
		
		//// Oval 3 Drawing
		UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(418, 70, 6, 6)];

		
		
		//// Oval 4 Drawing
		UIBezierPath* oval4Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(402.5, 101, 6, 6)];
	
		
		
		//// Oval 5 Drawing
		UIBezierPath* oval5Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(390.5, 154, 6, 6)];

		
		
		//// Oval 6 Drawing
		UIBezierPath* oval6Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(381.5, 180, 6, 6)];
	
		
		
		//// Oval 7 Drawing
		UIBezierPath* oval7Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(379, 217, 6, 6)];
		
		
		
		//// Oval 8 Drawing
		UIBezierPath* oval8Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(395, 230, 6, 6)];



		
		// END COPY FROM PAINT CODE
        
		
		
		// copy new paths from paint code above into array
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = existing;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezierPath;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = ovalPath;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = oval2Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier2Path;
		pathItem.embPath = oval3Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = oval4Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = oval5Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = oval6Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = oval7Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color2;
		pathItem.pathSpeed = 0;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = oval8Path;
		[_bezierPaths addObject:pathItem];
		
		
		
		
		
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = blue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier2Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = blue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier4Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = blue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier5Path;
		[_bezierPaths addObject:pathItem];
		
		
		
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier6Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = color;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier7Path;
		[_bezierPaths addObject:pathItem];
		

		
		
		
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = green;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = bezier3Path;
		[_bezierPaths addObject:pathItem];
		
		
		

	}
	
	return self;
}

@end
