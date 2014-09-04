//
//  contentTableCell.h
//  neo1325Boylston
//
//  Created by Xiaohe Hu on 1/13/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contentTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *uil_cellName;
@property (strong, nonatomic) IBOutlet UILabel *uil_cellNum;
@property (strong, nonatomic) IBOutlet UIImageView *uiiv_cellSideBar;

@end
