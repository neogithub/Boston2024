//
//  mapViewController.h
//  boston2024
//
//  Created by Xiaohe Hu on 9/2/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"
#import "contentTableViewController.h"
#import <MapKit/MapKit.h>
#import "FGalleryViewController.h"
@interface mapViewController : UIViewController <CollapseClickDelegate, UITextFieldDelegate, MKMapViewDelegate,  UIGestureRecognizerDelegate, FGalleryViewControllerDelegate>
{
    CollapseClick   *theCollapseClick;
    BOOL            isCity;
    
    // fgallery
	FGalleryViewController	*localGallery;
	NSArray					*localCaptions;
    NSArray					*localImages;
}
@end
