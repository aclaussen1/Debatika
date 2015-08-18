//
//  LeaveACommentViewController.m
//  Debatika
//
//  Created by Alexander Claussen on 6/20/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//




#import "LeaveACommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CNPPopupController.h"

@interface LeaveACommentViewController () {
    //this refers to the text field
    BOOL hasBeenClearedBefore;
    BOOL viewHasAppearedBefore;
    //to protect from double taps (which cause an error)
    BOOL hasNotYetBeenSuccessfullySubmittedButWillBeSoon;
}

@property (nonatomic, strong) CNPPopupController *popupController;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *titleOfComment;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *bodyOfComment;
@property (weak, nonatomic) PFUser *currentUser;

@end

@implementation LeaveACommentViewController

/*
 *If you later want to add stuff to this in interface builder, go into the lowest view in the heirarchy, and under its contraints, change the height (currently it is around 575).
 *
 */



-(void)dismissKeyboard {
    [_bodyOfComment resignFirstResponder];
    [_titleOfComment resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tap gesture recognizers recognizes a tap and will call dismiss keyboard (declared in leaveacommentviewcomment.m) which wil dismiss any keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    _currentUser = [PFUser currentUser];
    
    //initializing variables
    hasNotYetBeenSuccessfullySubmittedButWillBeSoon = false;
    viewHasAppearedBefore = false;
    //hasBeenClearedBefore refers to description text view
    hasBeenClearedBefore = false;
    
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_submitButton setTitle:@"Submit Comment" forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    _submitButton.layer.cornerRadius = 4;
    
    
    _titleOfComment.delegate = self;
    _bodyOfComment.delegate = self;
    
    _titleOfComment.text = @"";
    _bodyOfComment.text = @"Comment on this debate. Be sure to back up your opinion, preferably with examples and fact! Always be respectful, even with people you do not agree with.";
    
    [[_bodyOfComment layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_bodyOfComment layer] setBorderWidth:.2];
    [[_bodyOfComment layer] setCornerRadius:15];
    
    _profileImage.image = [UIImage imageNamed:@"Lincoln"];
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width / 2 ;
    _profileImage.clipsToBounds = YES;
    PFFile *file = [_currentUser objectForKey:@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            _profileImage.image = image;
            
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    NSArray *titleWords = [_titleOfComment.text componentsSeparatedByString:@" "];
    NSArray *descriptionWords = [_bodyOfComment.text componentsSeparatedByString:@" "];
    if (_currentUser == nil) {
        NSLog(@"User is not logged in. Creating popup prompting for login");
        [self showGuestNeedsToLoginPopupWithStyle:CNPPopupStyleCentered];
    } else if (_currentUser[@"profilePicture"] == nil) {
        NSLog(@"User does not have a profile picture. Creating popup prompting for one.");
        [self showProfilePicturePopupWithStyle:CNPPopupStyleCentered];
    }  else if ( viewHasAppearedBefore && ( [_titleOfComment.text length] <= 15 || [titleWords count] < 4 ||  [_titleOfComment.text length] > 76 || [_bodyOfComment.text length] < 40 || [descriptionWords count] < 20 || [_bodyOfComment.text isEqualToString:@"Comment on this debate. Be sure to back up your opinion, preferably with examples and fact! Always be respectful, even with people you do not agree with."] ) ) { //less than 10 charachters
        
        [self showNeedsFixingPopupWithStyle:CNPPopupStyleCentered];
        
    }
    viewHasAppearedBefore = true;
}

//popup for guests that need to login
- (void)showGuestNeedsToLoginPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"You are using Debatika as a guest!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Before you can participate in a debate, you must login." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    //close the popup
    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button1 setTitle:@"Close Me" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:.46 alpha:1.0];
    button1.layer.cornerRadius = 4;
    button1.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, button1,]];
    
    
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

//popup for users who need shorter or longer or curses
- (void)showNeedsFixingPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    //to remove keyboard
    [_bodyOfComment resignFirstResponder];
    [_titleOfComment resignFirstResponder];
    
    NSString *whatNeedsFixing;
    
    NSArray *titleWords = [_titleOfComment.text componentsSeparatedByString:@" "];
    NSArray *descriptionWords = [_bodyOfComment.text componentsSeparatedByString:@" "];
    
    
    if ([_titleOfComment.text length] <= 15 || [titleWords count] < 4) {
        whatNeedsFixing = @"The title of your comment needs at least fifteen charachters and at least four words.";
    } else if ( [_titleOfComment.text length] > 76 ) {
        whatNeedsFixing = @"The title of your comment is too long (max 76 charachters).";
    } else if ([_bodyOfComment.text length] < 40 || [descriptionWords count] < 20 ) {
        whatNeedsFixing = @"Your full comment needs at least 40 charachters and twenty words.";
    } else if ( [_bodyOfComment.text isEqualToString:@"Comment on this debate. Be sure to back up your opinion, preferably with examples and fact! Always be respectful, even with people you do not agree with."] ) {
        whatNeedsFixing = @"You need to change the description of your debate.";
    } else {
        //this code should never execute
        whatNeedsFixing = @"Something went wrong. This is an error. Sorry. Go play Angry Birds. Please report to Debatika police (Yes, really).";
    }
    
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"You messed up somewhere!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:whatNeedsFixing attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    //close the popup
    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button1 setTitle:@"Close Me" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:.46 alpha:1.0];
    button1.layer.cornerRadius = 4;
    button1.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, button1,]];
    
    
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}



//popup prompting user to select a profile picture
- (void)showProfilePicturePopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Set Profile Picture" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Before you can participate in a debate, you must set a profile picture. You can use your iOS device's camera or select a photo from your phone." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    //from camera button
    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button1 setTitle:@"Photo from Camera" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button1.layer.cornerRadius = 4;
    button1.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        [self takePhoto];
        
    };
    
    //from existing Photos button
    CNPPopupButton *button2= [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button2 setTitle:@"Existing Photos" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    button2.layer.cornerRadius = 4;
    button2.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        [self selectPhoto];
        
    };
    
    //close the popup
    CNPPopupButton *button3 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button3 setTitle:@"Close Me" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:.46 alpha:1.0];
    button3.layer.cornerRadius = 4;
    button3.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, button1, button2, button3]];
    
    
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

//popup to disply when debate is successfully submited
- (void)showCommentSubmissionSuccessfulPopupWithStyle:(CNPPopupStyle)popupStyle {
    if (!hasNotYetBeenSuccessfullySubmittedButWillBeSoon) {
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Congrats!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
        NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Your comment has been submitted." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
        
        
        
        
        //close the popup
        CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button1 setTitle:@"Close Me" forState:UIControlStateNormal];
        button1.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:.46 alpha:1.0];
        button1.layer.cornerRadius = 4;
        button1.selectionHandler = ^(CNPPopupButton *button){
            [self.popupController dismissPopupControllerAnimated:YES];
            NSLog(@"Block for button: %@", button.titleLabel.text);
        };
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title;
        
        UILabel *lineOneLabel = [[UILabel alloc] init];
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        
        
        self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, button1]];
        
        
        self.popupController.theme = [CNPPopupTheme defaultTheme];
        self.popupController.theme.popupStyle = popupStyle;
        self.popupController.delegate = self;
        
        //the following three lines of code is to protect against double tapping on the sumbit button, which will cause an error had this code block not been here
        
        
        [self.popupController presentPopupControllerAnimated:YES];
    }
    hasNotYetBeenSuccessfullySubmittedButWillBeSoon = true;
}


- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (IBAction)submitComment:(id)sender {
    NSArray *titleWords = [_titleOfComment.text componentsSeparatedByString:@" "];
    NSArray *descriptionWords = [_bodyOfComment.text componentsSeparatedByString:@" "];
    if (_currentUser == nil) { //user not logged in
        NSLog(@"User is not logged in. Creating popup prompting for login");
        [self showGuestNeedsToLoginPopupWithStyle:CNPPopupStyleCentered];
    } else if (_currentUser[@"profilePicture"] == nil) { // no profile picture
        NSLog(@"User does not have a profile picture. Creating popup prompting for one.");
        [self showProfilePicturePopupWithStyle:CNPPopupStyleCentered];
    }
    
    else if ( [_titleOfComment.text length] <= 15 || [titleWords count] < 4 ||  [_titleOfComment.text length] > 76 || [_bodyOfComment.text length] < 40 || [descriptionWords count] < 20 || [_bodyOfComment.text isEqualToString:@"Comment on this debate. Be sure to back up your opinion, preferably with examples and fact! Always be respectful, even with people you do not agree with."]) { //less than 10 charachters
        
        [self showNeedsFixingPopupWithStyle:CNPPopupStyleCentered];
        
        //user did not use correct formatting for title and comment body
        
    } else {
        //the following if statement is to protect against double tapping on the submit button, which will cause the app to crash once the user presses the close button
        if (!hasNotYetBeenSuccessfullySubmittedButWillBeSoon) {
            //user has profile picture and is logged in
            
            PFObject *myComment = [PFObject objectWithClassName:@"Responses"];
            myComment[@"responseText"] = _bodyOfComment.text;
            myComment[@"title"] = _titleOfComment.text;
            
            
            // Add a relation between the Post and Comment
            myComment[@"parent"] = _objectID;
            
            // This will save both myPost and myComment
            [myComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Upload of comment successful");
                    [self showCommentSubmissionSuccessfulPopupWithStyle:CNPPopupStyleCentered];
                    [self performSegueWithIdentifier:@"toViewDebate" sender:self];
                } else {
                    NSLog(@"Upload of comment not successful");
                    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Debatika is having problems. Send us an email with this error message and we'll send you a gift. We'll be sure to fire somebody. [error code: 01]" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
                    [alertview show];
                }
            }];
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *data=UIImagePNGRepresentation(chosenImage);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:data];
    //[imageFile saveInBackground];
    
    
    [self.currentUser setObject:imageFile forKey:@"profilePicture"];
    [self.currentUser saveInBackground];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    [self viewDidLoad];
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}




#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_titleOfComment resignFirstResponder];
    return NO;
}

#pragma mark - UITextViewDelegate method
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        
        return FALSE;
    }
    
    return TRUE;
}

- (void) textViewDidBeginEditing:(UITextView *) textView {
    if (!hasBeenClearedBefore) {
        [textView setText:@""];
        hasBeenClearedBefore = TRUE;
    }
}

@end
