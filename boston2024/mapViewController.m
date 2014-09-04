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
//#import "embAppDelegate.h"

#define METERS_PER_MILE 1609.344
static int numOfCells = 4;
static float container_W = 198.0;  // origial 186
static float kClosedMenu_W = 40.0;
@interface mapViewController ()<embSimpleScrollViewDelegate, embDrawBezierPathDelegate, embOverlayScrollViewDelegate>

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
@property (nonatomic, strong) UITextView                    *uitv_textBox;

@property (nonatomic, strong) UIView                        *uiv_toggleContainer;
@property (nonatomic, strong) UIButton                      *uib_normalTime;
@property (nonatomic, strong) UIButton                      *uib_summerTime;

@property (nonatomic, strong) UILabel                       *uil_cellName;

@property (nonatomic, strong) UIView                        *uiv_leftBar;

@property (nonatomic, strong) NSMutableArray                *arr_cellName;

@property (nonatomic, strong) UIView                        *uiv_stationContent;
@property (nonatomic, strong) UIView                        *uiv_bridgeContent;
@property (nonatomic, strong) NSMutableArray                *arr_bridgeBtns;
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
//navigation controller
@property (strong, nonatomic) UINavigationController        *navigationController;
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
    
    //Prepare gallery info from plist
    NSString *path_gallery = [[NSBundle mainBundle] pathForResource:@"gallery_buttons" ofType:@"plist"];
    _arr_galleryImageData = [[NSArray alloc] initWithContentsOfFile:path_gallery];
    _arr_galleryBtnArray = [[NSMutableArray alloc] init];
    
    //Prepare hotsopts' data from plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"location_hotspots" ofType:@"plist"];
    _dict_hotspots = [[NSDictionary alloc] initWithContentsOfFile:path];
    
	// Do any additional setup after loading the view, typically from a nib.
    _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"ALIGNMENT", @"STATIONS", @"BRIDGES", @"TRACKS", @"38 AT GRADE CROSSINGS", @"PARKING", @"CULTURAL RESOURCES", @"WETLAND FILL", @"GALLERY", nil];
    
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
        _contentTableView = [[contentTableViewController alloc] init];
        
    }
}

-(void)initZoomingMap
{
    // Set Zooming Map
    _uiiv_bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapBG.jpg"]];
    _uis_zoomingMap = [[embOverlayScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0) image:[UIImage imageNamed:@"mapBG.jpg"] overlay:nil shouldZoom:YES];
    _uis_zoomingMap.imageToggle = NO;
//    [_uis_zoomingMap.overView setImage:[UIImage imageNamed:@"grfx_alignmentOverlay.png"]];
    [self.view addSubview: _uis_zoomingMap];
}

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
    
    //Set Close Button
    _uib_closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_closeBtn setBackgroundColor:[UIColor clearColor]];
    [_uib_closeBtn setBackgroundImage:[UIImage imageNamed:@"map_menu_close@2x.png"] forState:UIControlStateNormal];
    _uib_closeBtn.frame = CGRectMake(container_W-29, 0, 30, 30);
    [_uib_closeBtn addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchDown];
    
    //Set Closed Menu Container
    _uiv_closedMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(-40.0, (768-38)/2, kClosedMenu_W, kClosedMenu_W)];
    _uiv_closedMenuContainer.clipsToBounds = NO;
    [_uiv_closedMenuContainer setBackgroundColor:[self normalCellColor]];
    _uib_openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_uib_openBtn setBackgroundColor:[UIColor clearColor]];
    [_uib_openBtn setBackgroundImage:[UIImage imageNamed:@"open_btn.jpg"] forState:UIControlStateNormal];
    _uib_openBtn.frame = CGRectMake(0, 0, kClosedMenu_W, kClosedMenu_W);
    [_uib_openBtn addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchDown];
    
    [_uiv_closedMenuContainer insertSubview:_uiv_closeMenuSideBar aboveSubview:_uil_cellName];
    [_uiv_closedMenuContainer addSubview:_uib_openBtn];
    [self initCellNameLabel:nil];
    
    theCollapseClick.CollapseClickDelegate = self;
    [theCollapseClick reloadCollapseClick];
    
    [_uiv_collapseContainer addSubview:theCollapseClick];
    [_uiv_collapseContainer addSubview:_uib_closeBtn];
    _uiv_collapseContainer.alpha = 0.0;
}

-(void)initCellNameLabel:(NSString *)cellName
{
    //Init UILabel
    CGFloat padding = 0.0;
    if (cellName)
        padding = 12.0;
    
    [_uil_cellName removeFromSuperview];
    [_uiv_closeMenuSideBar removeFromSuperview];
    
    _uil_cellName = [[UILabel alloc] initWithFrame:CGRectMake(10, 48.0, 30.0, 20.0)];//_uib_openBtn.frame.size.height = 40, space = 8, 40+8=48
    _uil_cellName.layer.anchorPoint = CGPointMake(0, 1.0);
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
    containerFrame.origin.y = (768 - containerFrame.size.height)/2;
    containerFrame.origin.x = _uiv_closedMenuContainer.frame.origin.x;
    _uiv_closedMenuContainer.frame = containerFrame;
    
    _uiv_closeMenuSideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, containerFrame.size.height)];
    _uiv_closeMenuSideBar.backgroundColor = [UIColor redColor];
    
    [_uiv_closedMenuContainer insertSubview:_uiv_closeMenuSideBar belowSubview:_uib_openBtn];
}

-(void)initBottomMenu
{
    _uiv_bottomMenu = [[UIView alloc] initWithFrame:CGRectMake(282, 733, 460, 35)];
    _uiv_bottomMenu.backgroundColor = [UIColor redColor];
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
    }
    UIButton *tappedBtn = sender;
    tappedBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    [self updateMap:(int)tappedBtn.tag];
}

-(void)updateMap:(int)index
{
    switch (index) {
        case 10:{
            [_arr_tapHotspots removeAllObjects];
            [_uis_zoomingMap resetScroll];
            [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
            [theCollapseClick closeCellResize];
            [_arr_cellName removeAllObjects];
            _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"ALIGNMENT", @"STATIONS", @"BRIDGES", @"TRACKS", @"38 AT GRADE CROSSINGS", @"PARKING", @"CULTURAL RESOURCES", @"WETLAND FILL", @"GALLERY", nil];
            theCollapseClick.CollapseClickDelegate = self;
            [theCollapseClick reloadCollapseClick];
            [_uis_zoomingMap.blurView setImage: [UIImage imageNamed:@"mapBG.jpg"]];
            break;
        }
        case 11:{
            [_arr_tapHotspots removeAllObjects];
            [_uis_zoomingMap resetScroll];
            [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
            [theCollapseClick closeCellResize];
            [_arr_cellName removeAllObjects];
            _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"ALIGNMENT", @"STATIONS", @"BRIDGES", @"TRACKS", nil];
            theCollapseClick.CollapseClickDelegate = self;
            [theCollapseClick reloadCollapseClick];
            [_uis_zoomingMap.blurView setImage: [UIImage imageNamed:@"boston_zoomed.jpg"]];
            break;
        }
        case 12:{
            [_arr_tapHotspots removeAllObjects];
            [_uis_zoomingMap resetScroll];
            [theCollapseClick closeCollapseClickCellsWithIndexes:_arr_cellName animated:NO];
            [theCollapseClick closeCellResize];
            [_arr_cellName removeAllObjects];
            _arr_cellName = [[NSMutableArray alloc] initWithObjects:@"38 AT GRADE CROSSINGS", @"PARKING", @"CULTURAL RESOURCES", @"WETLAND FILL", @"GALLERY", nil];
            theCollapseClick.CollapseClickDelegate = self;
            [theCollapseClick reloadCollapseClick];
            [_uis_zoomingMap.blurView setImage: [UIImage imageNamed:@"boston_zoomed.jpg"]];
            break;
        }
        default:
            break;
    }
}

-(void)initTextBox
{
    _uiv_textBoxContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 600, 85)];
    _uiv_textBoxContainer.backgroundColor = [UIColor redColor];
    [self.view insertSubview:_uiv_textBoxContainer aboveSubview:_uiv_collapseContainer];
    
    _uitv_textBox = [[UITextView alloc] initWithFrame:_uiv_textBoxContainer.bounds];
    [_uitv_textBox setText:@"Boston Info."];
    _uitv_textBox.backgroundColor = [UIColor clearColor];
    [_uitv_textBox setFont:[UIFont systemFontOfSize:18]];
    [_uitv_textBox setTextColor:[UIColor greenColor]];
    [_uiv_textBoxContainer addSubview: _uitv_textBox];
}

-(void)initToggle
{
    _uiv_toggleContainer = [[UIView alloc] initWithFrame:CGRectMake(1024-100, 0.0, 100.0, 50.0)];
    _uiv_toggleContainer.backgroundColor = [UIColor blueColor];
    [self.view insertSubview:_uiv_toggleContainer aboveSubview:_uiv_collapseContainer];
    [self addToggleBtns];
}

-(void)addToggleBtns
{
    _uib_normalTime = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_normalTime.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
    _uib_normalTime.backgroundColor = [UIColor redColor];
    _uib_normalTime.tag = 1;
    [_uib_normalTime addTarget:self action:@selector(toggleBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _uib_summerTime = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_summerTime.frame = CGRectMake(50.0, 0.0, 50.0, 50.0);
    _uib_summerTime.backgroundColor = [UIColor greenColor];
    _uib_summerTime.tag = 2;
    [_uib_summerTime addTarget:self action:@selector(toggleBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_uiv_toggleContainer addSubview: _uib_normalTime];
    [_uiv_toggleContainer addSubview: _uib_summerTime];
}

-(void)toggleBtnTapped:(id)sender
{
    UIButton *tappedBtn = sender;
    if (tappedBtn.tag == 1) {
        [_uis_zoomingMap.overView setImage:nil];
        [_uitv_textBox setText:@"Boston Info."];
    }
    else {
        [_uis_zoomingMap.overView setImage:[UIImage imageNamed:@"summerOverlay.png"]];
        [_uitv_textBox setText:@"Boston Summer Info."];
    }
    
}

-(void)initAccessBtn
{
    _uib_access = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_access.frame = CGRectMake(20, 680, 76.0, 37.0);
    [_uib_access setImage:[UIImage imageNamed:@"grfx_qanda.png"] forState:UIControlStateNormal];
    [_uib_access addTarget:self action:@selector(accessTapped) forControlEvents:UIControlEventTouchDown];
    _uib_access.backgroundColor= [UIColor redColor];
    [self.view addSubview:_uib_access];
}

-(void)initStationContentView
{
	_uiv_stationContent = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 30.0)];
    _uiv_stationContent.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    _uiv_stationContent.tag = 3000;
    
    _uiv_directionDot = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 6.0, 6.0)];
    _uiv_directionDot.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:189.0/255.0 blue:14.0/255.0 alpha:1.0];
    
    UIButton *uib_direc1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_direc2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_direc3 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_direc4 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uib_direc2.frame = CGRectMake(0, 0, container_W, 30);
    uib_direc2.backgroundColor = [UIColor clearColor];
    [uib_direc2 setTitle:@"11 New Stations" forState:UIControlStateNormal];
    uib_direc2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_direc2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_direc2.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_direc2.tag = 5002;
    
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, _uiv_stationContent.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:189.0/255.0 blue:14.0/255.0 alpha:1.0]];
    
    UIImageView *uiiv_stationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grfx_station_icon.png"]];
    uiiv_stationIcon.frame = CGRectMake(12.0, 10.0, 15.0, 15.0);
    
    //    [_uiv_directionContent addSubview:uib_direc4];
    //    [_uiv_directionContent addSubview:uib_direc3];
    [_uiv_stationContent addSubview:uib_direc2];
    [_uiv_stationContent addSubview:uib_direc1];
    [_uiv_stationContent addSubview:uiv_sideBar];
    [_uiv_stationContent addSubview:uiiv_stationIcon];
    
    [uib_direc1 addTarget:self action:@selector(stationTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_direc2 addTarget:self action:@selector(stationTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_direc3 addTarget:self action:@selector(stationTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_direc4 addTarget:self action:@selector(stationTapped:) forControlEvents:UIControlEventTouchDown];
}

-(void)initBridgeContentView {
    [_arr_bridgeBtns removeAllObjects];
    _arr_bridgeBtns = nil;
    _arr_bridgeBtns = [[NSMutableArray alloc] init];
    
    _uiv_bridgeContent = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 90)];
    _uiv_bridgeContent.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    _uiv_bridgeContent.tag = 3001;
    
    _uiv_bridgeDot = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 6.0, 6.0)];
    _uiv_bridgeDot.backgroundColor = [UIColor colorWithRed:181.0/255.0 green:38.0/255.0 blue:45.0/255.0 alpha:1.0];
    
    UIButton *uib_bridge1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_bridge2 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *uib_bridge3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    uib_bridge1.frame = CGRectMake(0, 0, container_W, 30);
    uib_bridge1.backgroundColor = [UIColor clearColor];
    [uib_bridge1 setTitle:@"8,500' Trestle Bridge" forState:UIControlStateNormal];
    uib_bridge1.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_bridge1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_bridge1.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_bridge1.tag = 6001;
    [_arr_bridgeBtns addObject: uib_bridge1];
    
    uib_bridge2.frame = CGRectMake(0, 30, container_W, 30);
    uib_bridge2.backgroundColor = [UIColor clearColor];
    [uib_bridge2 setTitle:@"5 New Bridges" forState:UIControlStateNormal];
    uib_bridge2.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_bridge2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_bridge2.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_bridge2.tag = 6002;
    [_arr_bridgeBtns addObject: uib_bridge2];
    
    uib_bridge3.frame = CGRectMake(0, 60, container_W, 30);
    uib_bridge3.backgroundColor = [UIColor clearColor];
    [uib_bridge3 setTitle:@"34 Reconstructions" forState:UIControlStateNormal];
    uib_bridge3.titleLabel.font = [UIFont fontWithName:@"DINPro-CondBlack" size:14];
    uib_bridge3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    uib_bridge3.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    uib_bridge3.tag = 6003;
    [_arr_bridgeBtns addObject: uib_bridge3];
    
    UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, _uiv_bridgeContent.frame.size.height)];
    [uiv_sideBar setBackgroundColor:[UIColor colorWithRed:181.0/255.0 green:38.0/255.0 blue:45.0/255.0 alpha:1.0]];
    
    UIImageView *uiiv_newBridgeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grfx_newBridge_icon.png"]];
    [uiiv_newBridgeIcon setContentMode: UIViewContentModeScaleAspectFit];
    uiiv_newBridgeIcon.frame = CGRectMake(12.0, 40.0, 15.0, 15.0);
    
    [_uiv_bridgeContent addSubview: uib_bridge1];
    [_uiv_bridgeContent addSubview: uib_bridge2];
    [_uiv_bridgeContent addSubview: uib_bridge3];
    [_uiv_bridgeContent addSubview: uiv_sideBar];
    [_uiv_bridgeContent addSubview: uiiv_newBridgeIcon];
    
    [uib_bridge1 addTarget:self action:@selector(bridgesTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_bridge2 addTarget:self action:@selector(bridgesTapped:) forControlEvents:UIControlEventTouchDown];
    [uib_bridge3 addTarget:self action:@selector(bridgesTapped:) forControlEvents:UIControlEventTouchDown];
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

-(void)initGalleryButtons {
    for (int i = 0; i < [_arr_galleryImageData count]; i++) {
        NSDictionary *dict_galleryItem = [[NSDictionary alloc] initWithDictionary:[_arr_galleryImageData objectAtIndex:i]];
        NSString *str_position = [[NSString alloc] initWithString:[dict_galleryItem objectForKey:@"xy"]];
        NSRange range = [str_position rangeOfString:@","];
        NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
        NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
        float hs_x = [str_x floatValue];
        float hs_y = [str_y floatValue];
        
        UIButton *uib_galleryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        uib_galleryBtn.frame = CGRectMake(hs_x, hs_y, 40.0, 40.0);
        [uib_galleryBtn setImage:[UIImage imageNamed:@"view-icon-sq.png"] forState:UIControlStateNormal];
        [uib_galleryBtn addTarget:self action:@selector(galleryBtnTapped:) forControlEvents:UIControlEventTouchDown];
        uib_galleryBtn.tag = i;
        [_arr_galleryBtnArray addObject: uib_galleryBtn];
        [_uis_zoomingMap.uiv_windowComparisonContainer addSubview: uib_galleryBtn];
    }
}
#pragma mark - Gallery Button Tapped
-(void)galleryBtnTapped:(id)sender
{
    UIButton *tappedBtn = sender;
    int index = (int)tappedBtn.tag;
    
    NSDictionary *dict_galleryItem = [[NSDictionary alloc] initWithDictionary:[_arr_galleryImageData objectAtIndex:index]];
	
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"addMapGallery" object:self userInfo:dict_galleryItem];
    
    
    //    localImages = [dict_galleryItem objectForKey:@"images"];
    //    localCaptions = [dict_galleryItem objectForKey:@"caption"];
    //
    //    NSLog(@"\n\nShould add FGallery!!");
    //    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    //    _navigationController = [[UINavigationController alloc]
    //							 initWithRootViewController:localGallery];
    //    _navigationController.view.frame = CGRectMake(0.0, 0.0, 1024, 768);
    //    [self addChildViewController: _navigationController];
    //	[_navigationController setNavigationBarHidden:YES];
    ////    _navigationController.wantsFullScreenLayout = YES;
    //
    //    [self.view addSubview:_navigationController.view];
    //    [[NSNotificationCenter defaultCenter]
    //     postNotificationName:@"hideBar"
    //     object:self];
}
#pragma mark - STATIONS Actions
-(void)stationTapped:(id)sender
{
    UIButton *tmpBtn = sender;
    //    [_uiv_directionDot removeFromSuperview];
    //    [_uiiv_overlays removeFromSuperview];
	for (UIView *tmp in _arr_hotsopts) {
        [tmp removeFromSuperview];
    }
	if (_embDirectionPath) {
		[self directionViewCleanUp];
		NSLog(@"sdssdfdsf");
	}
    
    if (tmpBtn.selected) {
        _uiv_directionDot.transform = CGAffineTransformMakeTranslation(-50, 15);
        _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"mapBG.jpg"];
        _preBtnTag = 0;
        tmpBtn.selected = NO;
        return;
    }
    
    switch (tmpBtn.tag) {
        case 5001:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(16, 15);
            [_uiv_stationContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
            break;
        }
        case 5002:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(-50, 15);
            [_uiv_stationContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
            _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"11NewStations"] ];
            [self initHotspots];
            [_uis_zoomingMap resetPinSize];
            tmpBtn.selected = YES;
            break;
        }
        case 5003:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(20, 75);
            [_uiv_stationContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
            break;
        }
        case 5004:
        {
            _uiv_directionDot.transform = CGAffineTransformMakeTranslation(20, 105);
            [_uiv_stationContent insertSubview:_uiv_directionDot aboveSubview:tmpBtn];
            break;
        }
        default:
            break;
    }
}
#pragma mark - BRIDGES Action
-(void)bridgesTapped:(id)sender {
    UIButton *tmpBtn = sender;
    //    tmpBtn.tag = tmpBtn.tag - 1000;
    for (UIView *tmp in _arr_hotsopts) {
        [tmp removeFromSuperview];
    }
    [_arr_hotspotsData removeAllObjects];
    [_arr_hotsopts removeAllObjects];
    [_arr_tapHotspots removeAllObjects];
    
    for (UIButton *tmp in _arr_bridgeBtns) {
        if (tmp.tag != tmpBtn.tag) {
            tmp.selected = NO;
        }
    }
    
    if (tmpBtn.selected) {
        _uiv_bridgeDot.transform = CGAffineTransformMakeTranslation(-50, 15);
        _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"mapBG.jpg"];
        _preBtnTag = 0;
        tmpBtn.selected = NO;
        return;

    }
    
    switch (tmpBtn.tag) {
        case 6001: {
            _uiv_bridgeDot.transform = CGAffineTransformMakeTranslation(16, 15);
            [_uiv_bridgeContent insertSubview:_uiv_bridgeDot aboveSubview:tmpBtn];
            _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"grfx_trestleOverlay.png"];
            tmpBtn.selected = YES;
            break;
        }
        case 6002: {
            _uiv_bridgeDot.transform = CGAffineTransformMakeTranslation(-50, 75);
            [_uiv_bridgeContent insertSubview:_uiv_bridgeDot aboveSubview:tmpBtn];
            _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"6NewBridges"] ];
            [self initHotspots];
            [_uis_zoomingMap resetPinSize];
            tmpBtn.selected = YES;
            break;
        }
        case 6003: {
            _uiv_bridgeDot.transform = CGAffineTransformMakeTranslation(16, 75);
            [_uiv_bridgeContent insertSubview:_uiv_bridgeDot aboveSubview:tmpBtn];
            _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"bridges"] ];
            [self initHotspots];
            [_uis_zoomingMap resetPinSize];
            tmpBtn.selected = YES;
            break;
        }
        default:
            break;
    }
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

-(void)accessTapped
{
    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"q_and_a_00.jpg", @"q_and_a_01.jpg", nil];
    localImages = imageArray;
    localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    _navigationController = [[UINavigationController alloc]
                                initWithRootViewController:localGallery];
    _navigationController.view.frame = CGRectMake(0.0, 0.0, 1024, 768);
    [self addChildViewController: _navigationController];
    [_navigationController setNavigationBarHidden:YES];
    [self.view addSubview: _navigationController.view];
}

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
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(-(1+container_W), 0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_closedMenuContainer.transform = CGAffineTransformMakeTranslation(41, 0);
        }];
    }];
}

-(void)openMenu
{
    [UIView animateWithDuration:0.33 animations:^{
        _uiv_closedMenuContainer.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.33 animations:^{
            _uiv_collapseContainer.transform = CGAffineTransformMakeTranslation(0, 0);
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

        case 6:{
            UIImage *icon5 = [UIImage imageNamed:@"grfx_culture_icon.png"];
            return icon5;
            break;
        }
        case 7:{
            UIImage *icon6 = [UIImage imageNamed:@"grfx_wetland_icon.png"];
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
            return nil;
            break;
        }
        case 1:{
//            if (isCity) {
                //                return nil;
				UIImageView *tmpImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, container_W, 194)];
                [tmpImgeView setImage:[UIImage imageNamed:@"grfx_city_transit.png"]];
                UIView *uiv_sideBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, tmpImgeView.frame.size.height)];
                [uiv_sideBar setBackgroundColor: [UIColor colorWithRed:25.0/255.0 green:179.0/255.0 blue:219.0/255.0 alpha:1.0]];
                [tmpImgeView addSubview: uiv_sideBar];
                return tmpImgeView;
//            }
            [self initStationContentView];
            return _uiv_stationContent;
            //            return nil;
            break;
        }
        case 2:{

            [self initBridgeContentView];
            return _uiv_bridgeContent;
            //            return nil;
            break;
            
        }
        case 3:{

            [self initTrackContentView];
            return _uiv_tracksContent;
            return nil;
            break;
        }
        case 4:{

            return nil;
            break;
        }
        case 5:{

            return nil;
            break;
        }
        case 6:{

            return nil;
            break;
        }
        case 7:{

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
        case 0: //ALL
        {
            return [UIColor colorWithRed:234.0/255.0 green:189.0/255.0 blue:14.0/255.0 alpha:1.0];
            break;
        }
		case 1: //Stations
        {
            return [UIColor colorWithRed:234.0/255.0 green:189.0/255.0 blue:14.0/255.0 alpha:1.0];
            break;
        }
        case 2: //BRIDGES
        {
            return [UIColor colorWithRed:181.0/255.0 green:38.0/255.0 blue:45.0/255.0 alpha:1.0];
            break;
        }
        case 3: //TRACKS
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
        case 4: //38
        {
            return [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            break;
        }
        case 5: //PARKING
        {
            return [UIColor colorWithRed:13.0/255.0 green:114.0/255.0 blue:184.0/255.0 alpha:1.0];
            break;
        }
        case 6: //Culture Resource
        {
            return [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:35.0/255.0 alpha:1.0];
            break;
        }
        case 7: //Wetland Fill
        {
            return [UIColor colorWithRed:131.0/255.0 green:183.0/255.0 blue:62.0/255.0 alpha:1.0];
            break;
        }
        case 8: //GALLERY
        {
            return [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:35.0/255.0 alpha:1.0];
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
        case 0: //ALL
        {
            return [UIColor colorWithRed:234.0/255.0 green:189.0/255.0 blue:14.0/255.0 alpha:1.0];
            break;
        }
		case 1: //Stations
        {
            return [UIColor colorWithRed:234.0/255.0 green:189.0/255.0 blue:14.0/255.0 alpha:1.0];
            break;
        }
        case 2: //BRIDGES
        {
            return [UIColor colorWithRed:181.0/255.0 green:38.0/255.0 blue:45.0/255.0 alpha:1.0];
            break;
        }
        case 3: //TRACKS
        {
            return [UIColor colorWithRed:31.0/255.0 green:162.0/255.0 blue:197.0/255.0 alpha:1.0];
            break;
        }
        case 4: //38
        {
            return [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
            break;
        }
        case 5: //PARKING
        {
            return [UIColor colorWithRed:13.0/255.0 green:114.0/255.0 blue:184.0/255.0 alpha:1.0];
            break;
        }
        case 6: //Culture Resource
        {
            return [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:35.0/255.0 alpha:1.0];
            break;
        }
        case 7: //Wetland Fill
        {
            return [UIColor colorWithRed:131.0/255.0 green:183.0/255.0 blue:62.0/255.0 alpha:1.0];
            break;
        }
        case 8: //GALLERY
        {
            return [UIColor colorWithRed:228.0/255.0 green:220.0/255.0 blue:35.0/255.0 alpha:1.0];
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

    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"mapBG.jpg"];
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
    
    for (UIView *tmp in _arr_tapHotspots) {
        [tmp removeFromSuperview];
    }
    [_arr_tapHotspots removeAllObjects];
    
    //Check if is in city?
    //Load different overlays..!
    
    NSString *test = [[NSString alloc] initWithString:[_arr_cellName objectAtIndex:index]];
    if (open == NO) {
        _uiv_closedMenuContainer.frame = CGRectMake(-41.0, (768-36)/2, 41.0, 38);
        _uiv_closeMenuSideBar.backgroundColor = [UIColor clearColor];
        [_uil_cellName removeFromSuperview];
    }
    else
    {
        
        //        if ((index == 6) || (index == 7)) {
        //            CGRect theRect = CGRectMake(0, 0, 1024, 768);
        //            [_uis_zoomingMap zoomToRect:theRect animated:YES duration:2.5];
        //        }
        
        _uiv_closedMenuContainer.frame = CGRectMake(-41.0, _uiv_collapseContainer.frame.origin.y, 41.0, _uiv_collapseContainer.frame.size.height);
        [self initCellNameLabel:test];
        _uiv_closeMenuSideBar.backgroundColor = [self colorForTitleSideBarAtIndex:index];
        _uil_cellName.textColor = [self colorForTitleSideBarAtIndex:index];
        
//        if (isCity) {
//            switch (index) {
//                    //                case 0:
//                    //                {
//                    //                    _vanness_Hotspot.hidden = NO;
//                    //                    _vanness_Parking_Hotspot.hidden = YES;
//                    //                    NSLog(@"The tapped index is %i", index);
//                    //                    break;
//                    //                }
//                case 0:
//                {
//                    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"mapBG.jpg"];
//                    NSLog(@"The tapped index is %i", index);
//                    break;
//                }
//                case 1:
//                {
//                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"universities"] ];
//                    [self initHotspots];
//                    [_uis_zoomingMap resetPinSize];
//                    NSLog(@"The tapped index is %i", index);
//                    break;
//                }
//                case 2:
//                {
//                    NSLog(@"The tapped index is %i", index);
//                    break;
//                }
//                case 3:
//                {
//                    NSLog(@"The tapped index is %i", index);
//                    break;
//                }
//                default:
//                    break;
//            }
//            
//        }
//        
//        if (!isCity) {
            switch (index) {
                case 0: // STATIONS
                {
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:1.0];
                    }
                    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"grfx_alignmentOverlay.png"];
                    //                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"11NewStations"] ];
                    //                    [self initHotspots];
                    //                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 1: // STATIONS
                {
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:1.0];
                    }
                    //                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"11NewStations"] ];
                    //                    [self initHotspots];
                    //                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 2: // BRIDGES
                {
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:1.0];
                    }
                    //                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"6NewBridges"] ];
                    //                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 3: // TRACKS
                {
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:1.0];
                    }
                    //                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"6NewBridges"] ];
                    //                    [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 4:  // 38
                {
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:1.0];
                    }
                    _uis_zoomingMap.blurView.image = [UIImage imageNamed:@"grfx_38Overlay.png"];
                    NSLog(@"The Tapped Cell is %i", index);
                    break;
                }
                case 5: // PARKING
                {
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"retail"] ];
					// [self initHotspots];
                    [_uis_zoomingMap resetPinSize];
                    [_uis_zoomingMap resetPinSize];
                    CGRect theRect = CGRectMake(213, 452, 421, 316);
                    NSValue * value = [NSValue valueWithCGRect:theRect];
                    
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:2.5];
                        
                        [self performSelector:@selector(zoomInRect:) withObject:value afterDelay:2.6];
                    }
                    else {
                        [self performSelector:@selector(zoomInRect:) withObject:value afterDelay:0.0];
                    }
                    
                    NSLog(@"The tapped index is %i", index);
                    break;
                }
                case 6:
                {
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"culture_rescource"] ];
                    [self initHotspots];
                    
                    [_uis_zoomingMap resetPinSize];
                    CGRect theRect = CGRectMake(79, 229, 640, 480);
                    NSValue * value = [NSValue valueWithCGRect:theRect];
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:2.5];
                        [self performSelector:@selector(zoomInRect:) withObject:value afterDelay:2.6];
                    }
                    else {
                        [self performSelector:@selector(zoomInRect:) withObject:value afterDelay:0.0];
                    }
                    
                    break;
                }
                case 7:
                {
                    _arr_hotspotsData = [NSMutableArray arrayWithArray:[_dict_hotspots objectForKey:@"wetland_fill"] ];
                    [self initHotspots];
                    
                    [_uis_zoomingMap resetPinSize];
                    CGRect theRect = CGRectMake(281, 307, 287, 215);
                    NSValue * value = [NSValue valueWithCGRect:theRect];
                    
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:2.5];
                        
                        [self performSelector:@selector(zoomInRect:) withObject:value afterDelay:2.6];
                    }
                    else {
                        [self performSelector:@selector(zoomInRect:) withObject:value afterDelay:0.0];
                    }
                    
                    
                    break;
                    
                }
                case 8:  // GALLERY
                {
                    if (_uis_zoomingMap.scrollView.zoomScale > 1.0) {
                        [_uis_zoomingMap zoomToRect:self.view.bounds animated:YES duration:1.0];
                    }
                    NSLog(@"The Tapped Cell is %i", index);
                    [self initGalleryButtons];
                    
                    break;
                }
                    
                default:
                    break;
            }
//        }
    }
    
//    [self removeAllHelpViews];
}

-(void)zoomInRect:(NSValue *)rect {
    CGRect theRect = [rect CGRectValue];
    [_uis_zoomingMap zoomToRect:theRect animated:YES duration:2.5];
    [_uis_zoomingMap resetPinSize];
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
        //            _bldHotspots.labelAlignment = CaptionAlignmentLeft;
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
