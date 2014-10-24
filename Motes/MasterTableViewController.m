//
//  MasterTableViewController.m
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import "MasterTableViewController.h"
#import "NoteMasterTableViewCell.h"
#import "DetailViewController.h"
@interface MasterTableViewController ()

@end

Note *_activeNote;
BOOL _createNewNote;
@implementation MasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    _noteCollection = [NoteCollection sharedNotes];
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    _createNewNote = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _noteCollection.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteMasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(cell==nil){
        cell = [[NoteMasterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    int row = (int)indexPath.row;
    Note *note = [_noteCollection noteAtIndex:row];
    
    // Configure the cell...
    cell.noteTitleLabel.text = note.title;
    cell.noteBodyDescriptionLabel.text = note.body;
    cell.noteDateLabel.text = [MasterTableViewController stringDateFromDate:note.date];
    cell.noteTimeLabel.text = [MasterTableViewController stringTimeFromDate:note.date];
    if(note.image == nil){
        cell.noteImageView.image = [UIImage imageNamed:@"EmptyImagePlacerHolder.png"];
        cell.paperClipImageView.hidden = YES;
    }
    else{
        cell.noteImageView.image = note.image;
        cell.paperClipImageView.hidden = NO;
    }
    
    return cell;
}
+(NSString*)stringDateFromDate:(NSDate*)date{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:date];
    
}
+(NSString*)stringTimeFromDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:date];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _activeNote = [_noteCollection noteAtIndex:(int)indexPath.row];
    _createNewNote = NO;
    [self performSegueWithIdentifier:@"ToDetailVC" sender:self];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Note *note = [_noteCollection noteAtIndex:(int)indexPath.row];
        [_noteCollection removeNote:note];
   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [_noteCollection removeNote:_activeNote];
     
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ToDetailVC"]) {
        DetailViewController *dvc = segue.destinationViewController;
        if(_createNewNote)
            dvc.activeNote = nil;
        else
            dvc.activeNote = _activeNote;
    }
}



@end
