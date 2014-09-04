//
//  embBezierPathItems.m
//  embAnimatedPath
//
//  Created by Evan Buxton on 2/19/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "embBezierPaths.h"
@implementation embBezierPaths

- (id) init
{
    if (self = [super init]) {
		
		// setup
		_bezierPaths = [[NSMutableArray alloc] init];
        NSMutableArray *orignalArr = [[NSMutableArray alloc] init];
		UIBezierPath *reversePath;
		
		UIColor *pathRed = [UIColor colorWithRed:169.0f/255.0f
										   green:20.0f/255.0f
											blue:23.0f/255.0f
										   alpha:1.0];
		
		UIColor *pathBlue = [UIColor colorWithRed:17/255.0f
											green:165.0f/255.0f
											 blue:241.0f/255.0f
											alpha:1.0];
		
		CGFloat pathWidth = 7.0;
		CGFloat pathSpeed = 3.5;
		

		// Bezier paths created in paintcode
		// COPY FROM PAINTCODE

		//// Lobby Drawing
		UIBezierPath* lobbyPath = [UIBezierPath bezierPath];
		[lobbyPath moveToPoint: CGPointMake(419.5, 706.5)];
		[lobbyPath addLineToPoint: CGPointMake(419.5, 647.5)];
		[lobbyPath addLineToPoint: CGPointMake(475.5, 642.5)];
		[lobbyPath addLineToPoint: CGPointMake(475.5, 708.5)];
		[lobbyPath addLineToPoint: CGPointMake(419.5, 706.5)];
		[lobbyPath closePath];
	
		
		
		//// City Target Drawing
		UIBezierPath* cityTargetPath = [UIBezierPath bezierPath];
		[cityTargetPath moveToPoint: CGPointMake(254, 624)];
		[cityTargetPath addLineToPoint: CGPointMake(240.5, 626.5)];
		[cityTargetPath addLineToPoint: CGPointMake(240.5, 601.5)];
		[cityTargetPath addLineToPoint: CGPointMake(227.5, 599.5)];
		[cityTargetPath addLineToPoint: CGPointMake(213.5, 604.5)];
		[cityTargetPath addLineToPoint: CGPointMake(213.5, 601.5)];
		[cityTargetPath addLineToPoint: CGPointMake(217.5, 599.5)];
		[cityTargetPath addLineToPoint: CGPointMake(254.5, 591.5)];
		[cityTargetPath addLineToPoint: CGPointMake(254, 624)];
		[cityTargetPath closePath];
		[cityTargetPath moveToPoint: CGPointMake(254, 663)];
		[cityTargetPath addLineToPoint: CGPointMake(241, 664)];
		[cityTargetPath addCurveToPoint: CGPointMake(241, 629) controlPoint1: CGPointMake(241, 664) controlPoint2: CGPointMake(240.93, 628.8)];
		[cityTargetPath addCurveToPoint: CGPointMake(254, 627) controlPoint1: CGPointMake(241.07, 629.2) controlPoint2: CGPointMake(254, 627)];
		[cityTargetPath addLineToPoint: CGPointMake(254, 663)];
		[cityTargetPath closePath];
		[cityTargetPath moveToPoint: CGPointMake(766, 613)];
		[cityTargetPath addLineToPoint: CGPointMake(765.78, 636.76)];
		[cityTargetPath addLineToPoint: CGPointMake(641.19, 550.03)];
		[cityTargetPath addLineToPoint: CGPointMake(607.5, 556.22)];
		[cityTargetPath addLineToPoint: CGPointMake(607.5, 566.57)];
		[cityTargetPath addLineToPoint: CGPointMake(641, 561)];
		[cityTargetPath addLineToPoint: CGPointMake(765.76, 638.97)];
		[cityTargetPath addLineToPoint: CGPointMake(765.51, 665.57)];
		[cityTargetPath addLineToPoint: CGPointMake(641.19, 633.26)];
		[cityTargetPath addLineToPoint: CGPointMake(256.47, 658.72)];
		[cityTargetPath addLineToPoint: CGPointMake(256.24, 624.96)];
		[cityTargetPath addLineToPoint: CGPointMake(419.5, 597.82)];
		[cityTargetPath addLineToPoint: CGPointMake(419.5, 590.81)];
		[cityTargetPath addLineToPoint: CGPointMake(256.21, 620.86)];
		[cityTargetPath addLineToPoint: CGPointMake(256, 589)];
		[cityTargetPath addLineToPoint: CGPointMake(641, 482)];
		[cityTargetPath addLineToPoint: CGPointMake(766, 613)];
		[cityTargetPath closePath];
		[cityTargetPath moveToPoint: CGPointMake(228, 673)];
		[cityTargetPath addLineToPoint: CGPointMake(211, 673)];
		[cityTargetPath addLineToPoint: CGPointMake(211, 608)];
		[cityTargetPath addLineToPoint: CGPointMake(215, 606)];
		[cityTargetPath addLineToPoint: CGPointMake(228, 603)];
		[cityTargetPath addLineToPoint: CGPointMake(228, 673)];
		[cityTargetPath closePath];
	
		
		
		//// Floor 3 Drawing
		UIBezierPath* floor3Path = [UIBezierPath bezierPath];
		[floor3Path moveToPoint: CGPointMake(359.26, 536.32)];
		[floor3Path addLineToPoint: CGPointMake(411.14, 519.67)];
		[floor3Path addLineToPoint: CGPointMake(411.14, 504)];
		[floor3Path addLineToPoint: CGPointMake(641.19, 423.71)];
		[floor3Path addLineToPoint: CGPointMake(765.51, 590.17)];
		[floor3Path addLineToPoint: CGPointMake(765.51, 605.84)];
		[floor3Path addLineToPoint: CGPointMake(641.19, 466.79)];
		[floor3Path addLineToPoint: CGPointMake(411.14, 534.36)];
		[floor3Path addLineToPoint: CGPointMake(411.14, 537.3)];
		[floor3Path addLineToPoint: CGPointMake(404.29, 533.38)];
		[floor3Path addLineToPoint: CGPointMake(359.26, 547.09)];
		[floor3Path addLineToPoint: CGPointMake(359.26, 536.32)];
		[floor3Path closePath];
	
		
		
		//// Floor 4 Drawing
		UIBezierPath* floor4Path = [UIBezierPath bezierPath];
		[floor4Path moveToPoint: CGPointMake(641.19, 373.77)];
		[floor4Path addLineToPoint: CGPointMake(411.14, 468.75)];
		[floor4Path addLineToPoint: CGPointMake(411.14, 487.36)];
		[floor4Path addLineToPoint: CGPointMake(359.26, 507.92)];
		[floor4Path addLineToPoint: CGPointMake(359.26, 528.48)];
		[floor4Path addLineToPoint: CGPointMake(411.14, 511.84)];
		[floor4Path addLineToPoint: CGPointMake(411.14, 494.21)];
		[floor4Path addLineToPoint: CGPointMake(641.19, 409.02)];
		[floor4Path addLineToPoint: CGPointMake(764.53, 584.3)];
		[floor4Path addLineToPoint: CGPointMake(764.53, 569.61)];
		[floor4Path addLineToPoint: CGPointMake(641.19, 373.77)];
		[floor4Path closePath];
	
		
		
		//// Floor 5 Drawing
		UIBezierPath* floor5Path = [UIBezierPath bezierPath];
		[floor5Path moveToPoint: CGPointMake(641.19, 322.85)];
		[floor5Path addLineToPoint: CGPointMake(411.14, 433.5)];
		[floor5Path addLineToPoint: CGPointMake(411.14, 454.06)];
		[floor5Path addLineToPoint: CGPointMake(359.26, 478.54)];
		[floor5Path addLineToPoint: CGPointMake(359.26, 499.11)];
		[floor5Path addLineToPoint: CGPointMake(411.14, 478.54)];
		[floor5Path addLineToPoint: CGPointMake(411.14, 458.96)];
		[floor5Path addLineToPoint: CGPointMake(641.19, 357.12)];
		[floor5Path addLineToPoint: CGPointMake(764.53, 563.73)];
		[floor5Path addLineToPoint: CGPointMake(764.53, 551.98)];
		[floor5Path addLineToPoint: CGPointMake(641.19, 322.85)];
		[floor5Path closePath];
	
		
		
		//// Floor 6 Drawing
		UIBezierPath* floor6Path = [UIBezierPath bezierPath];
		[floor6Path moveToPoint: CGPointMake(641.19, 270.95)];
		[floor6Path addLineToPoint: CGPointMake(411.14, 398.25)];
		[floor6Path addLineToPoint: CGPointMake(411.14, 421.75)];
		[floor6Path addLineToPoint: CGPointMake(359.26, 449.17)];
		[floor6Path addLineToPoint: CGPointMake(359.26, 470.71)];
		[floor6Path addLineToPoint: CGPointMake(411.14, 446.23)];
		[floor6Path addLineToPoint: CGPointMake(411.14, 424.69)];
		[floor6Path addLineToPoint: CGPointMake(641.19, 306.21)];
		[floor6Path addLineToPoint: CGPointMake(764.53, 546.11)];
		[floor6Path addLineToPoint: CGPointMake(764.53, 532.4)];
		[floor6Path addLineToPoint: CGPointMake(641.19, 270.95)];
		[floor6Path closePath];
	
		
		
		//// Floor 7 Drawing
		UIBezierPath* floor7Path = [UIBezierPath bezierPath];
		[floor7Path moveToPoint: CGPointMake(641.19, 220.04)];
		[floor7Path addLineToPoint: CGPointMake(411.14, 363)];
		[floor7Path addLineToPoint: CGPointMake(411.14, 375.73)];
		[floor7Path addLineToPoint: CGPointMake(411.14, 391.4)];
		[floor7Path addLineToPoint: CGPointMake(359.26, 420.77)];
		[floor7Path addLineToPoint: CGPointMake(359.26, 441.34)];
		[floor7Path addLineToPoint: CGPointMake(411.14, 413.92)];
		[floor7Path addLineToPoint: CGPointMake(411.14, 388.46)];
		[floor7Path addLineToPoint: CGPointMake(641.19, 256.27)];
		[floor7Path addLineToPoint: CGPointMake(764.53, 526.53)];
		[floor7Path addLineToPoint: CGPointMake(764.53, 513.8)];
		[floor7Path addLineToPoint: CGPointMake(641.19, 220.04)];
		[floor7Path closePath];
	
		
		
		//// Floor 8 Drawing
		UIBezierPath* floor8Path = [UIBezierPath bezierPath];
		[floor8Path moveToPoint: CGPointMake(641.19, 169.12)];
		[floor8Path addLineToPoint: CGPointMake(411.14, 326.77)];
		[floor8Path addLineToPoint: CGPointMake(411.14, 358.1)];
		[floor8Path addLineToPoint: CGPointMake(360.23, 390.42)];
		[floor8Path addLineToPoint: CGPointMake(360.23, 411.96)];
		[floor8Path addLineToPoint: CGPointMake(411.14, 381.6)];
		[floor8Path addLineToPoint: CGPointMake(411.14, 354.19)];
		[floor8Path addLineToPoint: CGPointMake(641.19, 204.37)];
		[floor8Path addLineToPoint: CGPointMake(764.53, 507.92)];
		[floor8Path addLineToPoint: CGPointMake(764.53, 495.19)];
		[floor8Path addLineToPoint: CGPointMake(641.19, 169.12)];
		[floor8Path closePath];
	
		
		
		//// Floor 9 Drawing
		UIBezierPath* floor9Path = [UIBezierPath bezierPath];
		[floor9Path moveToPoint: CGPointMake(641.19, 113.3)];
		[floor9Path addLineToPoint: CGPointMake(411.14, 288.58)];
		[floor9Path addLineToPoint: CGPointMake(411.14, 323.83)];
		[floor9Path addLineToPoint: CGPointMake(360.23, 358.1)];
		[floor9Path addLineToPoint: CGPointMake(360.23, 382.58)];
		[floor9Path addLineToPoint: CGPointMake(411.14, 349.29)];
		[floor9Path addLineToPoint: CGPointMake(411.63, 317.47)];
		[floor9Path addLineToPoint: CGPointMake(641.19, 153.45)];
		[floor9Path addLineToPoint: CGPointMake(764.53, 489.32)];
		[floor9Path addLineToPoint: CGPointMake(764.53, 474.63)];
		[floor9Path addLineToPoint: CGPointMake(641.19, 113.3)];
		[floor9Path closePath];
	
		
		
		//// Floor 10 Drawing
		UIBezierPath* floor10Path = [UIBezierPath bezierPath];
		[floor10Path moveToPoint: CGPointMake(641.19, 57.49)];
		[floor10Path addLineToPoint: CGPointMake(411.14, 250.39)];
		[floor10Path addLineToPoint: CGPointMake(411.14, 288.58)];
		[floor10Path addLineToPoint: CGPointMake(359.26, 326.77)];
		[floor10Path addLineToPoint: CGPointMake(359.26, 351.25)];
		[floor10Path addLineToPoint: CGPointMake(411.14, 314.04)];
		[floor10Path addLineToPoint: CGPointMake(411.14, 280.75)];
		[floor10Path addLineToPoint: CGPointMake(641.19, 98.62)];
		[floor10Path addLineToPoint: CGPointMake(764.53, 467.77)];
		[floor10Path addLineToPoint: CGPointMake(765.51, 455.04)];
		[floor10Path addLineToPoint: CGPointMake(641.19, 57.49)];
		[floor10Path closePath];
	
		
		
		//// Sky Terrace Drawing
		UIBezierPath* skyTerracePath = [UIBezierPath bezierPath];
		[skyTerracePath moveToPoint: CGPointMake(411.5, 226.5)];
		[skyTerracePath addLineToPoint: CGPointMake(640.5, 22.5)];
		[skyTerracePath addLineToPoint: CGPointMake(640.5, 46.5)];
		[skyTerracePath addLineToPoint: CGPointMake(411.5, 242.5)];
		[skyTerracePath addLineToPoint: CGPointMake(411.5, 226.5)];
		[skyTerracePath closePath];

		
		
		//// Residential Drawing
		UIBezierPath* residentialPath = [UIBezierPath bezierPath];
		[residentialPath moveToPoint: CGPointMake(358.5, 407.5)];
		[residentialPath addLineToPoint: CGPointMake(346.5, 399.5)];
		[residentialPath addLineToPoint: CGPointMake(342.5, 401.5)];
		[residentialPath addLineToPoint: CGPointMake(334.5, 397.5)];
		[residentialPath addLineToPoint: CGPointMake(326.5, 396.5)];
		[residentialPath addLineToPoint: CGPointMake(320.5, 400.5)];
		[residentialPath addLineToPoint: CGPointMake(289.5, 382.5)];
		[residentialPath addLineToPoint: CGPointMake(275.5, 379.5)];
		[residentialPath addLineToPoint: CGPointMake(266.5, 381.5)];
		[residentialPath addLineToPoint: CGPointMake(252.5, 391.5)];
		[residentialPath addLineToPoint: CGPointMake(238.5, 384.5)];
		[residentialPath addLineToPoint: CGPointMake(212.5, 408.5)];
		[residentialPath addLineToPoint: CGPointMake(213.5, 598.5)];
		[residentialPath addLineToPoint: CGPointMake(254.5, 586.5)];
		[residentialPath addLineToPoint: CGPointMake(254.5, 577.5)];
		[residentialPath addLineToPoint: CGPointMake(358.5, 546.5)];
		[residentialPath addLineToPoint: CGPointMake(358.5, 407.5)];
		[residentialPath closePath];
	


		
		// END COPY FROM PAINT CODE

		
		
		// copy new paths from paint code above into array
		// (reverse some of them as well)

		// INGRESS N & S
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathRed;
		pathItem.embPath = residentialPath;
		[orignalArr addObject:pathItem];
		
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathRed;
		pathItem.embPath = cityTargetPath;
		[orignalArr addObject:pathItem];
		
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathBlue;
		pathItem.embPath = lobbyPath;
		[orignalArr addObject:pathItem];
		
		
		// EGRESS N & S
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathBlue;
		pathItem.embPath = floor3Path;
		[orignalArr addObject:pathItem];
		
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathRed;
		pathItem.embPath = floor4Path;
		[orignalArr addObject:pathItem];
		
		
		
		// EGRESS W
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathBlue;
		pathItem.embPath = floor5Path;
		[orignalArr addObject:pathItem];
		
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathRed;
		pathItem.embPath = floor6Path;
		[orignalArr addObject:pathItem];
		
		
		
		// INGRESS W
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathBlue;
		pathItem.embPath = floor7Path;
		[orignalArr addObject:pathItem];
		
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathRed;
		pathItem.embPath = floor8Path;
		[orignalArr addObject:pathItem];
		
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathRed;
		pathItem.embPath = floor9Path;
		[orignalArr addObject:pathItem];
		
		pathItem = [[embBezierItem alloc] init];
		pathItem.pathColor = pathRed;
		pathItem.embPath = floor10Path;
		[orignalArr addObject:pathItem];
		
//		pathItem = [[embBezierItem alloc] init];
//		pathItem.pathColor = pathRed;
//		pathItem.embPath = skyTerracePath;
//		[orignalArr addObject:pathItem];
		
        
        _bezierPaths = [[orignalArr reverseObjectEnumerator] allObjects];
	
	}
	
	return self;
}

@end
