//
//  embBezierPathItems.m
//  embAnimatedPath
//
//  Created by Evan Buxton on 2/19/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "embDirectionsHigh.h"
@implementation embDirectionsHigh

- (id) init
{
    if (self = [super init]) {
		
		// setup
		_bezierPaths = [[NSMutableArray alloc] init];
		
		UIColor *pathRed = [UIColor colorWithRed: 0.827 green: 0.275 blue: 0.153 alpha: 1];
		UIColor *pathBlue = [UIColor colorWithRed: 0.41 green: 0.114 blue: 1 alpha: 1];
		
		CGFloat pathWidth = 7.0;
		CGFloat pathSpeed = 3.5;

		// Bezier paths created in paintcode
		// COPY FROM PAINTCODE
		
		//// FromTheWest Drawing
		//// Ingress West 90 Drawing
		UIBezierPath* ingressWest90Path = [UIBezierPath bezierPath];
		[ingressWest90Path moveToPoint: CGPointMake(496, 406.5)];
		[ingressWest90Path addLineToPoint: CGPointMake(692.5, 406.5)];
		[ingressWest90Path addCurveToPoint: CGPointMake(773, 363) controlPoint1: CGPointMake(692.5, 406.5) controlPoint2: CGPointMake(751.74, 372.09)];
		[ingressWest90Path addCurveToPoint: CGPointMake(810, 341) controlPoint1: CGPointMake(785.33, 357.73) controlPoint2: CGPointMake(795.1, 355.71)];
		[ingressWest90Path addCurveToPoint: CGPointMake(847, 295) controlPoint1: CGPointMake(820.39, 326.47) controlPoint2: CGPointMake(830.41, 313.75)];
		[ingressWest90Path addCurveToPoint: CGPointMake(879.5, 268) controlPoint1: CGPointMake(863.59, 276.25) controlPoint2: CGPointMake(869.71, 268.01)];
		[ingressWest90Path addCurveToPoint: CGPointMake(999.5, 307.5) controlPoint1: CGPointMake(887.67, 267.99) controlPoint2: CGPointMake(999.5, 307.5)];
		[ingressWest90Path addLineToPoint: CGPointMake(998.5, 356)];
		[ingressWest90Path addCurveToPoint: CGPointMake(970.89, 355) controlPoint1: CGPointMake(998.5, 356) controlPoint2: CGPointMake(986.25, 360.21)];
		[ingressWest90Path addCurveToPoint: CGPointMake(666.25, 252) controlPoint1: CGPointMake(951.88, 348.54) controlPoint2: CGPointMake(736.66, 277.01)];
		[ingressWest90Path addCurveToPoint: CGPointMake(492.1, 186.5) controlPoint1: CGPointMake(555.62, 212.71) controlPoint2: CGPointMake(501.61, 191.25)];
		[ingressWest90Path addCurveToPoint: CGPointMake(310.42, 66.5) controlPoint1: CGPointMake(469.89, 175.42) controlPoint2: CGPointMake(365.99, 104.04)];
		[ingressWest90Path addCurveToPoint: CGPointMake(199.5, -20.5) controlPoint1: CGPointMake(254.14, 28.48) controlPoint2: CGPointMake(199.5, -20.5)];
		ingressWest90Path.lineJoinStyle = kCGLineJoinRound;
		
	
		
		
		//// Ingress West Drawing
		UIBezierPath* ingressWestPath = [UIBezierPath bezierPath];
		[ingressWestPath moveToPoint: CGPointMake(496.5, 406.5)];
		[ingressWestPath addLineToPoint: CGPointMake(702.5, 406.5)];
		[ingressWestPath addCurveToPoint: CGPointMake(778, 359) controlPoint1: CGPointMake(702.5, 406.5) controlPoint2: CGPointMake(750.91, 368.65)];
		[ingressWestPath addCurveToPoint: CGPointMake(820, 319.5) controlPoint1: CGPointMake(793.34, 353.54) controlPoint2: CGPointMake(810.39, 348.09)];
		[ingressWestPath addCurveToPoint: CGPointMake(858, 211) controlPoint1: CGPointMake(824.74, 305.4) controlPoint2: CGPointMake(848.26, 249.53)];
		[ingressWestPath addCurveToPoint: CGPointMake(861, 166.5) controlPoint1: CGPointMake(864.01, 187.24) controlPoint2: CGPointMake(862.33, 178.07)];
		[ingressWestPath addCurveToPoint: CGPointMake(761, 121.5) controlPoint1: CGPointMake(856.1, 123.88) controlPoint2: CGPointMake(791.25, 132.33)];
		[ingressWestPath addCurveToPoint: CGPointMake(459.5, -21) controlPoint1: CGPointMake(730.75, 110.67) controlPoint2: CGPointMake(496.23, -1.97)];

		
		
		//// Egress West 90 Drawing
		UIBezierPath* egressWest90Path = [UIBezierPath bezierPath];
		[egressWest90Path moveToPoint: CGPointMake(499.5, 406.5)];
		[egressWest90Path addLineToPoint: CGPointMake(657.5, 406.5)];
		[egressWest90Path addLineToPoint: CGPointMake(657.5, 371)];
		[egressWest90Path addCurveToPoint: CGPointMake(668, 353.5) controlPoint1: CGPointMake(657.5, 371) controlPoint2: CGPointMake(657.34, 360.07)];
		[egressWest90Path addCurveToPoint: CGPointMake(754, 307) controlPoint1: CGPointMake(675.16, 349.09) controlPoint2: CGPointMake(739.47, 309.04)];
		[egressWest90Path addCurveToPoint: CGPointMake(926.5, 365.5) controlPoint1: CGPointMake(768.53, 304.96) controlPoint2: CGPointMake(926.5, 365.5)];
		[egressWest90Path addLineToPoint: CGPointMake(932, 403)];
		[egressWest90Path addLineToPoint: CGPointMake(1004.87, 403)];
		[egressWest90Path addLineToPoint: CGPointMake(1031.5, 403)];
		[egressWest90Path addCurveToPoint: CGPointMake(1031.5, 396) controlPoint1: CGPointMake(1031.5, 403) controlPoint2: CGPointMake(1056.53, 400.25)];
		[egressWest90Path addCurveToPoint: CGPointMake(926.5, 341.5) controlPoint1: CGPointMake(1006.47, 391.75) controlPoint2: CGPointMake(948.66, 348.68)];
		[egressWest90Path addCurveToPoint: CGPointMake(568.5, 218) controlPoint1: CGPointMake(904.34, 334.32) controlPoint2: CGPointMake(687.81, 258.86)];
		[egressWest90Path addCurveToPoint: CGPointMake(454, 162) controlPoint1: CGPointMake(508.82, 197.56) controlPoint2: CGPointMake(461.12, 166.7)];
		[egressWest90Path addCurveToPoint: CGPointMake(210.5, -24) controlPoint1: CGPointMake(425.51, 143.21) controlPoint2: CGPointMake(207.83, 6.23)];
		egressWest90Path.lineJoinStyle = kCGLineJoinRound;
		
	
		
		
		//// Egress West Drawing
		UIBezierPath* egressWestPath = [UIBezierPath bezierPath];
		[egressWestPath moveToPoint: CGPointMake(495.5, 406)];
		[egressWestPath addLineToPoint: CGPointMake(642, 406)];
		[egressWestPath addCurveToPoint: CGPointMake(702.5, 401.5) controlPoint1: CGPointMake(642, 406) controlPoint2: CGPointMake(674.21, 408.01)];
		[egressWestPath addCurveToPoint: CGPointMake(768.5, 364.5) controlPoint1: CGPointMake(718.52, 397.82) controlPoint2: CGPointMake(741.07, 378.18)];
		[egressWestPath addCurveToPoint: CGPointMake(813.5, 333) controlPoint1: CGPointMake(790.37, 353.59) controlPoint2: CGPointMake(806.25, 347.43)];
		[egressWestPath addCurveToPoint: CGPointMake(872, 186.5) controlPoint1: CGPointMake(831.4, 297.37) controlPoint2: CGPointMake(859.86, 215.79)];
		[egressWestPath addCurveToPoint: CGPointMake(891, 136.5) controlPoint1: CGPointMake(879.06, 169.46) controlPoint2: CGPointMake(889.66, 150.51)];
		[egressWestPath addCurveToPoint: CGPointMake(840.5, 107.5) controlPoint1: CGPointMake(892.89, 116.67) controlPoint2: CGPointMake(870.02, 102.87)];
		[egressWestPath addCurveToPoint: CGPointMake(738, 104.5) controlPoint1: CGPointMake(821.51, 110.48) controlPoint2: CGPointMake(791.03, 125.54)];
		[egressWestPath addCurveToPoint: CGPointMake(501.5, -3) controlPoint1: CGPointMake(650.35, 69.72) controlPoint2: CGPointMake(524.39, 8.86)];

		
		
		//// Egress South Drawing
		UIBezierPath* egressSouthPath = [UIBezierPath bezierPath];
		[egressSouthPath moveToPoint: CGPointMake(494.5, 406.5)];
		[egressSouthPath addLineToPoint: CGPointMake(688.13, 406.5)];
		[egressSouthPath addCurveToPoint: CGPointMake(700.5, 404.5) controlPoint1: CGPointMake(688.13, 406.5) controlPoint2: CGPointMake(694.69, 406.44)];
		[egressSouthPath addCurveToPoint: CGPointMake(711.36, 398.72) controlPoint1: CGPointMake(706.31, 402.56) controlPoint2: CGPointMake(711.36, 398.72)];
		[egressSouthPath addLineToPoint: CGPointMake(765, 367.5)];
		[egressSouthPath addCurveToPoint: CGPointMake(811, 372) controlPoint1: CGPointMake(772.44, 363.27) controlPoint2: CGPointMake(794.88, 363.59)];
		[egressSouthPath addCurveToPoint: CGPointMake(842.5, 396) controlPoint1: CGPointMake(826.75, 380.21) controlPoint2: CGPointMake(838.83, 394.36)];
		[egressSouthPath addCurveToPoint: CGPointMake(879, 404.5) controlPoint1: CGPointMake(851.48, 400.02) controlPoint2: CGPointMake(863.15, 403.47)];
		[egressSouthPath addCurveToPoint: CGPointMake(971, 403.5) controlPoint1: CGPointMake(915.54, 406.88) controlPoint2: CGPointMake(963.08, 403.11)];
		[egressSouthPath addCurveToPoint: CGPointMake(1054.5, 402.5) controlPoint1: CGPointMake(982.36, 404.05) controlPoint2: CGPointMake(1054.5, 402.5)];
		egressSouthPath.lineJoinStyle = kCGLineJoinRound;
	
		
		
		//// Egress North Drawing
		UIBezierPath* egressNorthPath = [UIBezierPath bezierPath];
		[egressNorthPath moveToPoint: CGPointMake(495, 407)];
		[egressNorthPath addLineToPoint: CGPointMake(645.5, 406)];
		[egressNorthPath addCurveToPoint: CGPointMake(692.5, 406) controlPoint1: CGPointMake(645.5, 406) controlPoint2: CGPointMake(664.79, 406.46)];
		[egressNorthPath addCurveToPoint: CGPointMake(757.5, 370) controlPoint1: CGPointMake(708.19, 405.74) controlPoint2: CGPointMake(730.07, 383.68)];
		[egressNorthPath addCurveToPoint: CGPointMake(812.5, 347.5) controlPoint1: CGPointMake(779.37, 359.09) controlPoint2: CGPointMake(805.25, 361.93)];
		[egressNorthPath addCurveToPoint: CGPointMake(857.5, 225) controlPoint1: CGPointMake(830.4, 311.87) controlPoint2: CGPointMake(851.12, 244.03)];
		[egressNorthPath addCurveToPoint: CGPointMake(890, 169) controlPoint1: CGPointMake(866.47, 198.26) controlPoint2: CGPointMake(873.54, 186.91)];
		[egressNorthPath addCurveToPoint: CGPointMake(1028.5, 152) controlPoint1: CGPointMake(906.46, 151.09) controlPoint2: CGPointMake(920.76, 148.89)];
		
		
		
		//// Ingress South Drawing
		UIBezierPath* ingressSouthPath = [UIBezierPath bezierPath];
		[ingressSouthPath moveToPoint: CGPointMake(498.5, 408.5)];
		[ingressSouthPath addLineToPoint: CGPointMake(347.5, 408.5)];
		[ingressSouthPath addLineToPoint: CGPointMake(332.5, 404.5)];
		[ingressSouthPath addLineToPoint: CGPointMake(378.5, 556.5)];
		[ingressSouthPath addLineToPoint: CGPointMake(396.5, 579.5)];
		[ingressSouthPath addLineToPoint: CGPointMake(376.5, 602)];
		[ingressSouthPath addCurveToPoint: CGPointMake(370, 634) controlPoint1: CGPointMake(376.5, 602) controlPoint2: CGPointMake(364.51, 611.86)];
		[ingressSouthPath addCurveToPoint: CGPointMake(417.5, 708.5) controlPoint1: CGPointMake(375.49, 656.14) controlPoint2: CGPointMake(401.39, 696.11)];
		[ingressSouthPath addCurveToPoint: CGPointMake(480, 775.5) controlPoint1: CGPointMake(433.61, 720.89) controlPoint2: CGPointMake(447.9, 738.15)];
		ingressSouthPath.lineJoinStyle = kCGLineJoinRound;
	
		
		
		//// Ingress North Drawing
		UIBezierPath* ingressNorthPath = [UIBezierPath bezierPath];
		[ingressNorthPath moveToPoint: CGPointMake(495.5, 405.5)];
		[ingressNorthPath addLineToPoint: CGPointMake(628, 406.5)];
		[ingressNorthPath addCurveToPoint: CGPointMake(699.5, 403.5) controlPoint1: CGPointMake(628, 406.5) controlPoint2: CGPointMake(686.57, 407.44)];
		[ingressNorthPath addCurveToPoint: CGPointMake(754, 371.5) controlPoint1: CGPointMake(706.82, 401.27) controlPoint2: CGPointMake(735.2, 382.73)];
		[ingressNorthPath addCurveToPoint: CGPointMake(810.5, 339) controlPoint1: CGPointMake(768.98, 362.55) controlPoint2: CGPointMake(803.25, 353.43)];
		[ingressNorthPath addCurveToPoint: CGPointMake(857.5, 232.5) controlPoint1: CGPointMake(828.4, 303.37) controlPoint2: CGPointMake(846.95, 261.49)];
		[ingressNorthPath addCurveToPoint: CGPointMake(863.5, 160.5) controlPoint1: CGPointMake(872.33, 191.78) controlPoint2: CGPointMake(869.14, 182.93)];
		[ingressNorthPath addCurveToPoint: CGPointMake(993.5, 122) controlPoint1: CGPointMake(858.16, 139.27) controlPoint2: CGPointMake(833.2, 86.48)];
		[ingressNorthPath addCurveToPoint: CGPointMake(1046.5, 132.5) controlPoint1: CGPointMake(1002.5, 123.99) controlPoint2: CGPointMake(1046.5, 132.5)];
		
	
		// END COPY FROM PAINT CODE

		
		
		// copy new paths from paint code above into array
		UIBezierPath*revrsePth = [ingressWest90Path bezierPathByReversingPath];

		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = revrsePth;
		[_bezierPaths addObject:pathItem];
		
		revrsePth = [ingressWestPath bezierPathByReversingPath];
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = revrsePth;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = egressWest90Path;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = egressWestPath;
		[_bezierPaths addObject:pathItem];
		
		revrsePth = [egressSouthPath bezierPathByReversingPath];
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = revrsePth;
		[_bezierPaths addObject:pathItem];
		
		revrsePth = [egressNorthPath bezierPathByReversingPath];
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = revrsePth;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathRed;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = ingressSouthPath;
		[_bezierPaths addObject:pathItem];
		
		pathItem = [[embBezierPathItem alloc] init];
		pathItem.pathDelay = 1.0;
		pathItem.pathColor = pathBlue;
		pathItem.pathSpeed = pathSpeed;
		pathItem.pathWidth = pathWidth;
		pathItem.embPath = ingressNorthPath;
		[_bezierPaths addObject:pathItem];
	
	}
	
	return self;
}

@end
