//
//  ebSimpleScrollView.h
//  quadrangle
//
//  Created by Evan Buxton on 6/28/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ebScrollHelpView.h"
@class embSimpleScrollView;

@protocol embSimpleScrollViewDelegate
@optional
-(void)didRemove:(embSimpleScrollView *)customClass;
- (void)currentImageAtIndex:(NSUInteger)index fromSender:(UIScrollView*)scroll;
- (void)didStopScrolling:(UIScrollView*)scroll;
@end

@interface embSimpleScrollView : UIScrollView <UIScrollViewDelegate,UIGestureRecognizerDelegate, ebScrollHelpViewDelegate>
{
	CGFloat maximumZoomScale;
	CGFloat minimumZoomScale;
    
    BOOL    autoPlay;
    BOOL    loopArray;
    BOOL    timeIsSet;
    BOOL    showDots;
    
    int     offSet;
    float   stayTime;
    float   slideTime;
    
    NSTimer *defaultTimer;
    NSTimer *customizedTimer;
	NSMutableArray	*imgArray;
}
- (id)initWithFrame:(CGRect)frame closeBtnLoc:(CGRect)btnFrame btnImg:(NSString*)btnNamed boolBtn:(BOOL)showBtn bgImg:(NSString*)bgNamed andArray:(NSArray*)images andTag:(int)myTag;
-(int)currenScrollPage:(UIScrollView*)scroll;
//-(void)setAutoPlay:(BOOL)flag;
//-(void)autoPlayScr;

@property (nonatomic, strong, readonly) UIScrollView *uis_scrollView;
// define delegate property
@property (nonatomic, assign) id    delegate;

@property (nonatomic, readwrite) BOOL  autoPlay;
@property (nonatomic, readwrite) BOOL  loopArray;
@property (nonatomic, readwrite) BOOL  showDots;
//@property (nonatomic, readwrite) BOOL  hideHelpBox;
@property (nonatomic, readwrite) float stayTime;
@property (nonatomic, readwrite) float slideTime;

@property (nonatomic, strong) NSTimer *autoTimer;
// default is slide
@property NSUInteger startIndex;
@property BOOL withButton;
@property (nonatomic, strong) NSString* btnBG;
// define public functions
-(void)didRemove;
-(void)didStopScrolling;
-(void)openScrollViewAtPage:(int)index;
@end

