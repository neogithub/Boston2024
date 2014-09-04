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
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _locationVC = [sb instantiateViewControllerWithIdentifier:@"mapViewController"];
    _locationVC.view.frame = self.view.bounds;
    [self addChildViewController:_locationVC];
    [self.view addSubview:_locationVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
