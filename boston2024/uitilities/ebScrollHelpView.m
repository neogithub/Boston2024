//
//  ebScrollHelpView.m
//  eb230park
//
//  Created by Evan Buxton on 1/8/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "ebScrollHelpView.h"
#import "UIView+NeoUtilities.h"
#import "UIColor+Extensions.h"

@implementation ebScrollHelpView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andText:(NSString*)message
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		// evan
		
		delegate=self;
		UILabel *testFitLabelName = [[UILabel alloc] init];
		[testFitLabelName setFont:[UIFont fontWithName:@"Helvetica" size:12]];
		NSString *tmp = message;
		CGSize stringsize = [tmp sizeWithFont:[UIFont systemFontOfSize:12]];
		
		NSLog(@"%@",NSStringFromCGSize(stringsize));
		
//		testFitLabelName.frame=CGRectMake(testFitLabelName.frameOrigin.x, testFitLabelName.frameOrigin.y, stringsize.width+50, 25);
        testFitLabelName.frame=CGRectMake(0, 0, stringsize.width+45, 25);
		[testFitLabelName setText:message];
		[testFitLabelName setTextColor:[UIColor whiteColor]];
		testFitLabelName.backgroundColor = [UIColor clearColor];
		[testFitLabelName setTextAlignment:NSTextAlignmentCenter];
        [testFitLabelName setFont:[UIFont fontWithName:@"DINPro-CondBlack" size:16]];
		testFitLabelName.hidden=NO;
		
//		vview = [[UIView alloc] initWithFrame: CGRectMake(1024, 368, stringsize.width+50, 27)];
//        vview = [[UIView alloc] initWithFrame: CGRectMake(0, 0, stringsize.width+50, 27)];
        vview = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.frame.size.width, 27)];
		[vview setBackgroundColor: [UIColor colorWithRed:211.0/255.0 green:70.0/255.0 blue:40.0/255.0 alpha:1.0]];
		vview.layer.borderColor = [UIColor whiteColor].CGColor;
		vview.layer.borderWidth = 1.0f;
        NSLog(@"\n\nThe frame of box si %@", [self description]);
		[self addSubview:vview];
		
		UIImageView *helpBG = [[UIImageView alloc] init];
		[helpBG setFrame:CGRectMake(0, 0,  85, 27)];
		//helpBG.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		helpBG.contentMode =UIViewContentModeScaleAspectFill;
		[helpBG setImage:[UIImage imageNamed:@"ui_btn-swipe.png"]];
		[vview addSubview:helpBG];

	
		[vview addSubview:testFitLabelName];
		
		if ([self pulse]==NO) {
//			vview.transform = CGAffineTransformMakeTranslation(-(stringsize.width+90), 0);
            vview.transform = CGAffineTransformMakeTranslation(0, 0);
            NSLog(@"\n\nThe frame of box si %@", [vview description]);
			pplayer = [vview layer];
			theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
			theAnimation.duration=1.0;
			theAnimation.repeatCount=3;
			theAnimation.delegate=self;
			theAnimation.autoreverses=YES;
			theAnimation.removedOnCompletion=YES;
			theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
			theAnimation.toValue=[NSNumber numberWithFloat:0.0];
			[pplayer addAnimation:theAnimation forKey:@"animateOpacity"];
						
		} else {
			[UIView animateWithDuration:1.75
							 animations:^{
								 vview.transform = CGAffineTransformMakeTranslation(-(stringsize.width+70), 0);
							 }
							 completion:^(BOOL  completed){
								 [UIView animateWithDuration:3.00
												  animations:^{
													  vview.alpha = 0.0;
												  }
												  completion:^(BOOL  completed){
													  [UIView animateWithDuration:0.00
																	   animations:^{
																		   vview.transform = CGAffineTransformIdentity;
																	   }
																	   completion:^(BOOL  completed){
																		   
																		   if (delegate && [delegate respondsToSelector:@selector(didRemove)])
																			   [self didRemove];

																	   } ];}];
							 }
			 ];

		}
	}
    return self;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	NSLog(@"sdsadsaddsasdasdasd");
	[pplayer removeAnimationForKey:@"opacity"];
    [UIView animateWithDuration:1.0 animations:^{
        vview.alpha = 0.0;
    } completion:^(BOOL finished){
        [vview removeFromSuperview];
    }];
//	[vview removeFromSuperview];
	[self didRemove];
}

#pragma mark - Delegate methods
-(void)didRemove {
    // send message the message to the delegate!
	[delegate didRemove:self];
}

- (void) dealloc {
    self.delegate = nil;
}


@end
