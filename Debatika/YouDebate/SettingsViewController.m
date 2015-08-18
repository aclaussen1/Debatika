//
//  SettingsViewController.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/12/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "CNPPopupController.h"

@interface SettingsViewController () {
    PFUser *currentUser;
}

@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation SettingsViewController



- (void)viewDidLoad {
    
    currentUser = [PFUser currentUser];
    
    UIBarButtonItem *returnToHomeButton = [[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(unwindToHome:)];
    self.navigationItem.leftBarButtonItem = returnToHomeButton;
    [super viewDidLoad];
    
    
}



- (IBAction)unwindToHome:(id)sender {
    [self performSegueWithIdentifier:@"returnHome" sender:self];
}

 
- (IBAction)setProfilePicture:(id)sender {
    [self showPopupWithStyle:CNPPopupStyleCentered];
    
}

- (IBAction)linkExistingAccountToFacebook:(id)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    if (![PFFacebookUtils isLinkedWithUser:currentUser]) {
        NSLog(@" PFFacebookUtils isLinkedWithUser:currentUser] is false");
        [PFFacebookUtils linkUserInBackground:currentUser withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Woohoo, user is linked with Facebook!");
                UIAlertView *confirmedAlertView = [[UIAlertView alloc] initWithTitle:@"Linked to Facebook" message:@"Your existing YouDebate account is now linked to FaceBook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [confirmedAlertView show];
            }
            else if (error) {
                NSString *message = @"Something went wrong!";
                if (error.code == 208) {
                    message = @"Another user is already linked to this facebook id.";
                }
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
    }
    else {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Already Linked to Facebook" message:@"Your YouDebate account is already linked to FaceBook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
    }
    
    
    
    
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Set Profile Picture" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"You can use your iOS device's camera or select a photo from your phone." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [imageFile saveInBackground];
    
    
    [currentUser setObject:imageFile forKey:@"profilePicture"];
    [currentUser saveInBackground];

    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
