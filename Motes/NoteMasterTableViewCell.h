//
//  NoteMasterTableViewCell.h
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteMasterTableViewCell : UITableViewCell

@property IBOutlet UIImageView *noteImageView;
@property IBOutlet UIImageView *paperClipImageView;
@property IBOutlet UILabel *noteTitleLabel;
@property IBOutlet UILabel *noteBodyDescriptionLabel;
@property IBOutlet UILabel *noteDateLabel;
@property IBOutlet UILabel *noteTimeLabel;

@end
