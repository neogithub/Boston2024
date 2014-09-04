//
//  ebZoomingScrollView.h
//  quadrangle
//
//  Created by Evan Buxton on 6/27/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@class embOverlayScrollView;

@protocol embOverlayScrollViewDelegate
-(void)didRemove:(embOverlayScrollView *)customClass;

@end

@interface embOverlayScrollView : UIView <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
	CGFloat maximumZoomScale;
	CGFloat minimumZoomScale;
}
 
- (id)initWithFrame:(CGRect)frame image:(UIImage*)thisImage overlay:(NSString*)secondImage shouldZoom:(BOOL)zoomable;
- (void)zoomToPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated;
- (void)resetPinSize;
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated duration:(float)duration;
@property (assign) BOOL canZoom;
@property (nonatomic, strong) NSString *overlay;
@property (nonatomic, strong) UIImage *firstImg;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) UIImageView *overView;
@property (assign) BOOL imageToggle;
// define delegate property
@property (nonatomic, assign) id  delegate;
@property (nonatomic, readwrite) BOOL  closeBtn;
@property (nonatomic, strong) UIView *uiv_windowComparisonContainer;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
// define public functions
-(void)didRemove;
-(void)resetScroll;

@end
