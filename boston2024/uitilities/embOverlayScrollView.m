//
//  ebZoomingScrollView.m
//  quadrangle
//
//  Created by Evan Buxton on 6/27/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embOverlayScrollView.h"

@interface embOverlayScrollView () <UIScrollViewDelegate>


@end

@implementation embOverlayScrollView
@synthesize scrollView = _scrollView;
@synthesize blurView = _blurView;
@synthesize canZoom;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)thisImage overlay:(NSString*)secondImage shouldZoom:(BOOL)zoomable;
{
	self = [super initWithFrame:frame];
	if (self) {
		if (nil == _scrollView) {
			
			_scrollView = [[UIScrollView alloc] initWithFrame:frame];
			[_scrollView setBackgroundColor:[UIColor whiteColor]];
			_scrollView.delegate = self;
			
			_blurView = [[UIImageView alloc] initWithFrame:self.bounds];
			[_blurView setContentMode:UIViewContentModeScaleAspectFit];
			_blurView.image = thisImage;
			_firstImg = _blurView.image;
			[_blurView setUserInteractionEnabled:YES];
			
			// Note here you should size the container view appropriately and layout backgroundImage and image accordingly.
			_uiv_windowComparisonContainer = [[UIView alloc] initWithFrame:_blurView.bounds];
			[_uiv_windowComparisonContainer addSubview:_blurView];
				
			_scrollView.contentSize = _uiv_windowComparisonContainer.frame.size;
			[_scrollView addSubview:_uiv_windowComparisonContainer];
			
			//[self addSubview:_scrollView];
			[self zoomableScrollview:self withImage:_blurView];
			
			
//			_scrollView = [[UIScrollView alloc] initWithFrame:frame];
//			_scrollView.delegate = self;
//			[_scrollView setBackgroundColor:[UIColor whiteColor]];
//			[self addSubview:_scrollView];
//			_blurView = [[UIImageView alloc] initWithFrame:self.bounds];
//			[_blurView setContentMode:UIViewContentModeScaleAspectFit];
//			_blurView.image = thisImage;
//			_firstImg = _blurView.image;
//			[_blurView setUserInteractionEnabled:YES];
//			[self zoomableScrollview:self withImage:_blurView];
			
			if (zoomable==1) {
				[self unlockZoom];
			} else {
				[self lockZoom];
			}
			
			_overlay = secondImage;
		}
	}
	return self;
}

-(void)lockZoom
{
    maximumZoomScale = self.scrollView.maximumZoomScale;
    minimumZoomScale = self.scrollView.minimumZoomScale;
	
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
}

-(void)unlockZoom
{
	
    self.scrollView.maximumZoomScale = 4;
    self.scrollView.minimumZoomScale = 1;
	
}

-(void)resetScroll {
	_scrollView.zoomScale=1.0;
}


-(void)setCloseBtn:(BOOL)closeBtn
{
    if (closeBtn != NO) {
        UIButton *h = [UIButton buttonWithType:UIButtonTypeCustom];
		h.frame = CGRectMake(1024-20-33, 20, 33, 33);
		[h setTitle:@"X" forState:UIControlStateNormal];
		h.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
		[h setBackgroundImage:[UIImage imageNamed:@"ui_btn_mm_default.png"] forState:UIControlStateNormal];
		[h setBackgroundImage:[UIImage imageNamed:@"ui_btn_mm_select.png"] forState:UIControlStateHighlighted];
		[h setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		//set their selector using add selector
		[h addTarget:self action:@selector(removeRenderScroll:) forControlEvents:UIControlEventTouchUpInside];
		[_uiv_windowComparisonContainer insertSubview:h aboveSubview:self];
		[self addSubview:h];
    }
}

-(void)zoomableScrollview:(id)sender withImage:(UIImageView*)thisImage
{
	//NSLog(@"sender tag %i",[sender tag]);
	

	// setup scrollview
	//_scrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
	[self addSubview:_scrollView];
	_scrollView.alpha=0.0;

	self.scrollView.tag = 11000;
	//Pinch Zoom Stuff
	_scrollView.maximumZoomScale = 4.0;
	_scrollView.minimumZoomScale = 1.0;
	_scrollView.clipsToBounds = YES;
	//_scrollView.delegate = self;
	_scrollView.scrollEnabled = YES;

	//[_uiv_windowComparisonContainer addSubview:_scrollView];
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchImage:)];
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomMyPlan:)];

	[singleTap requireGestureRecognizerToFail:doubleTap];
	[doubleTap setDelaysTouchesBegan : YES];
	[singleTap setDelaysTouchesBegan : YES];
	
	singleTap.numberOfTapsRequired = 1;
	[doubleTap setNumberOfTapsRequired:2];

	[singleTap setDelegate:self];
	[doubleTap setDelegate:self];

	[_scrollView addGestureRecognizer:singleTap];
	[_scrollView addGestureRecognizer:doubleTap];
	
	//NSLog(@"%@ render",renderImageView);
	
//	[self.scrollView setContentMode:UIViewContentModeScaleAspectFit];
//	self.scrollView.frame = CGRectMake(0, 0, 1024, 768);
//	[_scrollView addSubview:thisImage];
	
//	UIButton *h = [UIButton buttonWithType:UIButtonTypeCustom];
//	h.frame = CGRectMake(1024-20-33, 20, 33, 33);
//	[h setTitle:@"X" forState:UIControlStateNormal];
//	h.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
//	[h setBackgroundImage:[UIImage imageNamed:@"ui_btn_mm_default.png"] forState:UIControlStateNormal];
//	[h setBackgroundImage:[UIImage imageNamed:@"ui_btn_mm_select.png"] forState:UIControlStateHighlighted];
//	[h setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//	//set their selector using add selector
//	[h addTarget:self action:@selector(removeRenderScroll:) forControlEvents:UIControlEventTouchUpInside];
//	[_uiv_windowComparisonContainer insertSubview:h aboveSubview:self];
	
	//self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
	
	_scrollView.transform = CGAffineTransformMakeScale(0.85, 0.85);

	//[self addSubview:_uiv_windowComparisonContainer];
	
	UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
	
	[UIView animateWithDuration:0.3 delay:0.0 options:options
					 animations:^{
						 _scrollView.alpha=1.0;
						 _scrollView.transform = CGAffineTransformIdentity;
					 }
					 completion:^(BOOL  completed){
					 }];
	
}

-(void)switchImage:(UITapGestureRecognizer *)sender {
	
	// 1 determine which to zoom
	UIScrollView *tmp;
	
	tmp = _scrollView;
	
    if(_imageToggle == NO)
    {
		if (_overlay) {
			NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_overlay];
			
			UIImage * toImage = [UIImage imageWithContentsOfFile:path];
			[UIView transitionWithView:self
							  duration:0.33f
							   options:UIViewAnimationOptionTransitionCrossDissolve
							animations:^{
								self.blurView.image = toImage;
							} completion:NULL];
		}
        _imageToggle = YES;
    } else {
		if (_overlay) {
			
			[UIView transitionWithView:self
							  duration:0.33f
							   options:UIViewAnimationOptionTransitionCrossDissolve
							animations:^{
								self.blurView.image = _firstImg;
							} completion:NULL];
		}
		_imageToggle = NO;
	}
}


-(void)zoomMyPlan:(UITapGestureRecognizer *)sender {
	
	// 1 determine which to zoom
	UIScrollView *tmp;
	
	tmp = _scrollView;
	
	CGPoint pointInView = [sender locationInView:tmp];
	
	// 2
	CGFloat newZoomScale = tmp.zoomScale * 2.0f;
	newZoomScale = MIN(newZoomScale, tmp.maximumZoomScale);
	
	// 3
	CGSize scrollViewSize = tmp.bounds.size;
	
	CGFloat w = scrollViewSize.width / newZoomScale;
	CGFloat h = scrollViewSize.height / newZoomScale;
	CGFloat x = pointInView.x - (w / 2.0f);
	CGFloat y = pointInView.y - (h / 2.0f);
	CGRect rectToZoomTo = CGRectMake(x, y, w, h);
	// 4
	
    if (tmp.zoomScale > 1.9) {
        [tmp setZoomScale: 1.0 animated:YES];
		
    } else if (tmp.zoomScale < 2) {
		[tmp zoomToRect:rectToZoomTo animated:YES];
		
    }
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	//return uiiv_contentBG;
	return _uiv_windowComparisonContainer;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
	
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
	
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
	
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


-(void)removeRenderScroll:(id)sender {
	UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction  | UIViewAnimationOptionCurveEaseInOut;
	
	[UIView animateWithDuration:0.3 delay:0.0 options:options
					 animations:^{
						 _uiv_windowComparisonContainer.alpha=0.0;
						 _uiv_windowComparisonContainer.transform = CGAffineTransformScale(_uiv_windowComparisonContainer.transform, 0.5, 0.5);
					 }
					 completion:^(BOOL  completed){
						 [_uiv_windowComparisonContainer removeFromSuperview];
						 _uiv_windowComparisonContainer = nil;
						 [_scrollView removeFromSuperview];
						 [self didRemove];
					 }];
}

- (void)zoomToPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated
{
    //Normalize current content size back to content scale of 1.0f
    CGSize contentSize;
    contentSize.width = (_scrollView.contentSize.width / _scrollView.zoomScale);
    contentSize.height = (_scrollView.contentSize.height / _scrollView.zoomScale);
    
    //translate the zoom point to relative to the content rect
    zoomPoint.x = (zoomPoint.x / self.bounds.size.width) * contentSize.width;
    zoomPoint.y = (zoomPoint.y / self.bounds.size.height) * contentSize.height;
    
    //derive the size of the region to zoom to
    CGSize zoomSize;
    zoomSize.width = self.bounds.size.width / scale;
    zoomSize.height = self.bounds.size.height / scale;
    
    //offset the zoom rect so the actual zoom point is in the middle of the rectangle
    CGRect zoomRect;
    zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0f;
    zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0f;
    zoomRect.size.width = zoomSize.width;
    zoomRect.size.height = zoomSize.height;
    
    //apply the resize
    [_scrollView zoomToRect: zoomRect animated: animated];
}

- (void)resetPinSize {
    for (UIView *dropPinView in _blurView.subviews) {
        CGRect oldFrame = dropPinView.frame;
        dropPinView.frame = oldFrame;
        dropPinView.transform = CGAffineTransformMakeScale(1.0/_scrollView.zoomScale, 1.0/_scrollView.zoomScale);
    }
}
#pragma mark - Delegate methods 
-(void)didRemove {
    // send message the message to the delegate!
    [delegate didRemove:self];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UIView *dropPinView in _blurView.subviews) {
        CGRect oldFrame = dropPinView.frame;
        // 0.5 means the anchor is centered on the x axis. 1 means the anchor is at the bottom of the view. If you comment out this line, the pin's center will stay where it is regardless of how much you zoom. I have it so that the bottom of the pin stays fixed. This should help user RomeoF.
        //[dropPinView.layer setAnchorPoint:CGPointMake(0.5, 1)];
		//        [dropPinView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        dropPinView.frame = oldFrame;
        // When you zoom in on scrollView, it gets a larger zoom scale value.
        // You transform the pin by scaling it by the inverse of this value.
        dropPinView.transform = CGAffineTransformMakeScale(1.0/_scrollView.zoomScale, 1.0/_scrollView.zoomScale);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"\n\n The zoom scale is %f", _scrollView.zoomScale);
    CGRect visibleRect = [_scrollView convertRect:scrollView.bounds toView:_blurView];
    NSLog(@"\n\n x:%f \ny:%f \nwidth:%f \nheight:%f", visibleRect.origin.x,visibleRect.origin.y, visibleRect.size.width, visibleRect.size.height);
}

- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated duration:(float)duration
{
    [UIView animateWithDuration:(animated?duration:0.0f)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [_scrollView zoomToRect:rect animated:NO];
                     }
                     completion:nil];
}

@end