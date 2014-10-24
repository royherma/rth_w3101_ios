//
//  DetailViewController.m
//  Motes
//
//  Created by Roy Hermann on 10/8/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageDisplayViewController.h"


@interface DetailViewController ()

@property BOOL newNote;
@property BOOL isRecording;
@property MBProgressHUD *hud;
@property AVAudioRecorder *recorder;
@property AVAudioPlayer *player;

-(void)keyboardWasShown;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //check if new note
    if(_activeNote == nil){
        _activeNote = [[Note alloc]initWithTitle:@"" andBody:@""];
        _newNote = YES;
    }
    else{
        _titleTextField.text = _activeNote.title;
        _bodyTextView.text = _activeNote.body;
    }
    //set recording bool
    _isRecording = NO;
    //show play button or not, according to if a audio file exists at path for note
    [_playAudioButton setEnabled:[self audioFileExists]];
    
    //init HUD
    _hud = [[MBProgressHUD alloc]initWithView:self.view];

    //init picker
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{

    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    [textView resignFirstResponder];
    return YES;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (_titleTextField.isFirstResponder)
        [_titleTextField resignFirstResponder];
    return YES;
}
#pragma mark - IBActions
-(IBAction)hideKeyboard:(UIButton*)button{
    if(_bodyTextView.isFirstResponder)
        [_bodyTextView resignFirstResponder];
    else
        [_titleTextField resignFirstResponder];
    
    //hide button keyboard now that keyboard is hidden
    [UIView animateWithDuration:0.5 animations:^{
        [_hideKeyboardButton setAlpha:0.0f];
    } completion:^(BOOL finished) {
        if(finished)
            [_hideKeyboardButton setHidden:YES];
    }];
    
}
-(IBAction)openActionSheet:(id)sender{
    UIActionSheet *as;
    if([self audioFileExists]){
        as = [[UIActionSheet alloc]initWithTitle:@"Would you like to..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Save" otherButtonTitles:@"Set Photo",@"Display Photo",@"Email Note",@"Delete Audio", nil];
    }
    else{
        as = [[UIActionSheet alloc]initWithTitle:@"Would you like to..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Save" otherButtonTitles:@"Set Photo",@"Display Photo",@"Email Note", nil];
    }
    [as showInView:self.view];
}
-(IBAction)stopOrStartRecording:(id)sender{

    
    NSError *error;
    UIBarButtonItem *stopAndRecordButton = sender;
    // If not already recording, start recording now
    if(_isRecording == NO){
        //disable play button
        [_playAudioButton setEnabled:NO];
        
        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [session setActive:YES error:&error];
        
        
        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        _recorder = [[AVAudioRecorder alloc] initWithURL:_activeNote.audioURL settings:recordSetting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        _isRecording = YES;
        [stopAndRecordButton setImage:[UIImage imageNamed:@"StopButton.png"]];
    }
    //Stop recording
    else {
        [_recorder stop];
        [stopAndRecordButton setImage:[UIImage imageNamed:@"RecordButton.png"]];
        _isRecording = NO;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:&error];
        
    }
    
}
- (IBAction)playTapped:(id)sender {
    if (!_recorder.recording && !_player.isPlaying){
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_activeNote.audioURL error:nil];
        [_player setDelegate:self];
        [_player play];
        [_playAudioButton setImage:[UIImage imageNamed:@"PauseButton.png"]];
    }
    else if (_player.isPlaying){
        [_player stop];
        [_playAudioButton setImage:[UIImage imageNamed:@"PlayButton.png"]];
    }
}

#pragma mark - AVAudioPlayer and Recorder Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag{
    NSLog(@"audio player did finish playing");
    [_playAudioButton setImage:[UIImage imageNamed:@"PlayButton.png"]];
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag{
    if(flag)
        [_playAudioButton setEnabled:YES];
    else{
        NSLog(@"error recording");
    }
    
}
#pragma mark - Action Sheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //save note
            //display hud and save note
            _hud.labelText = @"Saving Note...";
            [self.view addSubview:_hud];
            [_hud showAnimated:YES whileExecutingBlock:^{
                [self saveNote];
            } completionBlock:^{
                [_hud removeFromSuperview];
            }];
            break;
        }

        case 1:{
            //Set Photo
            //display hud and save note
            [self showPhotoLibrary];
            break;
        }
        case 2:{
            //Display photo image view
            [self displayPhoto];
            break;
        }
        case 3:{
            //Email note
            _hud.labelText = @"Loading Composer...";
            [self.view addSubview:_hud];
            [_hud showAnimated:YES whileExecutingBlock:^{
                [self showEmail];
            } completionBlock:^{
                [_hud removeFromSuperview];
            }];
            break;
        }
        case 4:{
            if([self audioFileExists]){
            //'Delete' audio file
                NSFileManager *manager = [NSFileManager defaultManager];
                NSError *error;
                [manager removeItemAtURL:_activeNote.audioURL error:&error];
                if(error){
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error deleting the audio file" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
                else{
                    [_playAudioButton setEnabled:NO];
                }
            }
            else{
                //cancel - do nothing
            }
        }
            break;
        case 5:
            //cancel - do nothing
        default:
            break;
    }
}
#pragma mark - Action Sheet Sub methods
-(void)saveNote{
    [self updateNoteValues];
    //if its new, add it to collection. Otherwise, just modify
    if(_newNote){
        [[NoteCollection sharedNotes]addNote:_activeNote];
    }
    _newNote = NO;

    BOOL success = [NSKeyedArchiver archiveRootObject:[[NoteCollection sharedNotes]collection] toFile:[NoteCollection pathForArchive]];
    NSLog(@"%@", success ? @"SUCESS" : @"FAILURE");
    
}
-(void)updateNoteValues{
    [_activeNote setTitle:_titleTextField.text];
    [_activeNote setBody:_bodyTextView.text];
    [_activeNote setDate:[NSDate date]];
}
-(void)showPhotoLibrary{
    // Create image picker controller
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Delegate is self
    picker.delegate = self;
    
    // Allow editing of image ?
    
    // Show image picker
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"presented image picker vc");
    }];
    
    


}
- (void)showEmail{
    // Email Subject
    NSString *emailTitle = _titleTextField.text;
    // Email Content
    NSString *messageBody = _bodyTextView.text;
    // To address
    
    //make sure the device can even send emails
    
    MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc]init];
    if([MFMailComposeViewController canSendMail]){
    mcvc.mailComposeDelegate = self;
        
    //set email title
    [mcvc setSubject:emailTitle];
    //set email message body
    [mcvc setMessageBody:messageBody isHTML:NO];
        
    //add note image as attachement (if exists)
    if(_activeNote.image){
        NSData *imageData = [NSData dataWithData:(UIImageJPEGRepresentation(_activeNote.image,1.0))];
        [mcvc addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"noteImage.jpeg"];
        }
    //add note audio (if exists)
    if([self audioFileExists]){
        NSError *error;
        NSData* audioData = [NSData dataWithContentsOfURL:_activeNote.audioURL options:0 error:&error];
        if(audioData.length && !error)
            [mcvc addAttachmentData:audioData mimeType:@"audio/mp4" fileName:@"noteRecording.m4a"];
        }
    // Present mail view controller on screen
    [self presentViewController:mcvc animated:NO completion:NULL];
    }
    else{
        //if it can't send emails, display error and try to re init the mail composer
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You are either using simulator, or you are having issues with your email. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    
}
-(void)displayPhoto{
    if(_activeNote.image == nil){
        NSLog(@"no note to display");
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"No Photo" message:@"You must set your note's photo before you can display it" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else{
        [self performSegueWithIdentifier:@"ToImageVC" sender:self];
    }
}
#pragma mark - Mail Composer Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _activeNote.image = myImage;
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"image saved");
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"picker dismissed");
    }];
}
#pragma mark - Misc methods
-(void)backButtonPressed{

    //display hud and save note
    _hud.labelText = @"Saving Note...";
    [self.view addSubview:_hud];
    [_hud showAnimated:YES whileExecutingBlock:^{
        [self saveNote];
    } completionBlock:^{
        [_hud removeFromSuperview];
        int vcCount = (int)self.navigationController.viewControllers.count;
        UITableViewController *parentVC = self.navigationController.viewControllers[vcCount-2];
        [parentVC.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    

}

-(BOOL)audioFileExists{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    return ([fileManager fileExistsAtPath:_activeNote.audioURL.path]) ? YES : NO;
}
-(void)keyboardWasShown{
    if(_bodyTextView.isFirstResponder){
    [_hideKeyboardButton setAlpha:0.0f];
    [_hideKeyboardButton setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [_hideKeyboardButton setAlpha:1.0f];
    }];
    }

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ToImageVC"]){
        ImageDisplayViewController *dvc = segue.destinationViewController;
        dvc.image = _activeNote.image;
    }
        
}


@end
