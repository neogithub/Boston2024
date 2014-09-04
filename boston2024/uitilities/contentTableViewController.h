//
//  contentTableViewController.h
//  neo1325Boylston
//
//  Created by Xiaohe Hu on 1/13/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contentTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *arr_tableData;
@property (nonatomic, strong) NSString *str_plistName;
@end
