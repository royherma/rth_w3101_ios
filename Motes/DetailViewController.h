//
//  DetailViewController.h
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCollection.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>


@interface DetailViewController : UIViewController <MFMailComposeViewControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic) Note *activeNote;

@property IBOutlet UITextView *bodyTextView;
@property IBOutlet UITextField *titleTextField;
@property IBOutlet UIBarButtonItem *playAudioButton;
@property IBOutlet UIButton *hideKeyboardButton;

-(IBAction)hideKeyboard:(UIButton*)button;
-(IBAction)openActionSheet:(id)sender;
-(IBAction)stopOrStartRecording:(id)sender;
- (IBAction)playTapped:(id)sender;
@end
