//
//  ViewController.m
//  boston2024
//
//  Created by Xiaohe Hu on 9/2/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "ViewController.h"
#import "mapViewController.h"

@interface ViewController ()
@property (nonatomic, strong) mapViewController         *locationVC;
@property (nonatomic, strong) UIImageView               *uiiv_initImage;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self prefersStatusBarHidden];
    self.view.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _locationVC = [sb instantiateViewControllerWithIdentifier:@"mapViewController"];
    _locationVC.view.frame = self.view.bounds;
    [self addChildViewController:_locationVC];
    _locationVC.view.alpha = 0.0;
    [self.view addSubview:_locationVC.view];
    
    [self setInitialImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setInitialImage) name:@"resetApp" object:nil];
}

-(void)setInitialImage
{
    _uiiv_initImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"00-start-logo.png"]];
    _uiiv_initImage.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    [self.view addSubview: _uiiv_initImage];
    
    UITapGestureRecognizer *tapOnImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMap:)];
    tapOnImg.numberOfTapsRequired = 1;
    _uiiv_initImage.userInteractionEnabled = YES;
    [_uiiv_initImage addGestureRecognizer: tapOnImg];
}

-(void)loadMap:(UIGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.33 animations:^{
        _uiiv_initImage.alpha = 0.0;
        _locationVC.view .alpha = 1.0;
    } completion:^(BOOL finished){
        [_uiiv_initImage removeFromSuperview];
        _uiiv_initImage = nil;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
