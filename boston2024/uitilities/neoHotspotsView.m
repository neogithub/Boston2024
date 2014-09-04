//
//  neoHotspotsView.m
//  neoHotspots
//
//  Created by Xiaohe Hu on 9/26/13.
//  Copyright (c) 2013 Xiaohe Hu. All rights reserved.
//

#import "neoHotspotsView.h"

//Change Size of Arrow Here!
static int arwPic = 30;

@implementation neoHotspotsView


@synthesize delegate ,uiiv_hsImgView, uiiv_arwImgView, arwAngle, hotspotBgName;
@synthesize bgColor, timeRotate, str_labelText, uil_caption;
@synthesize tagOfHs, str_typeOfHs;
@synthesize labelAlignment;

#pragma -mark Setting parameters
// Get parameter for time of rotate animation
-(void)setTimeRotate:(float)timeR
{
    if (timeR) {
        timeRotate = timeR;
    }
    if (timeR == 0.0f) {
        timeRotate = timeR;
    }
    timeIsSet = YES;
    [self checkAinimationTime];
}
// Get label's text (if there is no caption text the label won't be init)
-(void)setStr_labelText:(NSString *)labelText
{
    if (labelText == nil) {
        return;
    }
    else
    {
    str_labelText = labelText;
    [self initHotspotLabel];
    }
}
//Get different mode of label's alignment
-(void)setLabelAlignment:(HotspotCaptionAlignment)labelAlign
{
    labelAlignment = labelAlign;
    [uil_caption removeFromSuperview];
    [self initHotspotLabel];
}

// Get angle of arrow
-(void)setArwAngle:(float)angle
{
    if (angle) {
        arwAngle = angle;
        [self checkAinimationTime];
    }
    if (angle == 0.0) {
        arwAngle = angle;
        [self checkAinimationTime];
    }
    else
    {
        withArw = NO;
    }
}
// Get types of hotspots
-(void)setStr_typeOfHs:(NSString *)str_type
{
    str_typeOfHs = str_type;
}
// Get tags of hotspots (Usually it's index of plist)
-(void)setTagOfHs:(int)tagOfHotspot
{
    tagOfHs = tagOfHotspot;
    uiiv_hsImgView.tag = tagOfHotspot;
}
// Get background color of hotspots
-(void)setBgColor:(UIColor *)bg
{
    bgColor = bg;
    [self checkBgImg];
}

//++++++++++++++++++++FIX THIS BUG WIHT BG COLOR FUNCTIONS!!!!!!++++++++++++++++++++++++++++++++++
//-(void)setBackgroundColor:(UIColor *)backgroundColor
//{
//    bgColor = backgroundColor;
//    [self checkBgImg];
//    return;
//}

// Get background image file's name
-(void)setHotspotBgName:(NSString *)BgName
{
    if (BgName == nil) {
        return;
    }
    else
    {
        hotspotBgName = BgName;
        [self checkBgImg];
    }
}

#pragma -mark Check Different Conditions
// According to the parameter of animation rotate the arrow with different methods.
-(void)checkAinimationTime
{
    if (timeIsSet == YES && timeRotate != 0) {
        [uiiv_arwImgView removeFromSuperview];
        [self initArrowImgView];
        [self rotateViewAnimated:uiiv_arwImgView withDuration:self.timeRotate byAngle:(arwAngle/360)*2*M_PI];
        //uiiv_arwImgView.transform = CGAffineTransformMakeRotation((arwAngle/360)*2*M_PI);
    }
    else if (timeIsSet == YES && timeRotate == 0)
    {
        [uiiv_arwImgView removeFromSuperview];
        [self initArrowImgView];
        [self rotateViewAnimated:uiiv_arwImgView withDuration:self.timeRotate byAngle:(arwAngle/360)*2*M_PI];
        //uiiv_arwImgView.transform = CGAffineTransformMakeRotation((arwAngle/360)*2*M_PI);
        
    }
    else if (withArw == NO)
    {
        return;
    }
    else
    {
        [uiiv_arwImgView removeFromSuperview];
        [self initArrowImgView];
        uiiv_arwImgView.transform = CGAffineTransformMakeRotation((arwAngle/360)*2*M_PI);
    }
}
// If there is no background image make it a square with a color.
-(void)checkBgImg
{
    if (hotspotBgName == nil) {
        [self setBackgroundColor:bgColor];
    }
    else
    {
        [self addBgImgToHotspot];
    }
}

-(void)addBgImgToHotspot
{
    [self setBackgroundColor:[UIColor clearColor]];
    [uiiv_hsImgView setImage:[UIImage imageNamed:hotspotBgName]];
}

#pragma -mark Init Part
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initHotspotImgView];
        timeRotate = 0.0;
        withArw = YES;
        labelAlignment = CaptionAlignmentBottom;
        [self updateIndicators];
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
												 initWithTarget:self
												 action:@selector(hotspotWithTagTapped:)];
		[self addGestureRecognizer:tap];
//        [uil_caption addGestureRecognizer:tap];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*1.5, self.frame.size.height*1.5);
    }
    return self;
}

-(void)initHotspotImgView
{
    uiiv_hsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [uiiv_hsImgView setAlpha:1.0];
    [self addSubview: uiiv_hsImgView];
}

-(void)initArrowImgView
{
    //The track of arrow's animation is the circumference of hotspot's image(square)
    //According to the track, calculate X and Y
    float arwX = (uiiv_hsImgView.frame.size.width - arwPic)/2;
    float arwY = -((sqrt(2)-1)/2)* uiiv_hsImgView.frame.size.height- arwPic ;
    uiiv_arwImgView = [[UIImageView alloc] initWithFrame:CGRectMake(arwX, arwY, arwPic, arwPic)];
    
    //Change anchor point of arrow to the center of hotspot's image.
    float anchorX = 0.5;
    float anchorY =  (uiiv_hsImgView.frame.size.height * sqrt(2)/2)/uiiv_arwImgView.frame.size.height+1 ;
    uiiv_arwImgView.layer.anchorPoint = CGPointMake(anchorX, anchorY);
    
    /*After changing anchor point, relative position of arrow to hotspot was also changed. Reset the position of
    arrow according to the original relative position.*/
    float theDistance = uiiv_hsImgView.frame.size.height * sqrt(2)/2;
    CGRect frame = uiiv_arwImgView.frame;
    frame.origin.y = uiiv_arwImgView.frame.origin.y + uiiv_arwImgView.frame.size.height*0.5 + theDistance;
    uiiv_arwImgView.frame = frame;
    
    [uiiv_arwImgView setImage:[UIImage imageNamed:@"view-icon-cone.png"]];
    [self addSubview: uiiv_arwImgView];
    [uiiv_arwImgView setAlpha:1.0];
    
    //[self currentTag:uiiv_hsImgView.tag  andType:str_typeOfHs fromSender:self];
}

-(void)initHotspotLabel
{
    if (_withCaption) {
		[self updateIndicators];
		
		float textFontSize = 16.0f;
//		[uil_caption setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.55]];
        [uil_caption setBackgroundColor:[UIColor clearColor]];
		[uil_caption setText:str_labelText];
		uil_caption.textColor = [UIColor blackColor];
//		uil_caption.font=[uil_caption.font fontWithSize:textFontSize];
        [uil_caption setFont: [UIFont fontWithName:@"DINPro-CondBlack" size:textFontSize]];
//		[uil_caption setTextAlignment:NSTextAlignmentCenter];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(hotspotWithTagTapped:)];
		[uil_caption addGestureRecognizer:tap];
		[self insertSubview:uil_caption aboveSubview:uiiv_hsImgView];
	}
    
}

//According to different alignment mode change the location of label.
//By default the with of label is 2* with of hotspot hand label's height is /2 of hotspot.
- (void)updateIndicators
{
    float label_X = -1;
	float label_Y = -1;
	float label_W = -1;
	
	[uil_caption removeFromSuperview];
    if (labelAlignment == CaptionAlignmentTop)
    {
        label_X = uiiv_hsImgView.frame.origin.x - uiiv_hsImgView.frame.size.height/2;
        label_Y = uiiv_hsImgView.frame.origin.y - ((sqrt(2)+1)/2)* uiiv_hsImgView.frame.size.height;
        label_W = uiiv_hsImgView.frame.size.width*2;
        [uil_caption setTextAlignment:NSTextAlignmentCenter];
    }
    if (labelAlignment == CaptionAlignmentTopRight) {
        label_X = uiiv_hsImgView.frame.origin.x + uiiv_hsImgView.frame.size.width;
        label_Y = uiiv_hsImgView.frame.origin.y - uiiv_hsImgView.frame.size.height;
        label_W = uiiv_hsImgView.frame.size.width*2;
        [uil_caption setTextAlignment:NSTextAlignmentRight];
    }
    if (labelAlignment == CaptionAlignmentRight) {
        label_X = uiiv_hsImgView.frame.origin.x + ((sqrt(2)+1)/2)* uiiv_hsImgView.frame.size.width;
        label_Y = uiiv_hsImgView.frame.origin.y;
        label_W = uiiv_hsImgView.frame.size.width*2;
        [uil_caption setTextAlignment:NSTextAlignmentRight];
    }
    if (labelAlignment == CaptionAlignmentBottomRight) {
        label_X = uiiv_hsImgView.frame.origin.x + uiiv_hsImgView.frame.size.width;
        label_Y = uiiv_hsImgView.frame.origin.y + uiiv_hsImgView.frame.size.height;
        label_W = uiiv_hsImgView.frame.size.width*2;
        [uil_caption setTextAlignment:NSTextAlignmentRight];
    }
    if (labelAlignment == CaptionAlignmentBottom) {
        label_X = uiiv_hsImgView.frame.origin.x - uiiv_hsImgView.frame.size.height/2;
		label_Y = uiiv_hsImgView.frame.origin.y + ((sqrt(2)+1)/2)* uiiv_hsImgView.frame.size.height;
        label_W = uiiv_hsImgView.frame.size.width*2;
        [uil_caption setTextAlignment:NSTextAlignmentCenter];
    }
    if (labelAlignment == CaptionAlignmentBottomLeft) {
        label_X = uiiv_hsImgView.frame.origin.x - uiiv_hsImgView.frame.size.width*2;
        label_Y = uiiv_hsImgView.frame.origin.y + uiiv_hsImgView.frame.size.height;
        label_W = uiiv_hsImgView.frame.size.width*2;
        [uil_caption setTextAlignment:NSTextAlignmentLeft];
    }
    if (labelAlignment == CaptionAlignmentLeft) {
        label_X = uiiv_hsImgView.frame.origin.x - ((sqrt(2)-1)/2)* uiiv_hsImgView.frame.size.width - uiiv_hsImgView.frame.size.width*2;
        label_Y = uiiv_hsImgView.frame.origin.y;
        label_W = uiiv_hsImgView.frame.size.width*2;
        [uil_caption setTextAlignment:NSTextAlignmentLeft];
    }
    if (labelAlignment == CaptionAlignmentTopLeft) {
        label_X = uiiv_hsImgView.frame.origin.x - uiiv_hsImgView.frame.size.width*2;
        label_Y = uiiv_hsImgView.frame.origin.y - uiiv_hsImgView.frame.size.height;
        label_W = uiiv_hsImgView.frame.size.width*2;

        [uil_caption setTextAlignment:NSTextAlignmentLeft];
    }
	
	float label_H = uiiv_hsImgView.frame.size.height/2;
	uil_caption = [[KSLabel alloc] initWithFrame:CGRectMake(label_X, label_Y, label_W, label_H)];
    
    return;
}

// Rotate Animation fuction makes the arrow always rotates in clockwise direction.
// Duration time and rotate angle are needed.
- (void) rotateViewAnimated:(UIView*)view
               withDuration:(CFTimeInterval)duration
                    byAngle:(CGFloat)angle
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = 0;
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = duration;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [rotationAnimation setRemovedOnCompletion:NO];
    [rotationAnimation setFillMode:kCAFillModeForwards];
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/*
 If hotspots are wanted to be resized after doing something, please rebuild this function.
 
-(void)resizeToFitSubviews
{
    float w = 0;
    float h = 0;
    float x = 0;
    float y = 0;
    
    for (UIView *v in [self subviews]) {
        float fw = fabsf(v.frame.origin.x) + fabsf(v.frame.size.width);
        float fh = fabsf(v.frame.origin.y) + fabsf(v.frame.size.height);
        
        float fx = v.frame.origin.x;
        float fy = v.frame.origin.y;
        NSLog(@"fw: %f    fh: %f", fw, fh);
        NSLog(@"fx: %f    fy: %F", fx, fy);
        
        w = MAX(fw, w);
        h = MAX(fh, h);
        
        x = MIN(fx, x);
        y = MIN(fy, y);
    }
    
    NSLog(@"%@", [self description]);
}
*/

- (void)hotspotWithTagTapped:(UIGestureRecognizer*)recognizer
{
	[self.delegate neoHotspotsView:self didSelectItemAtIndex:tagOfHs];
}


@end
