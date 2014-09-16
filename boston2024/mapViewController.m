//
//  mapViewController.m
//  boston2024
//
//  Created by Xiaohe Hu on 9/2/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "mapViewController.h"
#import "MapViewAnnotation.h"
#import <MapKit/MapKit.h>
#import "embOverlayScrollView.h"
#import "embSimpleScrollView.h"
#import "xhanchorPointHotspots.h"
#import "embDrawBezierPath.h"
#import "embBezierPaths.h"
#import "embDirections.h"
#import "embDirectionsHigh.h"
#import "neoHotspotsView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "xhWebViewController.h"
#import "xhHelpViewController.h"
#define METERS_PER_MILE 1609.344
static int numOfCells = 4;
static float container_W = 198.0;  // origial 186
static float kClosedMenu_W = 40.0;
static float kIndicatorX = 4.0;
static float kIndicatorY = 6.0;

@interface mapViewController ()<embSimpleScrollViewDelegate, embDrawBezierPathDelegate, embOverlayScrollViewDelegate>
{
    NSString            *overlayName;
    int                 sectionIndex;
    BOOL                isLoggedIn;
}

@property (nonatomic, strong) contentTableViewController    *contentTableView;
@property (nonatomic, strong) CollapseClickCell             *theCell;

@property (nonatomic, strong) UIImageView                   *uiiv_bgImg;//The map

@property (nonatomic, strong) UIView                        *uiv_collapseContainer;
@property (nonatomic, strong) UIView                        *uiv_closedMenuContainer;

@property (nonatomic, strong) UIButton                      *uib_closeBtn;
@property (nonatomic, strong) UIButton                      *uib_openBtn;

@property (nonatomic, strong) UIButton                      *uib_access;

@property (nonatomic, strong) UIView                        *uiv_bottomMenu;
@property (nonatomic, strong) UIButton                      *uib_bos2014;
@property (nonatomic, strong) UIButton                      *uib_bos2024;
@property (nonatomic, strong) UIButton                      *uib_bos2024Oly;

@property (nonatomic, strong) UIView                        *uiv_textBoxContainer;
@property (nonatomic, strong) UILabel                       *uil_textYear;
@property (nonatomic, strong) UILabel                       *uil_textInfo;
@property (nonatomic, strong) UILabel                       *uil_textSection;

@property (nonatomic, strong) UIView                        *uiv_toggleContainer;
@property (nonatomic, strong) UIButton                      *uib_normalTime;
@property (nonatomic, strong) UIButton                      *uib_summerTime;

@property (nonatomic, strong) UIImageView                   *uiiv_rightTextBox;
@property (nonatomic, strong) UIImageView                   *uiiv_topRightBox;
@property (nonatomic, strong) UIImageView                   *uiiv_indicator;

@property (nonatomic, strong) UIButton                      *uib_village;
@property (nonatomic, strong) UIButton                      *uib_mpc;

@property (nonatomic, strong) xhHelpViewController          *helpVC;

@property (nonatomic, strong) UILabel                       *uil_cellName;

@property (nonatomic, strong) NSMutableArray                *arr_cellName;

@property (nonatomic, strong) UIView                        *uiv_tracksContent;
@property (nonatomic, strong) NSMutableArray                *arr_tracksBtn;

@property (nonatomic, strong) UIButton                      *uib_originalMap;
@property (nonatomic, strong) UIButton                      *uib_appleMap;
@property (nonatomic, strong) UIButton                      *uib_googleMap;
@property (nonatomic, strong) UIButton                      *uib_appleMapToggle;
@property (nonatomic, strong) UIView                        *uiv_mapToggles;

@property (nonatomic, strong) MKMapView                     *mapView;
@property (nonatomic, strong) UIView                        *uiv_mapContainer;

@property (nonatomic, strong) UIView                        *uiv_closeMenuSideBar;
@property (nonatomic, strong) UIView                        *uiv_directionDot;
@property (nonatomic, strong) UIView                        *uiv_tracksDot;
@property (nonatomic, strong) UIView                        *uiv_bridgeDot;
@property (nonatomic, strong) embOverlayScrollView          *uis_zoomingMap;

@property (nonatomic, strong) UIImageView                   *uiiv_overlays;
@property (strong, nonatomic) embSimpleScrollView			*uis_hotspotImages;

@property (nonatomic, strong) xhanchorPointHotspots         *hotspots;
@property (nonatomic, strong) NSMutableArray                *arr_hotspotsData;
@property (nonatomic, strong) NSMutableArray                *arr_hotsopts;
@property (nonatomic, strong) NSDictionary                  *dict_hotspots;

@property (nonatomic, strong) embDrawBezierPath				*embDirectionPath;

@property (nonatomic, strong) NSMutableArray                *dirpathsArray;
@property (nonatomic, strong) NSMutableArray				*arr_pathItems;

@property (nonatomic, strong) neoHotspotsView               *tappableHotspots;
@property (nonatomic, strong) NSDictionary                  *dict_hotspotDict;
@property (nonatomic, strong) NSMutableArray                *arr_tapHotspotArray;
@property (nonatomic, strong) NSMutableArray                *arr_tapHotspots;

@property (nonatomic, strong) NSMutableArray                *arr_galleryBtnArray;
@property (nonatomic, strong) NSArray                       *arr_galleryImageData;

@property (nonatomic, readwrite) int                        preBtnTag;
@property (nonatomic, strong) UIButton                      *uib_home;
//navigation controller
@property (strong, nonatomic) UINavigationController        *navigationController;

@property (nonatomic, strong) MPMoviePlayerViewController   *playerViewController;
@end

@implementation mapViewController
-(UIColor *) chosenBtnColor{
    return [UIColor colorWithRed:60.0/255.0 green:56.0/255.0 blue:52.0/255.0 alpha:1.0];
}
-(UIColor *) normalCellColor{
    return [UIColor colorWithRed:59.0/255.0 green:55.0/255.0 blue:50.0/255.0 alpha:0.9];
}
-(UIColor *) chosenCellColor{
    return [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
}
-(UIColor *) chosenBtnTitleColor{
    return [UIColor colorWithRed:119.0/255.0 green:116.0/255.0 blue:113.0/255.0 alpha:1.0];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    _preBtnTag = 0;
    
    NSString *path0 = [[NSBundle mainBundle] pathForResource:@"buildingHotsopt" ofType:@"plist"];
    _dict_hotspotDict = [[NSDictionary alloc] initWithContentsOfFile:path0];
    _arr_tapHotspotArray = [[NSMutableArray alloc] initWithArray:[_dict_hotspotDict objectForKey:@"3D"]];
	_arr_tapHotspots = [[NSMutableArray alloc] init];
    
    _arr_hotspotsData = [[NSMutableArray alloc] init];
    _arr_hotsopts = [[NSMutableArray alloc] init];
    
    //Init status of section index and overlay file's name
    sectionIndex = 1;
    overlayName = [[NSString alloc] init];
    
    //Prepare gallery info from plist
    NSString *path_gallery = [[NSBundle mainBundle] pathForResource:@"gallery_buttons" ofType:@"plist"];
    _arr_galleryImageData = [[NSArray alloc] initWithContentsOfFile:path_gallery];
    _arr_galleryBtnArray = [[NSMutableArray alloc] init];
    
    //Prepare hotsopts' data from plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location_hotspots" ofType:@"plist"];
    _dict_hotspots = [[NSDictionary alloc] initWithContentsOfFile:path];
    
	// Do any additional setup after loading the view, typically from a nib.
    _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"Traffic", @"People", @"Statistics", nil];
    
    if (!_uis_zoomingMap) {
        [self initVC];
    }
    
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.alpha = 1.0;
    }];
    [self.view addSubview:_uiv_collapseContainer];
    [self.view addSubview:_uiv_closedMenuContainer];
    //    [self initMapToggle];
    //    [self initBlockBtns];
    
	[self initAccessBtn];
    [self initHomeBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneButtonClick:) name:MPMoviePlayerPlaybackDidFinishNotification object:_playerViewController];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.frame = CGRectMake(0.0, 0.0, 1024, 768);
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.origin.y = 0;
    self.navigationController.navigationBar.frame = frame;
	self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = YES;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
	[super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)initVC
{
    if (!_uis_zoomingMap) {
        
        [self initZoomingMap];
        [self initCollapseView];
        [self initBottomMenu];
        [self initTextBox];
        [self initToggle];
        [self initRightImageView];
        [self initTopRightBox];
        [self initIndicator];
        _contentTableView = [[contentTableViewController alloc] init];
        
    }
}

#pragma mark- Init Items
#pragma mark - init zooming map
-(void)initZoomingMap
{
    // Set Zooming Map
    _uiiv_bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"00-base-regional-map.png"]];
    _uis_zoomingMap = [[embOverlayScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0) image:[UIImage imageNamed:@"00-base-regional-map.png"] overlay:nil shouldZoom:YES];
    overlayName = @"00-bg-base-highways";
    [self updateOverlay];
    _uis_zoomingMap.imageToggle = NO;
//    [_uis_zoomingMap.overView setImage:[UIImage imageNamed:@"grfx_alignmentOverlay.png"]];
    [self.view addSubview: _uis_zoomingMap];
}

#pragma mark - init Indicator
-(void)initIndicator
{
    _uiiv_indicator = [UIImageView new];
    UIImage *indicator = [UIImage imageNamed:@"grfx_indicator.png"];
    _uiiv_indicator.image = indicator;
    _uiiv_indicator.frame = CGRectMake(0.0, 0.0, indicator.size.width, indicator.size.height);
    _uiiv_indicator.hidden = YES;
}

-(void)updateIndicatorPosition:(CGRect)frameRect
{
    if (_uiiv_indicator.hidden) {
        _uiiv_indicator.frame = frameRect;
        _uiiv_indicator.hidden = NO;
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            _uiiv_indicator.frame = frameRect;
        }];
    }
}

#pragma mark - init village & mpc/ipc buttons
-(void)initVillageBtns
{
    _uib_village = [UIButton buttonWithType: UIButtonTypeCustom];
    _uib_village.frame = CGRectMake(644, 555, 90, 90);
    _uib_village.backgroundColor = [UIColor clearColor];
    _uib_village.tag = 1;
    [_uib_village addTarget:self action:@selector(updateVillageMap) forControlEvents:UIControlEventTouchUpInside];
    [_uis_zoomingMap.overView addSubview: _uib_village];
    _uib_village.selected = NO;
    
    _uib_mpc = [UIButton buttonWithType: UIButtonTypeCustom];
    _uib_mpc.frame = CGRectMake(649, 364, 90, 90);
    _uib_mpc.backgroundColor = [UIColor clearColor];
    _uib_mpc.tag = 2;
    [_uib_mpc addTarget:self action:@selector(updateMpcMap) forControlEvents:UIControlEventTouchUpInside];
    [_uis_zoomingMap.overView addSubview: _uib_mpc];
    _uib_mpc.selected = NO;
}

-(void)updateVillageMap
{
    _uib_mpc.selected = NO;
    _uib_village.selected = !_uib_village.selected;
    if (_uib_village.selected) {
        overlayName = @"03-07-athletes-village-overlay";
        [self updateOverlay];
    }
    else {
        overlayName = @"03-06-bg-drive-times-map";
        [self updateOverlay];
    }
}

-(void)updateMpcMap
{
    _uib_village.selected = NO;
    _uib_mpc.selected = !_uib_mpc.selected;
    if (_uib_mpc.selected) {
        overlayName = @"03-08-mpc-overlay";
        [self updateOverlay];
    }
    else {
        overlayName = @"03-06-bg-drive-times-map";
        [self updateOverlay];
    }
}

-(void)removeVillageBtns
{
    [_uib_village removeFromSuperview];
    _uib_village = nil;
    [_uib_mpc removeFromSuperview];
    _uib_mpc = nil;
}

#pragma mark - init top right box
-(void)initTopRightBox
{
    _uiiv_topRightBox = [UIImageView new];
    _uiiv_topRightBox.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_uiiv_topRightBox belowSubview:_uiv_bottomMenu];
    _uiiv_topRightBox.hidden = YES;
}

-(void)updateTopRightBox:(NSString *)string
{
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"png"];
    UIImage *textImage = [UIImage imageWithContentsOfFile:path];
    float width = textImage.size.width;
    float height = textImage.size.height;
    
    _uiiv_topRightBox.frame = CGRectMake(1024 - width - 18, 18, width, height);
    _uiiv_topRightBox.image = textImage;
    _uiiv_topRightBox.hidden = NO;
}

#pragma mark - init left part image view
-(void)initRightImageView
{
    _uiiv_rightTextBox = [UIImageView new];
    _uiiv_rightTextBox.frame = CGRectZero;
    _uiiv_rightTextBox.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_uiiv_rightTextBox belowSubview:_uiv_bottomMenu];
    _uiiv_rightTextBox.hidden = YES;
}

-(void)updateRightTextBox:(NSString *)string
{
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"png"];
    UIImage *textImage = [UIImage imageWithContentsOfFile:path];
    float width = textImage.size.width;
    float height = textImage.size.height;
    
    _uiiv_rightTextBox.frame = CGRectMake(1024 - width, (768 - height)/2, width, height);
    _uiiv_rightTextBox.image = textImage;
    _uiiv_rightTextBox.hidden = NO;
}

#pragma mark - init collapse view container
-(void)initCollapseView
{
    // Set Container's Frame
    _uiv_collapseContainer = [[UIView alloc] init];
    _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(numOfCells))/2, container_W, kCCHeaderHeight*(numOfCells));
    [_uiv_collapseContainer setBackgroundColor:[UIColor clearColor]];
    _uiv_collapseContainer.clipsToBounds = YES;
    
    //Set Collapse View's Frame
    theCollapseClick = [[CollapseClick alloc] initWithFrame:CGRectMake(0.0f, kCCHeaderHeight, container_W, kCCHeaderHeight*numOfCells)];
    [theCollapseClick setBackgroundColor:[UIColor clearColor]];
    [_uiv_collapseContainer addSubview:theCollapseClick];
    [self initClosedMenu];
    
    theCollapseClick.CollapseClickDelegate = self;
    [theCollapseClick reloadCollapseClick];
    
    
    _uiv_collapseContainer.alpha = 0.0;
}

-(void)initClosedMenu
{
    //Set Close Button
    _uib_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_closeBtn setBackgroundColor:[UIColor clearColor]];
    [_uib_closeBtn setBackgroundImage:[UIImage imageNamed:@"map_menu_close@2x.png"] forState:UIControlStateNormal];
    _uib_closeBtn.frame = CGRectMake(container_W-29, 0, 30, 30);
    [_uib_closeBtn addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchDown];
    [_uiv_collapseContainer addSubview:_uib_closeBtn];
    
    //Set Closed Menu Container
    _uiv_closedMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(-40.0, (768-38)/2, kClosedMenu_W, kClosedMenu_W)];
    _uiv_closedMenuContainer.clipsToBounds = NO;
    [_uiv_closedMenuContainer setBackgroundColor:[self normalCellColor]];
//    [_uiv_closedMenuContainer setBackgroundColor:[UIColor clearColor]];
    _uib_openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_openBtn setBackgroundColor:[UIColor clearColor]];
    [_uib_openBtn setBackgroundImage:[UIImage imageNamed:@"open_btn.jpg"] forState:UIControlStateNormal];
    _uib_openBtn.frame = CGRectMake(0, 0, kClosedMenu_W, kClosedMenu_W);
    [_uib_openBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchDown];
    
    [_uiv_closedMenuContainer insertSubview:_uiv_closeMenuSideBar aboveSubview:_uil_cellName];
    [_uiv_closedMenuContainer addSubview:_uib_openBtn];
    [self initCellNameLabel:nil];
}

-(void)removeClosedMenuItem
{
    [_uiv_closedMenuContainer removeFromSuperview];
    _uiv_closedMenuContainer = nil;
    
    [_uib_openBtn removeFromSuperview];
    _uib_openBtn = nil;
    
    [_uib_closeBtn removeFromSuperview];
    _uib_closeBtn = nil;
}

-(void)initCellNameLabel:(NSString *)cellName
{
    //Init UILabel
    CGFloat padding = 0.0;
    if (cellName)
        padding = 12.0;
    
    [_uil_cellName removeFromSuperview];
    _uil_cellName = nil;
    [_uiv_closeMenuSideBar removeFromSuperview];
    
    _uil_cellName = [[UILabel alloc] initWithFrame:CGRectMake(10, 48.0, 30.0, 20.0)];//_uib_openBtn.frame.size.height = 40, space = 8, 40+8=48
    _uil_cellName.layer.anchorPoint = CGPointMake(0, 1.0);
//    [_uil_cellName setBackgroundColor:[self normalCellColor]];
    [_uil_cellName setBackgroundColor:[UIColor clearColor]];
    _uil_cellName.autoresizesSubviews = YES;
    [_uil_cellName setText:cellName];
    _uil_cellName.font = [UIFont fontWithName:@"DINPro-CondBlack" size:16];
    [_uil_cellName setTextColor:[UIColor whiteColor]];
    [_uiv_closedMenuContainer addSubview:_uil_cellName];
    
    // Adjust the frame of label after changing the anchor point
    CGRect frame = _uil_cellName.frame;
    frame.origin.x = _uil_cellName.frame.origin.x - 15;
    frame.origin.y = _uil_cellName.frame.origin.y - (18-padding);
    
    [_uil_cellName setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    _uil_cellName.frame = frame;
    
    [_uil_cellName sizeToFit];
    //Adjust the frame of container according to the height of label
    CGRect containerFrame = _uiv_closedMenuContainer.frame;
    containerFrame.size.height = _uib_openBtn.frame.size.height + padding + _uil_cellName.frame.size.height + padding;
    containerFrame.size.width = kClosedMenu_W;
    containerFrame.origin.y = (int)(768 - containerFrame.size.height)/2;
    containerFrame.origin.x = _uiv_closedMenuContainer.frame.origin.x;
    _uiv_closedMenuContainer.frame = containerFrame;
    
    _uiv_closeMenuSideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, containerFrame.size.height)];
    _uiv_closeMenuSideBar.backgroundColor = [UIColor redColor];
    
    [_uiv_closedMenuContainer insertSubview:_uiv_closeMenuSideBar belowSubview:_uib_openBtn];
}

#pragma mark - init bottom menu
-(void)initBottomMenu
{
    _uiv_bottomMenu = [[UIView alloc] initWithFrame:CGRectMake(282, 733, 460, 35)];
    _uiv_bottomMenu.backgroundColor = [UIColor grayColor];
    [self.view insertSubview:_uiv_bottomMenu aboveSubview:_uiv_closedMenuContainer];
    
    _uib_bos2014 = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_bos2014.frame = CGRectMake(1.0, 0.0, 152.0, 35.0);
    [_uib_bos2014 setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [_uib_bos2014 setTitle:@"Boston 2014" forState:UIControlStateNormal];
    _uib_bos2014.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:16];
    [_uib_bos2014 addTarget:self action:@selector(tapOnBottomMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_uiv_bottomMenu addSubview: _uib_bos2014];
    _uib_bos2014.tag = 10;
    
    _uib_bos2024 = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_bos2024.frame = CGRectMake(154, 0.0, 152.0, 35.0);
    [_uib_bos2024 setBackgroundColor:[UIColor blackColor]];
    [_uib_bos2024 setTitle:@"Boston 2024" forState:UIControlStateNormal];
    _uib_bos2024.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:16];
    [_uib_bos2024 addTarget:self action:@selector(tapOnBottomMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_uiv_bottomMenu addSubview: _uib_bos2024];
    _uib_bos2024.tag = 11;
    
    _uib_bos2024Oly = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_bos2024Oly.frame = CGRectMake(307.0, 0.0, 152.0, 35.0);
    [_uib_bos2024Oly setBackgroundColor:[UIColor blackColor]];
    [_uib_bos2024Oly setTitle:@"Boston 2024 Olympics" forState:UIControlStateNormal];
    _uib_bos2024Oly.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:16];
    [_uib_bos2024Oly addTarget:self action:@selector(tapOnBottomMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_uiv_bottomMenu addSubview: _uib_bos2024Oly];
    _uib_bos2024Oly.tag = 12;
}

-(void)tapOnBottomMenu:(id)sender
{
    for (UIButton *tmp in [_uiv_bottomMenu subviews] ) {
        tmp.backgroundColor = [UIColor blackColor];
        tmp.userInteractionEnabled = YES;
    }
    UIButton *tappedBtn = sender;
    tappedBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:255.0/255.0 alpha:1.0];
    tappedBtn.userInteractionEnabled = NO;
    
    [_uiv_tracksDot removeFromSuperview];
    [_uiv_directionDot removeFromSuperview];
    [_uiiv_overlays removeFromSuperview];
    [_arr_hotspotsData removeAllObjects];
    [_arr_hotsopts removeAllObjects];
	[self directionViewCleanUp];
    [_uis_zoomingMap.overView setImage:nil];
    _uiv_toggleContainer.hidden = YES;
    _uiv_textBoxContainer.hidden = YES;
    _uiiv_rightTextBox.hidden = YES;
    _uiiv_topRightBox.hidden = YES;
    
    [self updateMap:(int)tappedBtn.tag];
}

-(void)updateMap:(int)index
{
    _uiv_closedMenuContainer.transform = CGAffineTransformIdentity;
    _uiv_collapseContainer.transform = CGAffineTransformIdentity;
    _uiv_closedMenuContainer.frame = CGRectMake(-40.0, (768-36)/2, 40.0, 38);
    _uiv_closeMenuSideBar.backgroundColor = [UIColor clearColor];
    [_uil_cellName removeFromSuperview];
    
    NSLog(@"\n\n The close menu is %@", [_uiv_closedMenuContainer description]);
    switch (index) {
        case 10:{
            sectionIndex = 1;
            [_arr_tapHotspots removeAllObjects];
            [_uis_zoomingMap resetScroll];
            [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
            [theCollapseClick closeCellResize];
            [_arr_cellName removeAllObjects];
            _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"Traffic", @"People", @"Statistics", nil];
//            theCollapseClick.CollapseClickDelegate = self;
            [theCollapseClick reloadCollapseClick];
            [_uis_zoomingMap.blurView setImage: [UIImage imageNamed:@"00-base-regional-map.png"]];
            overlayName = @"00-bg-base-highways";
            [self updateOverlay];
            [self setYearText:@"2014"];
            [self setInfoText:@"Typical day Boston during peak hours"];
            break;
        }
        case 11:{
            sectionIndex = 2;
            [_arr_tapHotspots removeAllObjects];
            [_uis_zoomingMap resetScroll];
            [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
            [theCollapseClick closeCellResize];
            [_arr_cellName removeAllObjects];
            _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"Traffic", @"People", @"Statistics", nil];
//            theCollapseClick.CollapseClickDelegate = self;
            [theCollapseClick reloadCollapseClick];
            [_uis_zoomingMap.blurView setImage: [UIImage imageNamed:@"00-base-regional-map.png"]];
            overlayName = @"00-bg-base-highways";
            [self updateOverlay];
            [self setYearText:@"2024"];
            [self setInfoText:@"Typical day Boston during peak hours during peak hours during peak hours"];
            break;
        }
        case 12:{
            sectionIndex = 3;
            [_arr_tapHotspots removeAllObjects];
            [_uis_zoomingMap resetScroll];
            [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
            [theCollapseClick closeCellResize];
            [_arr_cellName removeAllObjects];
            _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"Traffic", @"Statistics", nil];
//            theCollapseClick.CollapseClickDelegate = self;
            [theCollapseClick reloadCollapseClick];
            [_uis_zoomingMap.blurView setImage: [UIImage imageNamed:@"00-base-regional-map.png"]];
            overlayName = @"00-bg-base-highways";
            [self updateOverlay];
            [self setYearText:@"2024"];
            [self setInfoText:@"Typical day Boston"];
            break;
        }
        default:
            break;
    }
}

#pragma mark - init top left text box
-(void)initTextBox
{
    _uiv_textBoxContainer = [[UIView alloc] initWithFrame:CGRectMake(30.0, 0.0, 600, 85)];
    _uiv_textBoxContainer.clipsToBounds = YES;
    [self.view insertSubview:_uiv_textBoxContainer aboveSubview:_uiv_collapseContainer];
    
    [self setYearText:@"2014"];
    
    [self setInfoText:@"Typical day Boston during peak hours"];
    
    [self setSectionText:@"Traffic"];
    
    UIView *uiv_whiteBar = [[UIView alloc] initWithFrame:CGRectMake(90.0, 10.0, 1.0, _uiv_textBoxContainer.frame.size.height - 20)];
    uiv_whiteBar.backgroundColor = [UIColor whiteColor];
    uiv_whiteBar.alpha = 0.5;
    
    UIView *uiv_btmBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 80.0, 600, 5)];
    uiv_btmBar.backgroundColor = [UIColor colorWithRed:162.0/255.0 green:214.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    [_uiv_textBoxContainer addSubview: uiv_btmBar];
    [_uiv_textBoxContainer addSubview: uiv_whiteBar];
    _uiv_textBoxContainer.hidden = YES;
}

-(void)setYearText:(NSString *)year
{
    if (_uil_textYear) {
        [_uil_textYear removeFromSuperview];
        _uil_textYear = nil;
    }
    _uil_textYear = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 80, 55)];
    [_uil_textYear setText:year];
    [_uil_textYear setBackgroundColor:[UIColor clearColor]];
    [_uil_textYear setTextColor:[UIColor whiteColor]];
    [_uil_textYear setFont: [UIFont fontWithName:@"DINEngschriftStd" size:45]];
    [_uil_textYear setTextAlignment:NSTextAlignmentRight];
    [_uiv_textBoxContainer addSubview: _uil_textYear];
}

-(void)setInfoText:(NSString *)string
{
    if (_uil_textInfo) {
        [_uil_textInfo removeFromSuperview];
        _uil_textInfo = nil;
    }
    UIFont *font = [UIFont fontWithName:@"DINEngschriftStd" size:21];
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGFloat str_width = [[[NSAttributedString alloc] initWithString:string attributes:attributes1] size].width;
    NSLog(@"The string width is %f", str_width);
    CGSize constraint;
    if (str_width < 350) {
        constraint = CGSizeMake(str_width,85);
    }else {
        constraint = CGSizeMake(350,85);
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [string boundingRectWithSize:constraint
                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    attributes:attributes
                                       context:nil];
    
    _uil_textInfo = [[UILabel alloc] initWithFrame:rect];
    [_uil_textInfo setText:string];
    [_uil_textInfo setTextColor:[UIColor whiteColor]];
    [_uil_textInfo setLineBreakMode:NSLineBreakByWordWrapping];
    [_uil_textInfo setFont:font];
    _uil_textInfo.numberOfLines = 2;
    _uil_textInfo.frame = CGRectMake(100.0, (85 - rect.size.height)/2, rect.size.width, rect.size.height);
    _uil_textInfo.backgroundColor = [UIColor clearColor];
    [_uiv_textBoxContainer addSubview: _uil_textInfo];
    CGRect frame = CGRectMake(30.0, 0.0, _uil_textInfo.frame.size.width + _uil_textYear.frame.size.width+50, 85);
    _uiv_textBoxContainer.frame = frame;
    _uiv_textBoxContainer.backgroundColor = [UIColor colorWithRed:6.0/255.0 green:154.0/255.0 blue:216.0/255.0 alpha:1.0];
}

-(void)setSectionText:(NSString *)string
{
    if (_uil_textSection) {
        [_uil_textSection removeFromSuperview];
        _uil_textSection = nil;
    }
    _uil_textSection = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 80.0, 30.0)];
    [_uil_textSection setText:string];
    [_uil_textSection setTextColor:[UIColor whiteColor]];
    [_uil_textSection setFont:[UIFont fontWithName:@"DINEngschriftStd" size:30]];
    [_uil_textSection setTextAlignment:NSTextAlignmentRight];
    [_uiv_textBoxContainer addSubview: _uil_textSection];
}

-(void)initToggle
{
    _uiv_toggleContainer = [[UIView alloc] initWithFrame:CGRectMake(1024-200, 0.0, 200.0, 50.0)];
    _uiv_toggleContainer.backgroundColor = [UIColor blueColor];
    [self.view insertSubview:_uiv_toggleContainer aboveSubview:_uiv_collapseContainer];
    [self addToggleBtns];
    _uiv_toggleContainer.hidden = YES;
}

#pragma mark - init non/summer toggle buttons
-(void)addToggleBtns
{
    _uib_normalTime = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_normalTime.frame = CGRectMake(0.0, 0.0, 100.0, 50.0);
    _uib_normalTime.backgroundColor = [UIColor grayColor];
    _uib_normalTime.tag = 1;
    [_uib_normalTime setTitle:@"Typical" forState:UIControlStateNormal];
    [_uib_normalTime setTitle:@"Typical" forState:UIControlStateSelected];
    [_uib_normalTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_uib_normalTime setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _uib_normalTime.userInteractionEnabled = NO;
    _uib_normalTime.selected = YES;
    [_uib_normalTime addTarget:self action:@selector(toggleBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _uib_summerTime = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_summerTime.frame = CGRectMake(100.0, 0.0, 100.0, 50.0);
    _uib_summerTime.backgroundColor = [UIColor grayColor];
    _uib_summerTime.tag = 2;
    [_uib_summerTime setTitle:@"Summer" forState:UIControlStateNormal];
    [_uib_summerTime setTitle:@"Summer" forState:UIControlStateSelected];
    [_uib_summerTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_uib_summerTime setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _uib_summerTime.userInteractionEnabled = YES;
    [_uib_summerTime addTarget:self action:@selector(toggleBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_uiv_toggleContainer addSubview: _uib_normalTime];
    [_uiv_toggleContainer addSubview: _uib_summerTime];
}

-(void)toggleBtnTapped:(id)sender
{
    
    UIButton *tappedBtn = sender;
    NSString *path;
    if (tappedBtn.tag == 1) {
        path = [[NSBundle mainBundle] pathForResource:overlayName ofType:@"png"];
        _uib_normalTime.userInteractionEnabled = NO;
        _uib_normalTime.selected = YES;
        _uib_summerTime.userInteractionEnabled = YES;
        _uib_summerTime.selected = NO;
    }
    else {
        NSString *sumOverlay = [NSString stringWithFormat:@"%@_summer", overlayName];
         path = [[NSBundle mainBundle] pathForResource:sumOverlay ofType:@"png"];
        _uib_summerTime.userInteractionEnabled = NO;
        _uib_summerTime.selected = YES;
        _uib_normalTime.userInteractionEnabled = YES;
        _uib_normalTime.selected = NO;
    }
    [_uis_zoomingMap.overView setImage:[UIImage imageWithContentsOfFile:path]];
}

-(void)updateOverlay
{
    NSString *path = [[NSBundle mainBundle] pathForResource:overlayName ofType:@"png"];
    [_uis_zoomingMap.overView setImage:[UIImage imageWithContentsOfFile:path]];
}

#pragma mark - bottom left Gallery button
-(void)initAccessBtn
{
    _uib_access = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_access.frame = CGRectMake(20, 768 - 30 - 20, 76.0, 30.0);
//    [_uib_access setImage:[UIImage imageNamed:@"grfx_qanda.png"] forState:UIControlStateNormal];
    [_uib_access addTarget:self action:@selector(accessTapped) forControlEvents:UIControlEventTouchDown];
    _uib_access.backgroundColor= [UIColor whiteColor];
    [_uib_access setTitle:@"LIVE" forState:UIControlStateNormal];
    [_uib_access setTitleColor:[UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_uib_access.titleLabel setFont:[UIFont fontWithName:@"DINEngschriftStd" size:17]];
    [_uib_access setTitleEdgeInsets:UIEdgeInsetsMake(6, 0, 0, 0)];
    [self.view addSubview:_uib_access];
}

-(void)accessTapped
{
/* THIS PART LOAD THE FGALLERY!!!
    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"10_Fall_River_Depot_1000.jpg", @"11_Battleship_Cove_5000.jpg", nil];
    localImages = imageArray;
    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    _navigationController = [[UINavigationController alloc]
                             initWithRootViewController:localGallery];
    _navigationController.view.frame = CGRectMake(0.0, 0.0, 1024, 768);
    [self addChildViewController: _navigationController];
    [_navigationController setNavigationBarHidden:YES];
    [self.view addSubview: _navigationController.view];
 */
    
//    NSString *theUrl = @"https://boston.maps.arcgis.com/sharing/rest/oauth2/authorize?client_id=arcgisonline&redirect_uri=https://boston.maps.arcgis.com/home/postsignin.html&response_type=token&display=iframe&parent=https://boston.maps.arcgis.com&expiration=20160&locale=en";
    NSString *theUrl = @"http://boston.maps.arcgis.com/apps/Viewer/index.html?appid=bbd9f5179822486a854f6197fc7fcd3f";
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	xhWebViewController *vc = (xhWebViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"xhWebViewController"];
	[vc socialButton:theUrl];
	vc.title = @"ArcGIS - Live Traffic Data";//@"Username: PCampot_boston   Password: suffolk1";
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNaviBtn" object:self];
	[self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - init Home button
-(void)initHomeBtn
{
    _uib_home = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_home.frame = CGRectMake(0.0, 0, 30.0, 85.0);
    [_uib_home setTitle:@"HOME" forState:UIControlStateNormal];
    [_uib_home setTitleColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _uib_home.backgroundColor = [UIColor colorWithRed:162.0/255.0 green:214.0/255.0 blue:237.0/255.0 alpha:1.0];
    [_uib_home setTitleEdgeInsets:UIEdgeInsetsMake(6, 0, 0, 0)];
    [_uib_home.titleLabel setFont:[UIFont fontWithName:@"DINEngschriftStd" size:17]];
    [_uib_home addTarget:self action:@selector(homeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _uib_home];
}

-(void)homeTapped
{
    [self tapOnBottomMenu:_uib_bos2014];
    [self updateMap:10];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetApp" object:nil];
}

#pragma mark - init collapse view's content views

#pragma mark - Traffic View
-(UIView *)createTrafficView
{
    UIView *_uiv_traffic;
    if (sectionIndex == 1) {
        _uiv_traffic = [self create2014Traffic];
    }
    if (sectionIndex == 2) {
        _uiv_traffic = [self create2024Traffic];
    }
    if (sectionIndex == 3) {
        _uiv_traffic = [self createOlymTraffic];
    }
    return _uiv_traffic;
}

-(UIView *)create2014Traffic
{
    UIView *uiv_traffic1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 120)];
    uiv_traffic1.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    UIButton *uib_traffic1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic4 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uib_traffic1.frame = CGRectMake(0.0, 0.0, container_W, 30);
    uib_traffic1.backgroundColor = [UIColor clearColor];
    [uib_traffic1 setTitle:@"Highway (Academic)" forState:UIControlStateNormal];
    uib_traffic1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic1.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic1.tag = 1;
    [uib_traffic1 addTarget:self action:@selector(tap2014TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic2.frame = CGRectMake(0.0, 30.0, container_W, 30);
    uib_traffic2.backgroundColor = [UIColor clearColor];
    [uib_traffic2 setTitle:@"Highway (Summer)" forState:UIControlStateNormal];
    uib_traffic2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic2.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic2.tag = 2;
    [uib_traffic2 addTarget:self action:@selector(tap2014TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic3.frame = CGRectMake(0.0, 60.0, container_W, 30);
    uib_traffic3.backgroundColor = [UIColor clearColor];
    [uib_traffic3 setTitle:@"Transit Policy (Academic)" forState:UIControlStateNormal];
    uib_traffic3.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic3.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic3.tag = 3;
    [uib_traffic3 addTarget:self action:@selector(tap2014TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic4.frame = CGRectMake(0.0, 90.0, container_W, 30);
    uib_traffic4.backgroundColor = [UIColor clearColor];
    [uib_traffic4 setTitle:@"Transit Policy (Summer)" forState:UIControlStateNormal];
    uib_traffic4.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic4.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic4.tag = 4;
    [uib_traffic4 addTarget:self action:@selector(tap2014TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    [uiv_traffic1 addSubview: uib_traffic1];
    [uiv_traffic1 addSubview: uib_traffic2];
    [uiv_traffic1 addSubview: uib_traffic3];
    [uiv_traffic1 addSubview: uib_traffic4];
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, uiv_traffic1.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0]];
    [uiv_traffic1 addSubview: uiv_sideBar];
    return uiv_traffic1;
}

-(void)tap2014TrafficBtns:(id)sender
{
    
    UIButton *tappedBtn = sender;
    int index = (int)tappedBtn.tag;
    [tappedBtn.superview addSubview: _uiiv_indicator];
    switch (index) {
        case 1:
        {
            [self setInfoText:@"Existing Highway Conditions During the Academic Year"];
            [self updateRightTextBox:@"01-01-right-panel"];
            overlayName = @"overlay_highway_A";
            [self updateOverlay];
            [self updateTopRightBox:@"map-key-vehicular-traffic"];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        case 2:
        {
            [self setInfoText:@"Existing Highway Conditions During Summer Months"];
            [self updateRightTextBox:@"01-02-right-panel"];
            overlayName = @"overlay_highway_S";
            [self updateTopRightBox:@"map-key-vehicular-traffic"];
            [self updateOverlay];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        case 3:
        {
            [self setInfoText:@"Existing Transit Conditions During Academic Months"];
            [self updateRightTextBox:@"01-03-right-panel"];
            overlayName = @"overlay_trasit_A";
            [self updateTopRightBox:@"map-key-transit-traffic"];
            [self updateOverlay];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        case 4:
        {
            [self setInfoText:@"Existing Transit Conditions During Summer Months"];
            [self updateRightTextBox:@"01-04-right-panel"];
            overlayName = @"overlay_trasit_S";
            [self updateTopRightBox:@"map-key-transit-traffic"];
            [self updateOverlay];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        default:
            break;
    }
    _uiv_textBoxContainer.hidden = NO;
}

-(UIView *)create2024Traffic
{
    UIView *uiv_traffic2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 120)];
    uiv_traffic2.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    UIButton *uib_traffic1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic4 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uib_traffic1.frame = CGRectMake(0.0, 0.0, container_W, 30);
    uib_traffic1.backgroundColor = [UIColor clearColor];
    [uib_traffic1 setTitle:@"Highway - w/o Improvements" forState:UIControlStateNormal];
    uib_traffic1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic1.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic1.tag = 1;
    [uib_traffic1 addTarget:self action:@selector(tap2024TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic2.frame = CGRectMake(0.0, 30.0, container_W, 30);
    uib_traffic2.backgroundColor = [UIColor clearColor];
    [uib_traffic2 setTitle:@"Highway - w/ Improvements" forState:UIControlStateNormal];
    uib_traffic2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic2.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic2.tag = 2;
    [uib_traffic2 addTarget:self action:@selector(tap2024TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic3.frame = CGRectMake(0.0, 60.0, container_W, 30);
    uib_traffic3.backgroundColor = [UIColor clearColor];
    [uib_traffic3 setTitle:@"Transit Policy - w/o Improvements" forState:UIControlStateNormal];
    uib_traffic3.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic3.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic3.tag = 3;
    [uib_traffic3 addTarget:self action:@selector(tap2024TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic4.frame = CGRectMake(0.0, 90.0, container_W, 30);
    uib_traffic4.backgroundColor = [UIColor clearColor];
    [uib_traffic4 setTitle:@"Transit Policy - w/ Improvements" forState:UIControlStateNormal];
    uib_traffic4.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic4.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic4.tag = 4;
    [uib_traffic4 addTarget:self action:@selector(tap2024TrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    [uiv_traffic2 addSubview: uib_traffic1];
    [uiv_traffic2 addSubview: uib_traffic2];
    [uiv_traffic2 addSubview: uib_traffic3];
    [uiv_traffic2 addSubview: uib_traffic4];
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, uiv_traffic2.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0]];
    [uiv_traffic2 addSubview: uiv_sideBar];
    return uiv_traffic2;
}

-(void)tap2024TrafficBtns:(id)sender
{
    UIButton *tappedBtn = sender;
    int index = (int)tappedBtn.tag;
    [tappedBtn.superview addSubview: _uiiv_indicator];
    switch (index) {
        case 1:
        {
            [self setInfoText:@"Projected Summer Highway Conditions without Improvements"];
            [self updateRightTextBox:@"02-01-right-panel"];
            overlayName = @"overlay_highway_N";
            [self updateOverlay];
            [self updateTopRightBox:@"map-key-vehicular-traffic"];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        case 2:
        {
            [self setInfoText:@"Projected Summer Highway Conditions with Improvements"];
            [self updateRightTextBox:@"02-02-right-panel"];
            overlayName = @"overlay_highway_W";
            [self updateTopRightBox:@"map-key-vehicular-traffic"];
            [self updateOverlay];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        case 3:
        {
            [self setInfoText:@"Projected Summer Transit Policy Conditions without Improvements"];
//            [self updateRightTextBox:@"02-02-right-panel"];
            _uiiv_rightTextBox.hidden = YES;
            overlayName = @"overlay_highway_W";
            [self updateTopRightBox:@"map-key-transit-traffic"];
            [self updateOverlay];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        case 4:
        {
            [self setInfoText:@"Projected Summer Transit Policy Conditions with Improvements"];
//            [self updateRightTextBox:@"02-02-right-panel"];
            _uiiv_rightTextBox.hidden = YES;
            overlayName = @"overlay_highway_W";
            [self updateTopRightBox:@"map-key-transit-traffic"];
            [self updateOverlay];
            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
            break;
        }
        default:
            break;
    }
    _uiv_textBoxContainer.hidden = NO;
}

-(UIView *)createOlymTraffic
{
    UIView *uiv_traffic3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 210)];
    uiv_traffic3.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    UIButton *uib_trafficLane = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_traffic4 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_trafficTime = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_walk = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uib_trafficLane.frame = CGRectMake(0.0, 0.0, container_W, 30);
    uib_trafficLane.backgroundColor = [UIColor clearColor];
    [uib_trafficLane setTitle:@"Olympic Lanes" forState:UIControlStateNormal];
    uib_trafficLane.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_trafficLane.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_trafficLane.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_trafficLane.tag = 1;
    [uib_trafficLane addTarget:self action:@selector(tapOlymTrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic1.frame = CGRectMake(0.0, 30.0, container_W, 30);
    uib_traffic1.backgroundColor = [UIColor clearColor];
    [uib_traffic1 setTitle:@"Highway - w/o Olympics" forState:UIControlStateNormal];
    uib_traffic1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic1.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic1.tag = 2;
    [uib_traffic1 addTarget:self action:@selector(tapOlymTrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic2.frame = CGRectMake(0.0, 60.0, container_W, 30);
    uib_traffic2.backgroundColor = [UIColor clearColor];
    [uib_traffic2 setTitle:@"Highway - w/ Olympics" forState:UIControlStateNormal];
    uib_traffic2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic2.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic2.tag = 3;
    [uib_traffic2 addTarget:self action:@selector(tapOlymTrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic3.frame = CGRectMake(0.0, 90.0, container_W, 30);
    uib_traffic3.backgroundColor = [UIColor clearColor];
    [uib_traffic3 setTitle:@"Transit Crush - w/o Olympics" forState:UIControlStateNormal];
    uib_traffic3.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic3.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic3.tag = 4;
    [uib_traffic3 addTarget:self action:@selector(tapOlymTrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_traffic4.frame = CGRectMake(0.0, 120.0, container_W, 30);
    uib_traffic4.backgroundColor = [UIColor clearColor];
    [uib_traffic4 setTitle:@"Transit Crush - w/ Olympics" forState:UIControlStateNormal];
    uib_traffic4.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_traffic4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_traffic4.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_traffic4.tag = 5;
    [uib_traffic4 addTarget:self action:@selector(tapOlymTrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_trafficTime.frame = CGRectMake(0.0, 150.0, container_W, 30);
    uib_trafficTime.backgroundColor = [UIColor clearColor];
    [uib_trafficTime setTitle:@"Travel Times" forState:UIControlStateNormal];
    uib_trafficTime.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_trafficTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_trafficTime.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_trafficTime.tag = 6;
    [uib_trafficTime addTarget:self action:@selector(tapOlymTrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_walk.frame = CGRectMake(0.0, 180.0, container_W, 30);
    uib_walk.backgroundColor = [UIColor clearColor];
    [uib_walk setTitle:@"Walking Distances" forState:UIControlStateNormal];
    uib_walk.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_walk.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_walk.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_walk.tag = 7;
    [uib_walk addTarget:self action:@selector(tapOlymTrafficBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    [uiv_traffic3 addSubview: uib_trafficLane];
    [uiv_traffic3 addSubview: uib_traffic1];
    [uiv_traffic3 addSubview: uib_traffic2];
    [uiv_traffic3 addSubview: uib_traffic3];
    [uiv_traffic3 addSubview: uib_traffic4];
    [uiv_traffic3 addSubview: uib_trafficTime];
    [uiv_traffic3 addSubview: uib_walk];
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, uiv_traffic3.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0]];
    [uiv_traffic3 addSubview: uiv_sideBar];
    return uiv_traffic3;
}

-(void)tapOlymTrafficBtns:(id)sender
{
    [self removeVillageBtns];
    
    UIButton *tappedBtn = sender;
    int index = (int)tappedBtn.tag;
    [tappedBtn.superview addSubview: _uiiv_indicator];
    [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
    switch (index) {
        case 1:
        {
            [self setInfoText:@"Regional Intercept Strategy and Dedicated Olympic Lanes"];
            [self updateRightTextBox:@"03-01-right-panel"];
            overlayName = @"overlay_OlymLane";
            [self updateTopRightBox:@"map-key-olympic-lanes"];
            [self updateOverlay];
            break;
        }
        case 2:
        {
            [self setInfoText:@"Summer Highway Conditions after Improvements without Olympics"];
            [self updateRightTextBox:@"03-02-right-panel"];
            overlayName = @"overlay_Olyhighway_N";
            [self updateTopRightBox:@"map-key-vehicular-traffic"];
            [self updateOverlay];
            break;
        }
        case 3:
        {
            [self setInfoText:@"Olympic Highway Conditions with Background Demand Reductions"];
            [self updateRightTextBox:@"03-03-right-panel"];
            overlayName = @"overlay_Olyhighway_W";
            [self updateTopRightBox:@"map-key-vehicular-traffic"];
            [self updateOverlay];
            break;
        }
        case 4:
        {
            [self setInfoText:@"Projected Summer Transit Crush Conditions without Olympics"];
            [self updateRightTextBox:@"03-04-right-panel"];
            overlayName = @"overlay_transit_P";
            [self updateTopRightBox:@"map-key-transit-traffic"];
            [self updateOverlay];
            break;
        }
        case 5:
        {
            [self setInfoText:@"Projected Summer Transit Crush Conditions with Olympics"];
            [self updateRightTextBox:@"03-05-right-panel"];
            overlayName = @"overlay_transit_C";
            [self updateTopRightBox:@"map-key-transit-traffic"];
            [self updateOverlay];
            break;
        }
        case 6:
        {
            [self setInfoText:@"Vehicle Travel Times Using Olympic Roadway Network"];
            overlayName = @"03-06-bg-drive-times-map";
            _uiiv_topRightBox.hidden = YES;
            _uiiv_rightTextBox.hidden = YES;
            [self updateOverlay];
            [self initVillageBtns];
            break;
        }
        case 7:
        {
            [self setInfoText:@"Walking Distances"];
            overlayName = @"03-06-bg-drive-times-map";
            _uiiv_topRightBox.hidden = YES;
            _uiiv_rightTextBox.hidden = YES;
            [self updateOverlay];
            [self initVillageBtns];
            break;
        }
        default:
            break;
    }
    _uiv_textBoxContainer.hidden = NO;
}

#pragma mark - Create People view
-(UIView *)createPeopleView
{
    UIView *_uiv_people;
    if (sectionIndex == 1) {
        _uiv_people = [self create2014People];
    }
    if (sectionIndex == 2) {
        _uiv_people = [self create2024People];
    }
    return _uiv_people;
}

-(UIView *)create2014People
{
    UIView *uiv_people1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 60)];
    uiv_people1.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    UIButton *uib_people1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_people2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIButton *uib_people3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIButton *uib_people4 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uib_people1.frame = CGRectMake(0.0, 0.0, container_W, 30);
    uib_people1.backgroundColor = [UIColor clearColor];
    [uib_people1 setTitle:@"Metro - Residential" forState:UIControlStateNormal];
    uib_people1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_people1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_people1.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_people1.tag = 1;
    [uib_people1 addTarget:self action:@selector(tap2014PeopleBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_people2.frame = CGRectMake(0.0, 30.0, container_W, 30);
    uib_people2.backgroundColor = [UIColor clearColor];
    [uib_people2 setTitle:@"Metro - Daily" forState:UIControlStateNormal];
    uib_people2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_people2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_people2.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_people2.tag = 2;
    [uib_people2 addTarget:self action:@selector(tap2014PeopleBtns:) forControlEvents:UIControlEventTouchUpInside];
    
//    uib_people3.frame = CGRectMake(0.0, 60.0, container_W, 30);
//    uib_people3.backgroundColor = [UIColor clearColor];
//    [uib_people3 setTitle:@"City Daily" forState:UIControlStateNormal];
//    uib_people3.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
//    uib_people3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    uib_people3.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
//    uib_people3.tag = 3;
//    [uib_people3 addTarget:self action:@selector(tap2014PeopleBtns:) forControlEvents:UIControlEventTouchUpInside];
//    
//    uib_people4.frame = CGRectMake(0.0, 90.0, container_W, 30);
//    uib_people4.backgroundColor = [UIColor clearColor];
//    [uib_people4 setTitle:@"City Residential" forState:UIControlStateNormal];
//    uib_people4.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
//    uib_people4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    uib_people4.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
//    uib_people4.tag = 4;
//    [uib_people4 addTarget:self action:@selector(tap2014PeopleBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    [uiv_people1 addSubview: uib_people1];
    [uiv_people1 addSubview: uib_people2];
//    [uiv_people1 addSubview: uib_people3];
//    [uiv_people1 addSubview: uib_people4];
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, uiv_people1.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0]];
    [uiv_people1 addSubview: uiv_sideBar];
    return uiv_people1;
}

-(void)tap2014PeopleBtns:(id)sender
{
    UIButton *tappedBtn = sender;
    int index = (int)tappedBtn.tag;
    [tappedBtn.superview addSubview: _uiiv_indicator];
    [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
    switch (index) {
        case 1:
        {
            [self setInfoText:@"Existing Metro Residential Population"];
            [self updateRightTextBox:@"01-05-right-panel"];
            overlayName = @"01-06-bg-2014_RegionalResidentialPopulation";
            [self updateOverlay];
            [self updateTopRightBox:@"map-key-population-density 2"];
            break;
        }
        case 2:
        {
            [self setInfoText:@"Existing Metro Daily Population"];
            [self updateRightTextBox:@"01-06-right-panel"];
            overlayName = @"01-07-bg-2014_RegionalDailyPopulation";
            [self updateOverlay];
            [self updateTopRightBox:@"map-key-population-density 2"];
            break;
        }
//        case 3:
//        {
//            [self setInfoText:@"Existing City Daily Population"];
//            [self updateRightTextBox:@"01-06-right-panel"];
//            overlayName = @"01-07-bg-2014_RegionalDailyPopulation";
//            [self updateOverlay];
//            [self updateTopRightBox:@"map-key-population-density 2"];
//            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
//            break;
//        }
//        case 4:
//        {
//            [self setInfoText:@"Existing City Residential Population"];
//            [self updateRightTextBox:@"01-05-right-panel"];
//            overlayName = @"01-06-bg-2014_RegionalResidentialPopulation";
//            [self updateOverlay];
//            [self updateTopRightBox:@"map-key-population-density 2"];
//            [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
//            break;
//        }
        default:
            break;
    }
    _uiv_textBoxContainer.hidden = NO;
}

-(UIView *)create2024People
{
    UIView *uiv_people2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 60)];
    uiv_people2.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    UIButton *uib_people1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_people2 = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_people1.frame = CGRectMake(0.0, 0.0, container_W, 30);
    uib_people1.backgroundColor = [UIColor clearColor];
    [uib_people1 setTitle:@"Metro - Residential" forState:UIControlStateNormal];
    uib_people1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_people1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_people1.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_people1.tag = 1;
    [uib_people1 addTarget:self action:@selector(tap2024PeopleBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    uib_people2.frame = CGRectMake(0.0, 30.0, container_W, 30);
    uib_people2.backgroundColor = [UIColor clearColor];
    [uib_people2 setTitle:@"Metro - Daily" forState:UIControlStateNormal];
    uib_people2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_people2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_people2.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    uib_people2.tag = 2;
    [uib_people2 addTarget:self action:@selector(tap2024PeopleBtns:) forControlEvents:UIControlEventTouchUpInside];
    
    [uiv_people2 addSubview: uib_people1];
    [uiv_people2 addSubview: uib_people2];
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, uiv_people2.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0]];
    [uiv_people2 addSubview: uiv_sideBar];
    return uiv_people2;
}

-(void)tap2024PeopleBtns:(id)sender
{
    UIButton *tappedBtn = sender;
    int index = (int)tappedBtn.tag;
    [tappedBtn.superview addSubview: _uiiv_indicator];
    [self updateIndicatorPosition:CGRectMake(kIndicatorX, tappedBtn.frame.origin.y + kIndicatorY, _uiiv_indicator.frame.size.width, _uiiv_indicator.frame.size.height)];
    switch (index) {
        case 1:
        {[self setInfoText:@"Projected Metro Residential Population"];
            [self updateRightTextBox:@"02-03-right-panel"];
            overlayName = @"02-03-2014_RegionalResidentialPopulation";
            [self updateOverlay];
            [self updateTopRightBox:@"map-key-population-density 2"];
            break;
        }
        case 2:
        {
            [self setInfoText:@"Projected Metro Daily Population"];
            [self updateRightTextBox:@"02-04-right-panel"];
            overlayName = @"02-04-2014_RegionalDailyPopulation";
            [self updateOverlay];
            [self updateTopRightBox:@"map-key-population-density 2"];
            break;
        }
        default:
            break;
    }
    _uiv_textBoxContainer.hidden = NO;
}

-(void)initTrackContentView {
    [_arr_tracksBtn removeAllObjects];
    _arr_tracksBtn = nil;
    _arr_tracksBtn = [[NSMutableArray alloc] init];
    
    _uiv_tracksContent = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 150)];
    _uiv_tracksContent.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    _uiv_tracksContent.tag = 3002;
    
    _uiv_tracksDot = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 6.0, 6.0)];
    _uiv_tracksDot.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
    
    UIButton *uib_tracks1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_tracks2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_tracks3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_tracks4 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_tracks5 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uib_tracks1.frame = CGRectMake(0, 0, container_W, 30);
    uib_tracks1.backgroundColor = [UIColor clearColor];
    [uib_tracks1 setTitle:@"Reconstructed Tracks" forState:UIControlStateNormal];
    uib_tracks1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_tracks1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_tracks1.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_tracks1.tag = 7001;
    [_arr_tracksBtn addObject: uib_tracks1];
	
	uib_tracks3.frame = CGRectMake(0, 60, container_W, 30);
    uib_tracks3.backgroundColor = [UIColor clearColor];
    [uib_tracks3 setTitle:@"Newly Constructed Tracks" forState:UIControlStateNormal];
    uib_tracks3.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_tracks3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_tracks3.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
	uib_tracks2.tag = 7002;
    [_arr_tracksBtn addObject: uib_tracks3];
    
    uib_tracks2.frame = CGRectMake(0, 30, container_W, 30);
    uib_tracks2.backgroundColor = [UIColor clearColor];
    [uib_tracks2 setTitle:@"Active Freight Rail Service" forState:UIControlStateNormal];
    uib_tracks2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_tracks2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_tracks2.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_tracks3.tag = 7003;
    [_arr_tracksBtn addObject: uib_tracks2];
    
    uib_tracks4.frame = CGRectMake(0, 90, container_W, 30);
    uib_tracks4.backgroundColor = [UIColor clearColor];
    [uib_tracks4 setTitle:@"51.9m Reconstruction" forState:UIControlStateNormal];
    uib_tracks4.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_tracks4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_tracks4.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_tracks4.tag = 7004;
    [_arr_tracksBtn addObject: uib_tracks4];
    
    uib_tracks5.frame = CGRectMake(0, 120, container_W, 30);
    uib_tracks5.backgroundColor = [UIColor clearColor];
    [uib_tracks5 setTitle:@"Active/Inactive" forState:UIControlStateNormal];
    uib_tracks5.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_tracks5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_tracks5.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_tracks5.tag = 7005;
    [_arr_tracksBtn addObject: uib_tracks5];
    
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, _uiv_tracksContent.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0]];
    
    [_uiv_tracksContent addSubview: uib_tracks1];
    [_uiv_tracksContent addSubview: uib_tracks2];
    [_uiv_tracksContent addSubview: uib_tracks3];
    [_uiv_tracksContent addSubview: uib_tracks4];
    [_uiv_tracksContent addSubview: uib_tracks5];
    [_uiv_tracksContent addSubview: uiv_sideBar];
    
    [uib_tracks1 addTarget:self action:@selector(tracksTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_tracks2 addTarget:self action:@selector(tracksTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_tracks3 addTarget:self action:@selector(tracksTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_tracks4 addTarget:self action:@selector(tracksTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_tracks5 addTarget:self action:@selector(tracksTapped:) forControlEvents:UIControlEventTouchDown];
}
#pragma mark- TRACKS Action
-(void)tracksTapped:(id)sender {
    UIButton *tmpBtn = sender;
    [_uiv_directionDot removeFromSuperview];
    [_uiiv_overlays removeFromSuperview];
	
    if (_embDirectionPath) {
        [self directionViewCleanUp];
        NSLog(@"sdssdfdsf");
        //    return;
    }
    
    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"mapBG.jpg"];
    
    for (UIButton *tmp in _arr_tracksBtn) {
        if (tmp.tag != tmpBtn.tag) {
            tmp.selected = NO;
        }
    }
    
    if (tmpBtn.selected) {
        _uiv_tracksDot.transform = CGAffineTransformMakeTranslation(-50, 15);
        _preBtnTag = 0;
        tmpBtn.selected = NO;
        return;
    }
    
    switch (tmpBtn.tag) {
        case 7001: {
            _uiv_tracksDot.transform = CGAffineTransformMakeTranslation(16, 15);
            [_uiv_tracksContent insertSubview:_uiv_tracksDot aboveSubview:tmpBtn];
            [self addButtonsForDirections:@"low"];
            [self drawPathsFromBezierClass:tmpBtn];
            tmpBtn.selected = YES;
            break;
        }
        case 7002: {
            _uiv_tracksDot.transform = CGAffineTransformMakeTranslation(16, 45);
            [_uiv_tracksContent insertSubview:_uiv_tracksDot aboveSubview:tmpBtn];
            [self addButtonsForDirections:@"low"];
            [self drawPathsFromBezierClass:tmpBtn];
            tmpBtn.selected = YES;
            break;
        }
        case 7003: {
            _uiv_tracksDot.transform = CGAffineTransformMakeTranslation(16, 75);
            [_uiv_tracksContent insertSubview:_uiv_tracksDot aboveSubview:tmpBtn];
            [self addButtonsForDirections:@"low"];
            [self drawPathsFromBezierClass:tmpBtn];
            tmpBtn.selected = YES;
            break;
        }
        case 7004: {
            _uiv_tracksDot.transform = CGAffineTransformMakeTranslation(16, 105);
            [_uiv_tracksContent insertSubview:_uiv_tracksDot aboveSubview:tmpBtn];
            _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"grfx_textOverlay.png"];
            tmpBtn.selected = YES;
            break;
        }
        case 7005: {
            _uiv_tracksDot.transform = CGAffineTransformMakeTranslation(16, 135);
            [_uiv_tracksContent insertSubview:_uiv_tracksDot aboveSubview:tmpBtn];
            _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"grfx_active&inactive.png"];
            tmpBtn.selected = YES;
            break;
        }
        default:
            break;
    }
    
}
#pragma mark - Play movie
-(void)playMovie
{
    if (_playerViewController) {
        [_playerViewController.view removeFromSuperview];
        _playerViewController = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLogo" object:self];
    NSString *url = [[NSBundle mainBundle]
                     pathForResource:@"Skanska_101Seaport_Final_HD"
                     ofType:@"mov"];
    _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
    _playerViewController.view.frame = CGRectMake(0, 0, 1024, 768);
    _playerViewController.view.alpha=1.0;
    //            _playerViewController.extendedLayoutIncludesOpaqueBars = YES;
    _playerViewController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    //            _playerViewController.moviePlayer.controlStyle =  MPMovieControlStyleDefault;
    [_playerViewController.moviePlayer setAllowsAirPlay:YES];
    _playerViewController.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [self.view insertSubview:_playerViewController.view belowSubview:_uiv_collapseContainer];
    [_playerViewController.moviePlayer play];
}

-(void)doneButtonClick:(NSNotification*)aNotification{
    [_playerViewController.view removeFromSuperview];
    _playerViewController = nil;
}

#pragma mark Direction

- (void)addButtonsForDirections:(NSString*)t
{
    //[super viewDidLoad];
	
	if (_dirpathsArray) {
		[_dirpathsArray removeAllObjects];
		_dirpathsArray=nil;
	} else {
		_dirpathsArray = [[NSMutableArray alloc] init];
	}
	
	// grab all bezier paths from
	// embBezierPaths class
	_arr_pathItems = [[NSMutableArray alloc] init];
	embDirectionsHigh *paths;
	embDirections *dirpaths;
	
	if ([t isEqualToString:@"high"]) {
		paths = [[embDirectionsHigh alloc] init];
		_arr_pathItems = paths.bezierPaths;
		
	} else if ([t isEqualToString:@"low"]) {
		dirpaths = [[embDirections alloc] init];
		_arr_pathItems = dirpaths.bezierPaths;
	}
	
	//[self drawPathsFromBezierClass:nil];
}

-(void)drawPathsFromBezierClass:(id)sender
{
	// clean up
	[self removePaths];
	
	// actual drawpath function
	_embDirectionPath = [[embDrawBezierPath alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
	_embDirectionPath.delegate=self;
	[_uis_zoomingMap.uiv_windowComparisonContainer insertSubview:_embDirectionPath atIndex:2];

	int pathGrouping	= -1;
	int indexStart		= -1;
	
    switch ([sender tag]) {
        case 5001:
            pathGrouping	= 9;
            indexStart		= 0;
            break;
            
        case 7001:
            pathGrouping	= 3;
            indexStart		= 9;
            break;
            
        case 7002:
            pathGrouping	= 2;
            indexStart		= 12;
            break;
            
        case 7003:
            pathGrouping	= 1;
            indexStart		= 14;
            break;
            
        default:
            break;
    }
    //	}
	
	for (int i=0; i<pathGrouping; i++) {
		embBezierPathItem *p = _arr_pathItems[indexStart+i];
		_embDirectionPath.myPath = p.embPath;
		_embDirectionPath.animationSpeed = 3.0;
		_embDirectionPath.pathStrokeColor = p.pathColor;
		_embDirectionPath.pathLineWidth = p.pathWidth;
		_embDirectionPath.isTappable = NO;
		[_dirpathsArray addObject:_embDirectionPath]; // for removal later
		[_embDirectionPath startAnimationFromIndex:i afterDelay:0];
	}
}

// clear paths
-(void)removePaths
{
	NSInteger i = 0;
	for(embDrawBezierPath *pathView in _dirpathsArray) {
		if([pathView isKindOfClass:[embDrawBezierPath class]]) {
			UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
			[UIView animateWithDuration:.2 delay:((0.05 * i) + 0.2) options:options
							 animations:^{
								 pathView.alpha = 0.0;
							 }
							 completion:^(BOOL finished){
                                 [pathView embDrawBezierPathShouldRemove];
							 }];
			i += 1;
		}
	}
	[self directionViewCleanUp];
}

-(void)directionViewCleanUp
{
	[_embDirectionPath removeFromSuperview];
	_embDirectionPath=nil;
}

#pragma mark - Hotspots
-(void)initHotspots
{
    //    _hotspots = [[xhanchorPointHotspots alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    for (int i = 0; i < [_arr_hotspotsData count]; i++) {
        NSDictionary *hotspotInfo = [[NSDictionary alloc] initWithDictionary:_arr_hotspotsData[i]];
        
        NSString *str_position = [[NSString alloc] initWithString:[hotspotInfo objectForKey:@"xy"]];
        NSRange range = [str_position rangeOfString:@","];
        NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
        NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
        float position_x = [str_x floatValue];
        float position_y = [str_y floatValue];
        _hotspots = [[xhanchorPointHotspots alloc] initWithFrame:CGRectMake(position_x, position_y, 100.0, 100.0)];
        _hotspots.str_hotspotImage = [hotspotInfo objectForKey:@"image"];
        _hotspots.anchorPosition = [[hotspotInfo objectForKey:@"anchorPosition"] intValue];
        [_uis_zoomingMap.blurView addSubview:_hotspots];
        
        [_arr_hotsopts addObject:_hotspots];
    }
}
#pragma mark - Handle Button Actions



-(void)didRemove:(embSimpleScrollView *)customClass
{
    NSLog(@"message received");
    [UIView animateWithDuration:0.33
					 animations:^{
                         customClass.alpha = 0.0f;
                     }
					 completion:^(BOOL  completed){
						 [customClass removeFromSuperview];
                     }];
}

-(void)closeButtonTapped
{
    NSLog(@"\n\n The close menu is %@", [_uiv_closedMenuContainer description]);
    
    NSLog(@"\n\n Should close menu");
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(-(container_W), 0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_closedMenuContainer.transform = CGAffineTransformMakeTranslation(40, 0);
        }];
    }];
}

-(void)openMenu
{
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_closedMenuContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_collapseContainer.transform = CGAffineTransformIdentity;
        }];
    }];
}

-(void)resizeCollapseContainer:(int)numOfCell
{
    //    _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(numOfCell+1))/2, container_W, kCCHeaderHeight*(numOfCell+1));
    _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(numOfCell))/2, container_W, kCCHeaderHeight*(numOfCell));
    //    theCollapseClick.frame = CGRectMake(0.0f, kCCHeaderHeight, container_W, kCCHeaderHeight*numOfCell);
    theCollapseClick.frame = CGRectMake(0.0f, 0.0f, container_W, kCCHeaderHeight*numOfCell);
    theCollapseClick.originalFrameSize = theCollapseClick.frame.size;
}

#pragma mark
#pragma mark - Collapse Click Delegate
// Required Methods
-(int)numberOfCellsForCollapseClick {
    
//        [_uiv_collapseContainer setBackgroundColor:[UIColor clearColor]];
//        [self resizeCollapseContainer:3];
//        return (int)_arr_cellName.count;

        //        _uiv_collapseContainer.frame = CGRectMake(0.0f, (768-kCCHeaderHeight*(3+1))/2, container_W, kCCHeaderHeight*(3+1));
        [self resizeCollapseContainer:(int)_arr_cellName.count];
        [_uiv_collapseContainer setBackgroundColor:[UIColor clearColor]];
        return (int)_arr_cellName.count;

//    return 4;
}

-(UIImage *)iconForTitle:(int)index {
    switch (index) {

        case 0:{
            UIImage *icon5 = [UIImage imageNamed:@"icon_traffic.png"];
            return icon5;
            break;
        }
        case 1:{
            if (sectionIndex < 3) {
                UIImage *icon6 = [UIImage imageNamed:@"icon_people.png"];
                return icon6;
            }
            else {
                UIImage *icon6 = [UIImage imageNamed:@"icon_statistics.png"];
                return icon6;
            }
            break;
        }
        case 2:{
            UIImage *icon6 = [UIImage imageNamed:@"icon_statistics.png"];
            return icon6;
            break;
        }
        default:
            return nil;
            break;
    }
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    NSString *str_cellName = [[NSString alloc] init];
    str_cellName = [_arr_cellName objectAtIndex:index];
    return str_cellName;
}

//Add content view for each cell
-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0: {
            return [self createTrafficView];
            break;
        }
        case 1:{
            return [self createPeopleView];
            break;
        }
        case 2:{

//            [self initBridgeContentView];
//            return _uiv_bridgeContent;
            return nil;
            break;
            
        }
        default:
            return nil;
            break;
    }
}
-(UIColor *)colorForTitleSideBarAtIndex:(int)index
{
    switch (index) {
        case 0: //Traffic
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
		case 1: //People
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
        case 2: //Current Use
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
            
        default:
        {
            return [UIColor greenColor];
            break;
        }
    }
}
-(UIColor *)colorForTitleLabelAtIndex:(int)index
{
    switch (index) {
        case 0: //Traffic
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
		case 1: //People
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
        case 2: //Current Use
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
            
        default:
        {
            return [UIColor greenColor];
            break;
        }
    }
}
-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open;
{
//    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"mapBG.jpg"];
    for (UIView *tmp in _arr_hotsopts) {
        [tmp removeFromSuperview];
    }
    for (UIView *galleryBtn in _arr_galleryBtnArray) {
        [galleryBtn removeFromSuperview];
    }
    [_uiv_tracksDot removeFromSuperview];
    [_uiv_directionDot removeFromSuperview];
    [_uiiv_overlays removeFromSuperview];
    [self reloadTableViewAtIndex:index];
    [_arr_hotspotsData removeAllObjects];
    [_arr_hotsopts removeAllObjects];
	[self directionViewCleanUp];
    [_uis_zoomingMap.overView setImage:nil];
    _uiv_toggleContainer.hidden = YES;
    _uiv_textBoxContainer.hidden = YES;
    _uiiv_rightTextBox.hidden = YES;
    _uiiv_topRightBox.hidden = YES;
    _uiiv_indicator.hidden = YES;
    [self removeVillageBtns];
    [_uiiv_indicator removeFromSuperview];
    
    overlayName = @"00-bg-base-highways";
    [self updateOverlay];
    for (UIView *tmp in _arr_tapHotspots) {
        [tmp removeFromSuperview];
    }
    [_arr_tapHotspots removeAllObjects];
    
    //Check if is in city?
    //Load different overlays..!
    
    NSString *test = [[NSString alloc] initWithString:[_arr_cellName objectAtIndex:index]];
    if (open == NO) {
        _uiv_closedMenuContainer.frame = CGRectMake(-40.0, (768-36)/2, 40.0, 38);
        _uiv_closeMenuSideBar.backgroundColor = [UIColor clearColor];
        [_uil_cellName removeFromSuperview];
    }
    else
    {
        
//        _uiv_closedMenuContainer.frame = CGRectMake(-41.0, _uiv_collapseContainer.frame.origin.y, 41.0, _uiv_collapseContainer.frame.size.height);
        _uiv_closedMenuContainer.transform = CGAffineTransformIdentity;
        [self initCellNameLabel:test];
        _uiv_closeMenuSideBar.backgroundColor = [self colorForTitleSideBarAtIndex:index];
        _uil_cellName.textColor = [self colorForTitleSideBarAtIndex:index];
        
            switch (index) {
                case 0: // Traffic
                {
                    [self setSectionText: test];
//                    [self updateOverlay];
                    break;
                }
                case 1: // People / Statistics(Olympic)
                {
                    [self setSectionText: test];
                    NSLog(@"The tapped index is %i", index);
                    if (sectionIndex == 3) {
                        [self loadHelp];
                    }
                    break;
                }
                case 2: // Statistics (2014 & 2024)
                {
                    [self setSectionText: test];
                    [self loadHelp];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                default:
                    break;
            }
    }
}

-(void)zoomInRect:(NSValue *)rect {
    CGRect theRect = [rect CGRectValue];
    [_uis_zoomingMap zoomToRect:theRect animated:YES duration:2.5];
    [_uis_zoomingMap resetPinSize];
}

#pragma mark - Load Help view
- (void)loadHelp
{
    NSArray *helpArray;
    switch (sectionIndex) {
        case 1: {
            UIImage *helpImage = [UIImage imageNamed:@"01A-panel-population.png"];
            UIImage *helpImage1 = [UIImage imageNamed:@"01B-panel-transit.png"];
            UIImage *helpImage2 = [UIImage imageNamed:@"02B-panel-summer-transit.png"];
            UIImage *helpImage3 = [UIImage imageNamed:@"02C-panel-summer-reduction-journeys.png"];
            UIImage *helpImage4 = [UIImage imageNamed:@"00-transit-map.png"];
            helpArray = [[NSArray alloc] initWithObjects:helpImage, helpImage1, helpImage2, helpImage3, helpImage4, nil];
            break;
        }
        case 2: {
            UIImage *helpImage = [UIImage imageNamed:@"02A-panel-massdot-improvements.png"];
            UIImage *helpImage1 = [UIImage imageNamed:@"03A-panel-highway-transit-growth.png"];
//            UIImage *helpImage1 = [UIImage imageNamed:@"02B-panel-summer-transit.png"];
//            UIImage *helpImage2 = [UIImage imageNamed:@"02C-panel-summer-reduction-journeys.png"];
            helpArray = [[NSArray alloc] initWithObjects:helpImage, helpImage1, nil];
            break;
        }
        case 3: {
//            UIImage *helpImage1 = [UIImage imageNamed:@"03A-panel-highway-transit-growth.png"];
            UIImage *helpImage2 = [UIImage imageNamed:@"03B-panel-capacity.png"];
            UIImage *helpImage3 = [UIImage imageNamed:@"03C-panel-capacity-vs-demand.png"];
            helpArray = [[NSArray alloc] initWithObjects: helpImage2, helpImage3, nil];
            break;
        }
        default:
            break;
    }
    
    _helpVC = [[xhHelpViewController alloc] initWithImageArray:helpArray andFrame:CGRectMake(0.0, 0.0, 1024, 768)];
    [self.view addSubview: _helpVC.view];
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnHelp)];
    oneTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer: oneTap];
}

- (void)tapOnHelp
{
    [theCollapseClick closeCollapseClickCellAtIndex:_arr_cellName.count-1 animated:YES];
    [_helpVC.view removeFromSuperview];
    _helpVC.view = nil;
}

#pragma mark - Tappable Hotspots Setting
-(void)initTappleHotspots{
    for (UIView *tmp in _arr_tapHotspots) {
        [tmp removeFromSuperview];
    }
    [_arr_tapHotspots removeAllObjects];
    
    for (int i = 0; i < [_arr_tapHotspotArray count]; i++) {
        NSDictionary *hotspotItem = _arr_tapHotspotArray[i];
        //Get the position
        NSString *str_position = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"xy"]];
        NSRange range = [str_position rangeOfString:@","];
        NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
        NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
        float hs_x = [str_x floatValue];
        float hs_y = [str_y floatValue];
        _tappableHotspots = [[neoHotspotsView alloc] initWithFrame:CGRectMake(hs_x, hs_y, 17, 17)];
        _tappableHotspots.delegate = self;
        NSString *str_bgName = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"background"]];
        _tappableHotspots.hotspotBgName = str_bgName;
        _tappableHotspots.withCaption = YES;
        NSString *str_caption = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"caption"]];
        _tappableHotspots.str_labelText = str_caption;
        [_tappableHotspots.uil_caption setTextColor:[UIColor whiteColor]];
        _tappableHotspots.uil_caption.frame = CGRectMake(-160, 0, 150, 17);
        [_tappableHotspots.uil_caption setTextAlignment:NSTextAlignmentRight];
        if ((i == 0) || (i == 3)) {
            _tappableHotspots.uil_caption.frame = CGRectMake(_tappableHotspots.uiiv_hsImgView.frame.size.width+10, 0, 150, 17);
            [_tappableHotspots.uil_caption setTextAlignment:NSTextAlignmentLeft];
            _tappableHotspots.frame = CGRectMake(hs_x, _tappableHotspots.frame.origin.y, _tappableHotspots.frame.size.width+160, _tappableHotspots.frame.size.height);
            _tappableHotspots.uiiv_hsImgView.frame = CGRectMake(0.0, 0.0, 17, 17);
        }
        if ((i != 0) && (i != 3)) {
            _tappableHotspots.frame = CGRectMake(hs_x-160, hs_y, _tappableHotspots.frame.size.width+160+17, _tappableHotspots.frame.size.height);
            _tappableHotspots.uil_caption.frame = CGRectMake(0, 0, 150, 17);
            [_tappableHotspots.uil_caption setTextAlignment:NSTextAlignmentRight];
            _tappableHotspots.uiiv_hsImgView.frame = CGRectMake(160, 0, 17, 17);
        }
        
        NSString *str_type = [[NSString alloc] initWithString:[hotspotItem objectForKey:@"type"]];
        _tappableHotspots.str_typeOfHs = str_type;
        _tappableHotspots.uil_caption.drawOutline = YES;
        _tappableHotspots.tagOfHs = i+500;
        [_arr_tapHotspots addObject: _tappableHotspots];
        [_uis_zoomingMap.blurView addSubview: _tappableHotspots];
    }
}

-(void)neoHotspotsView:(neoHotspotsView *)hotspot didSelectItemAtIndex:(NSInteger)index{
    // Set up an Array for Images
    NSMutableArray *arrayofImages = [[NSMutableArray alloc] init];
    [arrayofImages addObject:@"Roof_Terrace.jpg"];
    [arrayofImages addObject:@"Office.jpg"];
    [arrayofImages addObject:@"Terrace.jpg"];
    [arrayofImages addObject:@"grfx_Office_facts.png"];
    [arrayofImages addObject:@"Lobby.jpg"];
    // Define the Scroll View for Images
    
    _uis_hotspotImages = [[embSimpleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) closeBtnLoc:CGRectMake((self.view.bounds.size.width - 104.0f),20.0f,84.0f,30.0f) btnImg:@"grfx_close_button_2.png" boolBtn:YES bgImg:nil andArray:arrayofImages andTag:150];
    
    [_uis_hotspotImages setDelegate:self];
    _uis_hotspotImages.loopArray = NO;
    _uis_hotspotImages.autoPlay = NO;
    [_uis_hotspotImages openScrollViewAtPage:(int)(index-500)];
    [self.view addSubview: _uis_hotspotImages];
    return;
    
}

#pragma mark - Reload Tableview According to the index
-(void)reloadTableViewAtIndex:(int)index
{
    
    NSString *path;
    UIView *tmp;
    
    if (index == 3) {
        path = @"hotspotList";
    }
    else if (index == 4) {
        path = @"hotspotLis";
    }
    else if (index == 5) {
        path = @"hotspotLis";
    }
    else if (index == 6) {
        path = @"hotspotList";
    }
    
    NSString *tmpp = [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
    _contentTableView.arr_tableData = [[NSMutableArray alloc] initWithContentsOfFile:tmpp];
    
    [self performSelector:@selector(changeview:) withObject:tmp afterDelay:0.25];
}

-(void)changeview: (UIView *)tmpView
{
    [_contentTableView.tableView reloadData];
    _contentTableView.tableView.frame = tmpView.frame;
    [tmpView addSubview:_contentTableView.tableView];
    
}

#pragma mark - Init Map kit Btns & Views
-(void)initMapToggle
{
    _uiv_mapToggles = [[UIView alloc] initWithFrame:CGRectMake(880.0f, 50.0f, 120.0f, 80.0f)];
    //    _uiv_mapToggles.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    //    _uib_originalMap = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _uib_originalMap.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    //    _uib_originalMap.backgroundColor = [UIColor clearColor];
    //    [_uib_originalMap setBackgroundImage:[UIImage imageNamed:@"map_neo-OFF.png"] forState:UIControlStateNormal];
    //    [_uib_originalMap setBackgroundImage:[UIImage imageNamed:@"map_neo-ON.png"] forState:UIControlStateSelected];
    //    [_uib_originalMap addTarget:self action:@selector(showOriginalMap) forControlEvents:UIControlEventTouchDown];
    //    [_uib_originalMap setSelected:YES];
    //    [_uiv_mapToggles addSubview: _uib_originalMap];
    //
    //    _uib_appleMap = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _uib_appleMap.frame = CGRectMake(40.0, 0.0, 40.0, 40.0);
    //    _uib_appleMap.backgroundColor = [UIColor clearColor];
    //    [_uib_appleMap setBackgroundImage:[UIImage imageNamed:@"map_apple-OFF.png"] forState:UIControlStateNormal];
    //    [_uib_appleMap setBackgroundImage:[UIImage imageNamed:@"map_apple-ON.png"] forState:UIControlStateSelected];
    //    [_uib_appleMap addTarget:self action:@selector(showAppleMap) forControlEvents:UIControlEventTouchDown];
    //    [_uiv_mapToggles addSubview: _uib_appleMap];
    
    _uib_googleMap = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_googleMap.frame = CGRectMake(80.0, 0.0, 40.0, 40.0);
    _uib_googleMap.backgroundColor = [UIColor clearColor];
    [_uib_googleMap setBackgroundImage:[UIImage imageNamed:@"map_google-OFF.png"] forState:UIControlStateNormal];
    [_uib_googleMap setBackgroundImage:[UIImage imageNamed:@"map_google-ON.png"] forState:UIControlStateSelected];
    [_uib_googleMap addTarget:self action:@selector(loadGoogleEarth) forControlEvents:UIControlEventTouchDown];
    [_uiv_mapToggles addSubview: _uib_googleMap];
    
    _uib_appleMapToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_appleMapToggle.frame = CGRectMake(0.0, 40.0, 120.0, 40.0);
    _uib_appleMapToggle.backgroundColor = [UIColor clearColor];
    [_uib_appleMapToggle setBackgroundImage:[UIImage imageNamed:@"map_apple-Toggle.png"] forState:UIControlStateNormal];
    [_uib_appleMapToggle setTitle:@"Satellite" forState:UIControlStateNormal];
    _uib_appleMapToggle.hidden = YES;
    [_uib_appleMapToggle addTarget:self action:@selector(changeMapType) forControlEvents:UIControlEventTouchDown];
    [_uiv_mapToggles addSubview:_uib_appleMapToggle];
    
    [self.view insertSubview:_uiv_mapToggles aboveSubview:_uiiv_bgImg];
}

-(void)initMapView
{
    //    _uis_zoomingMap.hidden = YES;
    
    //    [_uis_zoomingMap removeFromSuperview];
    //    _uis_zoomingMap = nil;
    
    _uiv_mapContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _uiv_mapContainer.backgroundColor= [UIColor redColor];
    _uiv_mapContainer.alpha = 0.5;
    [self.view addSubview:_uiv_mapContainer];
    
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    [_uiv_mapContainer addSubview: _mapView];
    
    ////    [self.view insertSubview:_uiv_mapContainer belowSubview:_uiv_mapToggles];
    NSLog(@"\n\n Should add apple map!!");
    NSLog(@"\n The map view is %@", _mapView);
}


#pragma  mark - Deal With Maps
-(void)showOriginalMap
{
    [_uib_appleMap setSelected:NO];
    [_uib_originalMap setSelected:YES];
    [_uib_googleMap setSelected:NO];
    
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished){  }];
    [_uiv_mapContainer removeFromSuperview];
    _uiv_mapContainer = nil;
    _uib_appleMapToggle.hidden = YES;
    [_uib_appleMapToggle setTitle:@"Satellite" forState:UIControlStateNormal];
    _uib_appleMap.userInteractionEnabled = YES;
}
-(void)loadGoogleEarth
{
    NSURL *urlApp = [NSURL URLWithString:@"comgoogleearth://"];
	BOOL canOpenApp = [[UIApplication sharedApplication] canOpenURL:urlApp];
	printf("\n canOpenGoogleEarth:%i \n",canOpenApp);
	
	if (canOpenApp) {
		[[UIApplication sharedApplication] canOpenURL:urlApp];
		NSString *stringURL = @"comgoogleearth://";
		NSURL *url = [NSURL URLWithString:stringURL];
		[[UIApplication sharedApplication] openURL:url];
	} else {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Sorry!"
								   message: @"You need Google Earth installed."
								  delegate: self
						 cancelButtonTitle: @"Cancel"
						 otherButtonTitles: @"Install",nil];
		[alert show];
	}
}
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger) buttonIndex {
    NSLog(@"foobage! %i", (int)buttonIndex);
	if (buttonIndex==1) {
		[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/us/app/google-earth/id293622097?mt=8"]];
	}
}
-(void)showAppleMap
{
    _uib_appleMapToggle.hidden = NO;
    
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(-(1+container_W), 0);
    } completion:^(BOOL finished){  }];
    
    [_uib_appleMap setSelected:YES];
    [_uib_originalMap setSelected:NO];
    [_uib_googleMap setSelected:NO];
    _uib_appleMap.userInteractionEnabled = NO;
    [self initMapView];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 42.344518;
    zoomLocation.longitude= -71.099107;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:NO];
    
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"1325 Boylston Ave" andCoordinate:zoomLocation];
    [self.mapView addAnnotation:newAnnotation];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region;
//	if (isCity) {
//        region = MKCoordinateRegionMakeWithDistance([mp coordinate], 2500, 2500);
//    }
//    else {
        region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
//    }
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
	userLocation.location.coordinate;
}

-(void)changeMapType
{
    NSLog(@"chnagemaptype");
	if (_mapView.mapType == MKMapTypeStandard)
	{
		_mapView.mapType = MKMapTypeSatellite;
		[_uib_appleMapToggle setTitle:@"Hybrid" forState:UIControlStateNormal];
    } else if (_mapView.mapType == MKMapTypeSatellite)
	{
		_mapView.mapType = MKMapTypeHybrid;
		[_uib_appleMapToggle setTitle:@"Standard" forState:UIControlStateNormal];
	} else if (_mapView.mapType == MKMapTypeHybrid)
	{
		_mapView.mapType = MKMapTypeStandard;
		[_uib_appleMapToggle setTitle:@"Satellite" forState:UIControlStateNormal];
	}
}

#pragma mark - FGallery Delegate Method
#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    //    if( gallery == localGallery ) {
    //		num = [localImages count];
    //	}
    //	else if( gallery == networkGallery ) {
    //		num = [networkImages count];
    //	}
	num = [localImages count];
	return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	if( gallery == localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == localGallery ) {
        caption = [localCaptions objectAtIndex:index];
    }
	//    else if( gallery == networkGallery ) {
	//        caption = [networkCaptions objectAtIndex:index];
	//    }
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [localImages objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}

- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

-(void)imageViewer:(id)sender {
	
    //	UIButton *tmpBtn = (UIButton*)sender;
    //
    //	galleryNameString = tmpBtn.titleLabel.text;
    //	tmpBtn.alpha = 0.6;
    //
    //	GalleryImagesViewController *vc = [[GalleryImagesViewController alloc] initWithGallery:[Gallery galleryNamed:galleryNameString]];
    //	[vc goToPageAtIndex:0 animated:NO];
    //
    //	CATransition* transition = [CATransition animation];
    //	transition.duration = 0.33;
    //	transition.type = kCATransitionFade;
    //	transition.subtype = kCATransitionFromTop;
    //
    //	[self.navigationController.view.layer
    //	 addAnimation:transition forKey:kCATransition];
    //	[self.navigationController pushViewController:vc animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
