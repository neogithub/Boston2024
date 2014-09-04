//
//  ebScrollHelpView.h
//  eb230park
//
//  Created by Evan Buxton on 1/8/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ebScrollHelpView;

@protocol ebScrollHelpViewDelegate
-(void)didRemove:(ebScrollHelpView *)customClass;
@end


@interface ebScrollHelpView : UIView
{
	CABasicAnimation *theAnimation;
	CALayer *pplayer;
	UIView* vview;
}
- (id)initWithFrame:(CGRect)frame andText:(NSString*)message;

// define delegate property
@property (nonatomic, assign) id  delegate;

// defualty is slide
@property BOOL pulse;

// define public functions
-(void)didRemove;
@end
