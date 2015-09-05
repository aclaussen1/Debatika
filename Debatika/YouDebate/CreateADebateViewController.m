//
//  CreateADeabteViewController.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/18/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "CreateADebateViewController.h"
#import "CNPPopupController.h"
#import "MainViewController.h"
#import "Parse/Parse.h"
#import "ParseUI/PFImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "FeaturedTableViewController.h"

@interface CreateADebateViewController  () {
    BOOL hasBeenClearedBefore;
    //to protect against user double clicking on sumbit demate (when leading to a sucessful debate), which before protecting would cause app to crash
    BOOL hasBeenSuccessfullySubmittedBefore;
}



@property (weak, nonatomic) IBOutlet UIPickerView *Categories;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfCreator;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSString *currentUserObjectId;
@property (nonatomic, strong) NSArray *categoriesToFillPickerView;
@property (strong, nonatomic) IBOutlet UIView *viewThatFillsScrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation CreateADebateViewController

-(void)dismissKeyboard {
    [_descriptionTextView resignFirstResponder];
    [_titleTextField resignFirstResponder];
}



- (void)viewDidLoad {
    _currentUser = [PFUser currentUser];
    
    //tap gesture recognizers recognizes a tap and will call dismiss keyboard (declared in leaveacommentviewcomment.m) which wil dismiss any keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //initializing variables boolan
    hasBeenSuccessfullySubmittedBefore = false;
    hasBeenClearedBefore = false;
    _currentUserObjectId = [_currentUser objectId];
    
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_submitButton setTitle:@"Submit Debate" forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    _submitButton.layer.cornerRadius = 4;

    
    _titleTextField.delegate = self;
    _descriptionTextView.delegate = self;
    
    _titleTextField.text = @"";
    _descriptionTextView.text = @"Give a description for your debate. Suggestions: What is the background of this debate? What recent events have made this an important issue? Why should people care? This is not the place to include your own opinion.";
    
    [[_descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_descriptionTextView layer] setBorderWidth:.25];
    [[_descriptionTextView layer] setCornerRadius:15];
    
    
    
    
    
    _imageOfCreator.image = [UIImage imageNamed:@"Lincoln"];
    _imageOfCreator.layer.cornerRadius = _imageOfCreator.frame.size.width / 2 ;
    _imageOfCreator.clipsToBounds = YES;
    PFFile *file = [_currentUser objectForKey:@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            _imageOfCreator.image = image;
            
        }
    }];
    
    
     
   _categoriesToFillPickerView = @[@"Politics", @"Culture", @"Sports", @"Philosophy", @"Technology", @"Local Issues", @"Science", @"Other"];
    [[_Categories layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_Categories layer] setBorderWidth:.25];
    [[_Categories layer] setCornerRadius:15];
     
    self.Categories.dataSource = self;
    self.Categories.delegate = self;
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    if (_currentUser == nil) {
        NSLog(@"User is not logged in. Creating popup prompting for login");
        [self showGuestNeedsToLoginPopupWithStyle:CNPPopupStyleCentered];
    } else if (_currentUser[@"profilePicture"] == nil) {
        NSLog(@"User does not have a profile picture. Creating popup prompting for one.");
        [self showProfilePicturePopupWithStyle:CNPPopupStyleCentered];
    }
}

//submit debate buttpn
- (IBAction)submitDebate:(id)sender {
    //to remove keyboard
    [_titleTextField resignFirstResponder];
    [_descriptionTextView resignFirstResponder];
    
    NSArray *titleWords = [_titleTextField.text componentsSeparatedByString:@" "];
    NSArray *descriptionWords = [_descriptionTextView.text componentsSeparatedByString:@" "];
    
    //scenarios in which a user should not be allowed to submit debate
    if (_currentUser == nil) {
        NSLog(@"User is not logged in. Creating popup prompting for login");
        [self showGuestNeedsToLoginPopupWithStyle:CNPPopupStyleCentered];
    } else if (_currentUser[@"profilePicture"] == nil) {
        NSLog(@"User does not have a profile picture. Creating popup prompting for one.");
        [self showProfilePicturePopupWithStyle:CNPPopupStyleCentered];
    } else if ( [_titleTextField.text length] <= 15 || [titleWords count] < 4 ||  [_titleTextField.text length] > 76 || [_descriptionTextView.text length] < 40 || [descriptionWords count] < 20 || [_descriptionTextView.text isEqualToString:@"Give a description for your debate. Suggestions: What is the background of this debate? What recent events have made this an important issue? Why should people care? This is not the place to include your own opinion."]  ) { //less than 10 charachters
        
        [self showNeedsFixingPopupWithStyle:CNPPopupStyleCentered];
        
    }
    else { //user has profile picture and is logged in, will submit the debate
        
        
        //the following if statement is to protect against user double clicking on submitdebate, which would cause app to crash
        if (!hasBeenSuccessfullySubmittedBefore) {
            
            PFObject *debateToSubmit = [PFObject objectWithClassName:@"Debate"];
            
            debateToSubmit[@"Title"] = self.titleTextField.text;
            if (self.titleTextField.text) NSLog(@"%@",self.titleTextField.text);
            
            
            debateToSubmit[@"description"] = self.descriptionTextView.text;
            if (self.descriptionTextView.text) NSLog(@"%@",self.descriptionTextView.text);
            
            
            debateToSubmit[@"Category"] = [_categoriesToFillPickerView objectAtIndex:[self.Categories selectedRowInComponent:0]] ;
            NSLog(@"%@", [_categoriesToFillPickerView objectAtIndex:[self.Categories selectedRowInComponent:0]]);
            
            debateToSubmit[@"votes"] = @0.0;
            debateToSubmit[@"numberOfComments"] = @0.0;
            
            debateToSubmit[@"createdBy"] = _currentUserObjectId;
            NSLog(@"%@", _currentUserObjectId);
            
            hasBeenSuccessfullySubmittedBefore = true;
            
            [debateToSubmit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self showDebateSuccessfulSubmittedPopupWithStyle:CNPPopupStyleCentered];
                    [self viewDidLoad];
                    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
                    
                    
                    
                } else {
                    // There was a problem, check error.description
                }
            }];
        }
    }
}


//popup for guests who need to login
- (void)showGuestNeedsToLoginPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"You are using Debatika as a guest!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Before you can create a debate, you must login." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
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
        NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Before you can create a debate, you must set a profile picture. You can use your iOS device's camera or select a photo from your phone." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
        
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

//popup for users who need shorter or longer or curses
- (void)showNeedsFixingPopupWithStyle:(CNPPopupStyle)popupStyle {
    NSString *whatNeedsFixing;

    NSArray *titleWords = [_titleTextField.text componentsSeparatedByString:@" "];
    NSArray *descriptionWords = [_descriptionTextView.text componentsSeparatedByString:@" "];

    
    if ([_titleTextField.text length] <= 15 || [titleWords count] < 4) {
        whatNeedsFixing = @"The title of your debate needs at least fifteen charachters and at least four words.";
    } else if ( [_titleTextField.text length] > 76 ) {
         whatNeedsFixing = @"The title of your debate is too long (max 76 charachters).";
    } else if ([_descriptionTextView.text length] < 40 || [descriptionWords count] < 20 ) {
        whatNeedsFixing = @"The description of your debate needs at least 40 charachters and twenty words.";
    } else if ( [_descriptionTextView.text isEqualToString:@"Give a description for your debate. Suggestions: What is the background of this debate? What recent events have made this an important issue? Why should people care? This is not the place to include your own opinion."] ) {
        whatNeedsFixing = @"You need to change the description of your debate.";
    } else {
        //this code should never execute
        whatNeedsFixing = @"Something went wrong. This is an error. Sorry. Go play Angry Birds. Please report to Debatika police (Yes, really).";
    }
    

    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"This debate is not acceptable as is!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
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



//popup to disply when debate is successfully submited
- (void)showDebateSuccessfulSubmittedPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Congrats!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Your debate has been submitted." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
   
    
    
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
    
    
    
    [self.popupController presentPopupControllerAnimated:YES];
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
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController setTitle:@"Create A Debate"];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MainViewController *destinationViewController = [segue destinationViewController];
    [destinationViewController setSendingController:@"CreateADebateController"];
    
}


#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
    
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

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



#pragma mark - UIPickerView delegate methods

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _categoriesToFillPickerView.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _categoriesToFillPickerView[row];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_titleTextField resignFirstResponder];
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
    


