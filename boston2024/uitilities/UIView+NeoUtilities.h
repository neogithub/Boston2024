//
//  NeoUtilities.h
//  eb230park
//
//  Created by Evan Buxton on 1/3/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (neoutilities)

-(void)buttonsIn:(UIView*)thisView areAllSelected:(BOOL)selectState except:(id)sender;

#pragma mark
#pragma mark REMOVE BUTTONS IN SUBVIEW
-(void)remove:(NSString*)theseObjects from:(UIView*)thisView;

#pragma mark Utilities : alpha of Views
-(void)fadeViews:(UIView*)view visibility:(BOOL)state animate:(BOOL)kanimate pop:(BOOL)kpop remove:(BOOL)delete;
-(void)removeView:(UIView*)viewToRemove;

#pragma position
//http://bynomial.com/blog/?p=24
@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

#pragma heirarchy
// http://www.touch-code-magazine.com/uivewi-category-to-manage-z-order-of-views/
-(int)getSubviewIndex;

-(void)bringToFront;
-(void)sendToBack;

-(void)bringOneLevelUp;
-(void)sendOneLevelDown;

-(BOOL)isInFront;
-(BOOL)isAtBack;

-(void)swapDepthsWithView:(UIView*)swapView;

// center
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX ;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY;
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY;

// scale to center
-(void)scaleTocenter:(UIView*)centerView fromHere:(id)sender;

// set anchor
-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;

//http://www.raywenderlich.com/5478/uiview-animation-tutorial-practical-recipes
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;

//http://iobjectivesee.com
- (void)addShadow;
- (void)removeShadow;
- (void)showBounce;
- (void)drawGradiant:(CGRect)rect colors:(NSArray *)inColors;

// uiviewtransistions
- (void)crossfadeFrom:(UIView*)fromView to:(UIView*)toView duration:(CGFloat)time;

@end
