//
//  xhHelpViewController.m
//  embRoundButton
//
//  Created by Xiaohe Hu on 7/30/14.
//  Copyright (c) 2014 neoscape. All rights reserved.
//

#import "xhHelpViewController.h"
#import "UIColor+Extensions.h"

static float scaleRatio = 0.75;
static float pageGap = 35.0;

@interface xhHelpViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)   NSArray         *arr_images;
@property (nonatomic, strong)   UIScrollView    *uis_helps;
@end

@implementation xhHelpViewController

- (id)initWithImageArray:(NSArray *)imageArray andFrame:(CGRect)frame
{
    if (self) {
        // Custom initialization
        _arr_images = [[NSArray alloc] initWithArray:imageArray];
        self.view.frame = frame;
        [self initVC];
    }
    return self;
}

- (void)initVC
{
    //Init blurry background
    UIView *uiv_blurry = [[UIView alloc] initWithFrame:self.view.bounds];
    uiv_blurry.backgroundColor = [UIColor whiteColor];
    uiv_blurry.alpha = 0.9;
    [self.view addSubview: uiv_blurry];
    
    //Init scorll view
    _uis_helps = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024 + pageGap, 768)];
    _uis_helps.delegate = self;
    _uis_helps.contentSize = CGSizeMake(1024.0 * _arr_images.count + pageGap * _arr_images.count, 768.0);
    _uis_helps.pagingEnabled = YES;
    _uis_helps.clipsToBounds = NO;
    _uis_helps.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < _arr_images.count; i++) {
        UIImageView *uiiv_helps = [[UIImageView alloc] initWithImage:_arr_images[i]];
        uiiv_helps.frame = CGRectMake(i * (1024.0 + pageGap), 0.0, 1024.0, 768.0);
//        uiiv_helps.transform = CGAffineTransformMakeScale(0.75, 0.65);
        [_uis_helps addSubview: uiiv_helps];
    }
    [self.view insertSubview: _uis_helps aboveSubview:uiv_blurry];
    _uis_helps.transform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
//    _uis_helps.transform = CGAffineTransformMakeScale(0.75, 0.75);
//    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView)];
//    oneTap.delegate = self;
//    oneTap.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:oneTap];
}

//- (void)tapOnView
//{
//    [self.view removeFromSuperview];
//    self.view = nil;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
