//
//  xhanchorPointHotspots.m
//  xhAnchorPointHotspots
//
//  Created by Xiaohe Hu on 3/5/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xhanchorPointHotspots.h"
#import <QuartzCore/QuartzCore.h>
@implementation xhanchorPointHotspots
@synthesize str_hotspotImage;
@synthesize anchorPosition;
@synthesize delegate;
-(void)setStr_hotspotImage:(NSString *)hotspotImage
{
    str_hotspotImage = hotspotImage;
    [self updateBGImg: str_hotspotImage];
}
-(void)setAnchorPosition:(anchorPointPosition)anchor
{
    anchorPosition = anchor;
    [self updateAnchorPoint];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateBGImg:(NSString *) imgName
{
    UIImage *bgImage = [UIImage imageNamed:imgName];
    uiiv_bgImg = [[UIImageView alloc] initWithImage:bgImage];
    uiiv_bgImg.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    CGRect frame = self.frame;
    frame.size.width = uiiv_bgImg.frame.size.width;
    frame.size.height = uiiv_bgImg.frame.size.height;
    self.frame = frame;
    [self addSubview: uiiv_bgImg];
}
-(void)updateAnchorPoint
{
    float anchorX;
    float anchorY;
    CGRect frame = self.frame;
    if (anchorPosition == AnchorPositionTopLeft) {
        anchorX = 0;
        anchorY = 0;
    }
    if (anchorPosition == AnchorPositionBottomLeft) {
        anchorX = 0;
        anchorY = 1;
    }
    if (anchorPosition == AnchorPositionBottomRight) {
        anchorX = 1;
        anchorY = 1;
    }
    if (anchorPosition == AnchorPositionTopRight) {
        anchorX = 1;
        anchorY = 0;
    }
    if (anchorPosition == AnchorPositionTop) {
        anchorX = 0.5;
        anchorY = 0;
    }
    if (anchorPosition == AnchorPositionLeft) {
        anchorX = 0;
        anchorY = 0.5;
    }
    if (anchorPosition == AnchorPositionBottom) {
        anchorX = 0.5;
        anchorY = 1;
    }
    if (anchorPosition == AnchorPositionRight) {
        anchorX = 1;
        anchorY = 0.5;
    }
    if (anchorPosition == AnchorPositionCenter) {
        anchorX = 0.5;
        anchorY = 0.5;
    }
    self.layer.anchorPoint = CGPointMake(anchorX, anchorY);
    self.frame = frame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
