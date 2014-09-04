//
//  UIColor+Extensions.m
//  650mad
//
//  Created by Evan Buxton on 9/27/12.
//
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

#pragma mark
#pragma mark description

+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    return [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

// return [UIColor colorWithHueDegrees:197 saturation:1.00 brightness:0.66];
// return [UIColor colorWithR:0 G:165 B:198 A:1];

+ (UIColor *)aecomButtonHighlightColor {
	return [UIColor colorWithR:211 G:32 B:39 A:1];
}

+ (UIColor *)aecomButtonColor {
	return [UIColor colorWithR:163 G:167 B:169 A:1];
}

+ (UIColor *)aecomButtonTitleColor {
	return [UIColor colorWithR:0 G:13 B:20 A:1];
}

+ (UIColor *)aecomPlayButtonTintColor {
	return [UIColor colorWithR:50 G:15 B:18 A:1];
}

+ (UIColor *)randomColor {
    return [self colorWithRed:((float)rand() / RAND_MAX)
                        green:((float)rand() / RAND_MAX)
                         blue:((float)rand() / RAND_MAX)
                        alpha:1.0f];
}

// use self.view.backgroundColor = highlight? [UIColor paleYellowColor] : [UIColor whitecolor];

@end
