//
//  contentTableCell.m
//  neo1325Boylston
//
//  Created by Xiaohe Hu on 1/13/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "contentTableCell.h"

@implementation contentTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.highlighted = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:55.0/255.0 blue:50.0/255.0 alpha:0.9];
    }
    else{
        self.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1.0];
    }
}

@end
