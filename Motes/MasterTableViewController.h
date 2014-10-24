//
//  MasterTableViewController.h
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCollection.h"

@interface MasterTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong,nonatomic) NoteCollection *noteCollection;





@end
