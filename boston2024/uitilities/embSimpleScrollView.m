//
//  embSimpleScrollView.m
//  quadrangle
//
//  Created by Evan Buxton on 6/28/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+++++++++++++++++++++++++Attention!!++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//If autoPlay is turned on kill all the timer of the ScrView As Below!!
/*
-(void)viewWillDisappear:(BOOL)animated
{
    if (uis_teamProjectImages.autoTimer) {
    [uis_teamProjectImages.autoTimer invalidate];
    uis_teamProjectImages.autoTimer = nil;
 }
}
*/
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#import "embSimpleScrollView.h"
#import "SMPageControl.h"
//#import "UIView+NeoUtilities.h"

@interface embSimpleScrollView () <UIScrollViewDelegate>
//@property (nonatomic, strong, readonly) UIScrollView *uis_scrollView;
@property (nonatomic, strong) UIImageView *uiiv_infoView;
@property (nonatomic, strong) UIView *uiv_scrollHolder;
@property (strong, nonatomic) SMPageControl* uis_pageControl;
@property (strong, nonatomic) UIButton *h;
@property (nonatomic, assign) CGRect  frameOfScrView;
@property (nonatomic, strong) NSArray *arrayOfImages;

@property (nonatomic, readwrite) int pagesCounter;
@property (nonatomic, strong) ebScrollHelpView  *uiv_scrHelpView;
@end

@implementation embSimpleScrollView

@synthesize uis_scrollView = _uis_scrollView;
@synthesize uiiv_infoView = _uiiv_infoView;
@synthesize uiv_scrollHolder = _uiv_scrollHolder;
@synthesize delegate;
@synthesize autoPlay, loopArray, stayTime, slideTime, autoTimer, showDots;

#pragma  - mark scroll help delegate 
-(void)didRemove:(ebScrollHelpView *)customClass {
    
}
#pragma -mark Set & Get Bool Values
-(void)setStayTime:(float)stay
{
    if (stay) {
        timeIsSet = YES;
        stayTime = stay;
    }
    if (timeIsSet && autoPlay) {
        [self.autoTimer invalidate];
        [self checkAutoAndLoop];
    }
}
-(void)setSlideTime:(float)slide
{
    if (slide) {
        slideTime = slide;
    }
    else
    {
        slideTime = 0.6f;
    }
}
-(void)setAutoPlay:(BOOL)flagAutoPlay
{
    if (flagAutoPlay == NO) {
        return;
    }
    autoPlay = flagAutoPlay;
    NSLog(@"%i", autoPlay);
    if (autoPlay) {
        [self checkAutoAndLoop];
    }
    else
    {
        return;
    }
}
-(void)setLoopArray:(BOOL)flagLoop
{
    loopArray = flagLoop;
    [self initArray:self.arrayOfImages andFrame:self.frameOfScrView];
    [self checkAutoAndLoop];
}
-(void)setShowDots:(BOOL)show
{
    if (show == NO) {
        [_uis_pageControl removeFromSuperview];
    }
    
}
//-(void)setHideHelpBox:(BOOL)hideHelp
//{
//    _uiv_scrHelpView.hidden = hideHelp;
//}
-(void)baseInit
{
	_withButton=YES;
}

- (id)initWithFrame:(CGRect)frame closeBtnLoc:(CGRect)btnFrame btnImg:(NSString*)btnNamed boolBtn:(BOOL)showBtn bgImg:(NSString*)bgNamed andArray:(NSArray*)images andTag:(int)myTag
{
	self = [super initWithFrame:frame];
    
	if (self) {
//        NSLog(@"alloc");
        
        self.autoPlay  = NO;
        self.loopArray = NO;
        timeIsSet = NO;
//        self.hideHelpBox = YES;
        stayTime  = 2.0f;
        slideTime = 0.6f;
        
			[self baseInit];
		if (nil == _uiv_scrollHolder) {
			//NSLog(@"settip");
			_withButton=YES;
			_uiv_scrollHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
			[_uiv_scrollHolder setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:bgNamed]]];

			// setup scrollview
			_uis_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _uiv_scrollHolder.frame.size.width, _uiv_scrollHolder.frame.size.height)];
			self.uis_scrollView.tag = myTag;
			//Pinch Zoom Stuff
			_uis_scrollView.maximumZoomScale = 4.0;
			_uis_scrollView.minimumZoomScale = 1.0;
			_uis_scrollView.clipsToBounds = YES;
			_uis_scrollView.delegate = self;
			_uis_scrollView.scrollEnabled = YES;
			_uis_scrollView.pagingEnabled = YES;
			[_uis_scrollView setBackgroundColor:[UIColor whiteColor]];
			
			_uis_scrollView.layer.shadowColor = [[UIColor blackColor] CGColor];
			_uis_scrollView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
			_uis_scrollView.layer.shadowOpacity = 0.5f;
			_uis_scrollView.layer.shadowRadius = 15.0f;
			_uis_scrollView.layer.shouldRasterize = YES;
			_uis_scrollView.clipsToBounds = NO;
			
			[_uiv_scrollHolder addSubview:_uis_scrollView];

            if (loopArray == NO) {
                [self initArray:images andFrame:frame];
            }
            if (showDots == YES) {
                [self initPagingDotsDefault:images andFrame:frame];
            }
            self.frameOfScrView = frame;
            self.arrayOfImages = images;
            
			NSLog(@"_withButton = %@\n", (_withButton ? @"YES" : @"NO"));

			if (showBtn==YES) {
				_h = [UIButton buttonWithType:UIButtonTypeCustom];
				_h.frame = btnFrame;
				NSLog(@"_btnBG %@",btnNamed);
				[_h setTitle:@"CLOSE" forState:UIControlStateNormal];
				//_h.frame = CGRectMake(self.frame.size.width-73, -5, 73, 68);
				[_h setBackgroundImage:[UIImage imageNamed:btnNamed] forState:UIControlStateNormal];
//				[_h setBackgroundImage:[UIImage imageNamed:btnNamed] forState:UIControlStateHighlighted];
				[_h setBackgroundColor:[UIColor clearColor]];
                [_h setTitleColor:[UIColor colorWithRed:211.0/255.0 green:71.0/255.0 blue:39.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [_h.titleLabel setFont:[UIFont fontWithName:@"DINPro-CondBlack" size:18]];
				//set their selector using add selector
				[_h addTarget:self action:@selector(didRemove) forControlEvents:UIControlEventTouchUpInside];
				//[self insertSubview:_h aboveSubview:self];
				[_uiv_scrollHolder addSubview:_h];
			}
		}
    }
	
    
    _uiv_scrHelpView = [[ebScrollHelpView alloc] initWithFrame:CGRectMake(854.0, 680.0, 150.0, 100.0) andText:@"SLIDE FOR MORE"];
    _uiv_scrHelpView.delegate = self;
    _uiv_scrHelpView.pulse = NO;
    _uiv_scrHelpView.hidden = YES;
    if ([images count] > 1) {
        _uiv_scrHelpView.hidden = NO;
    }
    
    [_uiv_scrollHolder insertSubview:_uiv_scrHelpView aboveSubview:_h];
    
	//CGFloat percent = (int)(_uis_scrollView.contentOffset.x) / _uis_scrollView.frame.size.width;
	//NSLog(@"percent %f",percent+1);
	
	return self;
}

#pragma -mark Init Paging dots
-(void)initPagingDotsDefault:(NSArray *)images andFrame:(CGRect)frame
{
    NSArray *imageArray = images;
    if (imageArray.count>1)
    {
        _uis_pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-65, 200, 100)];
        
        _uis_pageControl.pageIndicatorImage = [UIImage imageNamed:@"grfx_dot_Off"];
        _uis_pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"grfx_dot_On"];
        _uis_pageControl.alignment = SMPageControlAlignmentCenter;
        [_uiv_scrollHolder insertSubview:_uis_pageControl aboveSubview:_uis_scrollView];
        _uis_pageControl.numberOfPages = imageArray.count;
		CGFloat centerX = frame.size.width/2;
		_uis_pageControl.center = CGPointMake(centerX, _uis_pageControl.center.y);
    }
}

-(void)initPagingDotsAutoPlay
{
    
}

#pragma -mark Init Array Loop or Nonloop
-(void)initArray:(NSArray *)images andFrame:(CGRect)frame
{
//    NSLog(@"The scroll view is loop? %i", loopArray);
    if (loopArray)
    {
//        // Build array with
        NSArray *imageArray = images;

        // Add Last image to the 1st position of image array
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:([imageArray count]-1)]]];
        imageView.frame = CGRectMake(0, 0, _uis_scrollView.frame.size.width, _uis_scrollView.frame.size.height);
        [_uis_scrollView addSubview:imageView];
            
        // Do the loop to add all images from 1 to n-1
        for (int i = 0; i < imageArray.count; i++)
        {
            CGRect framee;
            framee.origin.x = self.uis_scrollView.frame.size.width * (i+1);
            framee.origin.y = 0;
            framee.size = self.uis_scrollView.frame.size;
				
            UIImageView *subview = [[UIImageView alloc] initWithFrame:framee];
            [subview setContentMode:UIViewContentModeScaleToFill];
            subview.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
            [self.uis_scrollView addSubview:subview];
        }
            
        // Add first image to the last positon of image array
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:0]]];
		imageView.backgroundColor = [UIColor redColor];
        imageView.frame = CGRectMake((_uis_scrollView.frame.size.width * ([imageArray count] + 1)), 0, _uis_scrollView.frame.size.width, _uis_scrollView.frame.size.height);
        [_uis_scrollView addSubview:imageView];
            
        // Make scrollview starting image
        _uis_scrollView.contentOffset = CGPointMake(_uis_scrollView.frame.size.width, 0.0f);
            
        // Add scrollview to the container and define the content size 
        [self addSubview:_uiv_scrollHolder];
        self.uis_scrollView.contentSize = CGSizeMake(self.uis_scrollView.frame.size.width*(imageArray.count + 2), self.uis_scrollView.frame.size.height);
    }
    else
    {
        [_uis_pageControl removeFromSuperview];
        NSArray *imageArray = images;
        if (imageArray.count>1) {
            _uis_pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-65, 200, 100)];
            
            _uis_pageControl.pageIndicatorImage = [UIImage imageNamed:@"grfx_dot_Off"];
            _uis_pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"grfx_dot_On"];
            _uis_pageControl.alignment = SMPageControlAlignmentCenter;
            [_uiv_scrollHolder insertSubview:_uis_pageControl aboveSubview:_uis_scrollView];
            _uis_pageControl.numberOfPages = imageArray.count;
            CGFloat centerX = frame.size.width/2;
            _uis_pageControl.center = CGPointMake(centerX, _uis_pageControl.center.y);
        }
        
		imgArray = [[NSMutableArray alloc] init];

		
        // Without Loop add images to array in order
        for (int i = 0; i < imageArray.count; i++) {
            CGRect framee;
            framee.origin.x = self.uis_scrollView.frame.size.width * i;
            framee.origin.y = 0;
            framee.size = self.uis_scrollView.frame.size;
            
            UIImageView *subview = [[UIImageView alloc] initWithFrame:framee];
			subview.alpha = 1.0;
            [subview setContentMode:UIViewContentModeScaleToFill];
            subview.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
            [self.uis_scrollView addSubview:subview];
			[imgArray addObject:subview];
			
        }
        // Add scrollview to the container and define the content size
        [self addSubview:_uiv_scrollHolder];
        self.uis_scrollView.contentSize = CGSizeMake(self.uis_scrollView.frame.size.width*imageArray.count, self.uis_scrollView.frame.size.height);
    }
}

-(void)checkAutoAndLoop
{
    if ((autoPlay == YES)&&(loopArray == NO))
    {
//        NSLog(@"Auto Play One Time");
        [self autoPlayOnce];
    }
    if ((autoPlay == YES)&&(loopArray == YES))
    {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
        if (timeIsSet ==  YES) {
            [self autoPlaySetTimer];
        }
        
       [self autoPlaySetTimer];
        
    }
    else
    {
        return;
    }
}
#pragma -mark Auto Play
-(void)autoPlaySetTimer
{
    [self.autoTimer invalidate];
    _uis_scrollView.scrollEnabled = NO;
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:stayTime target:self selector:@selector(autoPlayScr) userInfo:nil repeats:YES];
//    NSLog(@"Current Stay Time is %f", stayTime);
//    NSLog(@"Current Slide Time is %f", slideTime);
}
-(void)autoPlayScr
{
    offSet +=_uis_scrollView.frame.size.width;
    //NSLog(@"Slide animation time is %f", slideTime);
    [UIView animateWithDuration:slideTime
                     animations:^{
                         [_uis_scrollView setContentOffset:CGPointMake(offSet, 0.0f)];
                     }];
    if (offSet == _uis_scrollView.frame.size.width * ([self.arrayOfImages count] + 2))
    {
        offSet = _uis_scrollView.frame.size.width;
        [_uis_scrollView setContentOffset:CGPointMake(offSet, 0.0f)];
        [self autoPlayScr];
    }

}

-(void)autoPlayOnce
{
    self.pagesCounter = 0;
    [self.autoTimer invalidate];
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:stayTime target:self selector:@selector(autoPlayScrOnce) userInfo:nil repeats:YES];
}
-(void)autoPlayScrOnce
{
    if (loopArray == NO) {
        if (self.pagesCounter < [self.arrayOfImages count]-1) {
            offSet += _uis_scrollView.frame.size.width;
            [UIView animateWithDuration:slideTime
                             animations:^{
                                 [_uis_scrollView setContentOffset:CGPointMake(offSet, 0.0f)];
                             }];
            self.pagesCounter ++;
//            NSLog(@"Now I am %i", self.pagesCounter);
        }
        else
        {
//            NSLog(@"I come into this...");
            [self.autoTimer invalidate];
            self.autoTimer = nil;
            _uis_scrollView.scrollEnabled = YES;
            return;
        }
    }
    if (loopArray == YES) {
        [self checkAutoAndLoop];
    }

}

#pragma mark - scrollview - building info for hotspots

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	int page = [self currenScrollPage:sender];
	self.uis_pageControl.currentPage = page;
	
	// The case where I used this, the x-coordinate was relevant. You may be concerned with the y-coordinate--I'm not sure
//	CGFloat percent = ((int)(_uis_scrollView.contentOffset.x) % (int)(_uis_scrollView.frame.size.width)) / _uis_scrollView.frame.size.width;
//	NSLog(@"%f",percent);
//
//	if (percent > 0.0 && percent < 0.65) { // Of course, you can specify your own range of alpha values
//		UIImageView*tmp = imgArray[page];
//		[tmp.layer setBackgroundColor:[UIColor whiteColor].CGColor];
//		tmp.alpha = 1.0-percent; // You could also create a mathematical function that maps contentOffset to opacity in a different way than this
//		
//		// next page to affect
//		NSUInteger index = page;
//		if ((index == 0) || (index < imgArray.count-1)) {
//			NSLog(@"plus one");
//			UIImageView*tmp = imgArray[page+1];
//			tmp.alpha = 0.35+percent;
//		} else {
//			NSLog(@"minus one");
//			index--;
//		}
//	}
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
	//_uis_pageControl.currentPage = page;
    [self currentImageAtIndex:page fromSender:scrollView];
    [_uis_pageControl updateCurrentPageDisplay];
    if (loopArray) {
        int currentPage = page;
        if (currentPage==0) {
            //go last but 1 page
            [_uis_scrollView scrollRectToVisible:CGRectMake(_uis_scrollView.frame.size.width * [self.arrayOfImages count],0,_uis_scrollView.frame.size.width,_uis_scrollView.frame.size.height) animated:NO];
        } else if (currentPage==([self.arrayOfImages count] + 1)) {
            [_uis_scrollView scrollRectToVisible:CGRectMake(_uis_scrollView.frame.size.width,0,_uis_scrollView.frame.size.width,_uis_scrollView.frame.size.height) animated:NO];
        }
    }
	
	[self didStopScrolling];
}

-(void)didStopScrolling
{
	if ([delegate respondsToSelector:@selector(didStopScrolling:)]) {
		[delegate didStopScrolling:_uis_scrollView];
		//NSLog(@"delegate respondsToSelector:@selector(didStopScrolling:");
	}
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	int page = scrollView.contentOffset.x / scrollView.frame.size.width;
	self.uis_pageControl.currentPage = page;
    //[_uis_pageControl updateCurrentPageDisplay];
}

- (void)currentImageAtIndex:(NSUInteger)index fromSender:(UIScrollView*)scroll
{
	if ([delegate respondsToSelector:@selector(currentImageAtIndex:fromSender:)]) {
		[self.delegate currentImageAtIndex:index fromSender:scroll];
		//NSLog(@"delegate respondsToSelector:@selector(currentImageAtIndex:");
	}
}

-(void)openScrollViewAtPage:(int)index
{
	[_uis_scrollView setContentOffset:CGPointMake((index * 1024), 0) animated:YES];
}

-(int)currenScrollPage:(UIScrollView*)scroll
{
	int page = scroll.contentOffset.x / scroll.frame.size.width;
	self.uis_pageControl.currentPage = page;
	//NSLog(@"%i currenScrollPage",page);
	return page;
}
//-(int)didEndScrollPageIndex:(UIScrollView *)sender
//{
//    int page = sender.contentOffset.x / sender.frame.size.width;
//    return page;
//}

#pragma mark - Delegate methods
-(void)didRemove {
    // send message the message to the delegate!
//    [self.defaultTimer invalidate];
//    [self.customizedTimer invalidate];
    [delegate didRemove:self];
}

@end
