//
//  xhanchorPointHotspots.h
//  xhAnchorPointHotspots
//
//  Created by Xiaohe Hu on 3/5/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class xhanchorPointHotspots;

@protocol xhanchorPointHotspotsDelegate
typedef enum {
    AnchorPositionTop,          //0
    
    AnchorPositionTopLeft,      //1
    
    AnchorPositionLeft,         //2
    
    AnchorPositionBottomLeft,   //3
    
    AnchorPositionBottom,       //4
    
    AnchorPositionBottomRight,  //5
    
    AnchorPositionRight,        //6
    
    AnchorPositionTopRight,     //7
    
    AnchorPositionCenter        //8
    
} anchorPointPosition;

@end

@interface xhanchorPointHotspots : UIView
{
    UIImageView             *uiiv_bgImg;
}
@property (nonatomic, assign) id                    delegate;
@property (nonatomic, strong) NSString              *str_hotspotImage;
@property (nonatomic, assign) anchorPointPosition   anchorPosition;
@end
