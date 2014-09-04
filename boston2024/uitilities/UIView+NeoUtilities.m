//
//  NeoUtilities.m
//  eb230park
//
//  Created by Evan Buxton on 1/3/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "UIView+NeoUtilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (neoutilities)

#pragma mark 
#pragma mark ALL BUTTONS IN SUBVIEW SELECTED/UNSELECTED

-(void)buttonsIn:(UIView*)thisView areAllSelected:(BOOL)selectState except:(id)sender {
	for (UIView *tmpView in [thisView subviews]) {
		if ([tmpView isKindOfClass:[UIButton class]]) {
			[(UIButton*)tmpView setSelected:selectState];
		}
	}
	[sender setSelected:YES];
}

#pragma mark 
#pragma mark REMOVE BUTTONS IN SUBVIEW

-(void)remove:(NSString*)theseObjects from:(UIView*)thisView {
	
	Class this = NSClassFromString( theseObjects );
	
	for (UIView *tmpView in [thisView subviews]) {
		if ([tmpView isKindOfClass:[this class]]) {
			[tmpView removeFromSuperview];
		}
	}
}

///

#pragma mark Utilities : alpha of Views

-(void)fadeViews:(UIView*)view visibility:(BOOL)state animate:(BOOL)kanimate pop:(BOOL)kpop remove:(BOOL)delete
{
	
	if (kanimate==NO) { // just for hiding
		view.hidden = !state;
		return;
	}
	
	UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
	[UIView animateWithDuration:0.3 delay:0.0 options:options
					 animations:^{
						 float myAlpha = (state ? 1.0 : 0.0);
						 view.alpha = myAlpha;
						 
						float myShrink = (kpop ? 0.5 : 1.0);
						view.transform = CGAffineTransformMakeScale(myShrink, myShrink);
						 
					 }
					 completion:^(BOOL finished){
						 if (delete==YES)[self removeView:view];
					 }];
}

-(void)removeView:(UIView*)viewToRemove {
	[viewToRemove removeFromSuperview];
	viewToRemove=nil;
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
	
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
	
    CGPoint position = view.layer.position;
	
    position.x -= oldPoint.x;
    position.x += newPoint.x;
	
    position.y -= oldPoint.y;
    position.y += newPoint.y;
	
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark - position
//http://bynomial.com/blog/?p=24

- (CGPoint)frameOrigin {
	return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
	self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
	return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newSize.width, newSize.height);
}

- (CGFloat)frameX {
	return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
	self.frame = CGRectMake(newX, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
	return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
	self.frame = CGRectMake(self.frame.origin.x, newY,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
	self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
	self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
							self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
	return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
	return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
							self.frame.size.width, newHeight);
}

// hierarchy
#pragma mark - hierarchy
-(int)getSubviewIndex
{
	return [self.superview.subviews indexOfObject:self];
}

-(void)bringToFront
{
	[self.superview bringSubviewToFront:self];
}

-(void)sendToBack
{
	[self.superview sendSubviewToBack:self];
}

-(void)bringOneLevelUp
{
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

-(void)sendOneLevelDown
{
	int currentIndex = [self getSubviewIndex];
	[self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

-(BOOL)isInFront
{
	return ([self.superview.subviews lastObject]==self);
}

-(BOOL)isAtBack
{
	return ([self.superview.subviews objectAtIndex:0]==self);
}

-(void)swapDepthsWithView:(UIView*)swapView
{
	[self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
	return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
	return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark - scale to center
-(void)scaleTocenter:(UIView*)centerView fromHere:(id)sender {
	[self setUserInteractionEnabled:NO];
	NSLog(@"02 scaleTocenter");
	UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
	[UIView animateWithDuration:0.3 delay:0.0 options:options
					 animations:^{
						 //move zoomed view to center
						 CGRect contentRect = CGRectMake(0, 0, 1024, 768);
						 self.bounds = contentRect;
						 centerView.center = CGPointMake(512, 384);
						 centerView.transform = CGAffineTransformMakeScale(2.50, 2.50);
					 }
					 completion:^(BOOL finished){
						 centerView.alpha = 1.0;
						 [self setUserInteractionEnabled:YES];
					 }];
}

// animation form ray wenderlich
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
					 animations:^{
						 self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
					 }
					 completion:nil];
}



- (void)addShadow {
    if (self.layer.shadowOpacity == 0 && self.frameWidth > 0) {
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowRadius = 10.0f;
        CGRect path = CGRectMake(10, self.frameHeight - 15, self.frameWidth -20, 25);
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:path] CGPath];
		
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        anim.fromValue = [NSNumber numberWithFloat:0.0];
        anim.toValue = [NSNumber numberWithFloat:1.0];
        anim.duration = .2;
        [self.layer addAnimation:anim forKey:@"shadowOpacity"];
        self.layer.shadowOpacity = 1.0;
    }
}

- (void)removeShadow {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:1.0];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = .2;
    [self.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.layer.shadowOpacity = 0.0;
}

- (void)showBounce {
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithDuration:0.1 animations:^{self.alpha = 1.0;}];
    self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
	
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.3;
    bounceAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
	
    self.layer.transform = CATransform3DIdentity;
}

- (void)drawGradiant:(CGRect)rect colors:(NSArray *)inColors{
	
    CGFloat colors[[inColors count]*4];
    int i = 0;
    for (UIColor *item in inColors) {
        CGFloat newComponents[4] = {};
        memcpy(newComponents, CGColorGetComponents([item CGColor]), sizeof(newComponents));
        colors[i++] = newComponents[0];
        colors[i++] = newComponents[1];
        colors[i++] = newComponents[2];
        colors[i++] = newComponents[3];
    }
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextSaveGState(context);
    CGContextClipToRect(context, rect);
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(rect.origin.x, rect.size.height);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
}

-(void)crossfadeFrom:(UIView*)fromView to:(UIView*)toView duration:(CGFloat)time
{
	[UIView beginAnimations:nil context:NULL]; {
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:time];
		[UIView setAnimationDelegate:self];
		fromView.alpha = 0.0; toView.alpha = 1.0;
	} [UIView commitAnimations];
}

@end
