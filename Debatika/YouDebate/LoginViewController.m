//
//  ViewController.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/5/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "CNPPopupController.h"
#import <QuartzCore/QuartzCore.h>
#import "InternetConnectivity.h"

@interface LoginViewController () {
    UITextField *popupTextField;
    InternetConnectivity *internetReachableFoo;
}

@property (nonatomic, strong) CNPPopupController *popupController;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSArray *permissions;




@end

@implementation LoginViewController

//uses InternetConnectivity.m
- (void)testInternetConnection
{
    internetReachableFoo = [InternetConnectivity reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(InternetConnectivity*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(InternetConnectivity*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [internetReachableFoo startNotifier];
}



- (IBAction)unwindFromMainToLogin:(UIStoryboardSegue *)segue
{
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"current user: %@", currentUser.username);
    [PFUser logOut];
    NSLog(@"user logged out");
    
}


- (IBAction)continueAsGuest:(id)sender {
    NSLog(@"continuing as a guest and logging out");
    [PFUser logOut];
}



- (IBAction)reguarLogin:(id)sender {
    [PFUser logInWithUsernameInBackground:self.username.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self performSegueWithIdentifier: @"toMainPage" sender:self];
                                        } else {
                                            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username and/or password do not match" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                            [errorAlertView show];
                                        }
                                    }];
}

- (IBAction)facebookLogin:(id)sender {
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:self.permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login. Error: %@", error);
            UIAlertView *FBLoginFailed = [[UIAlertView alloc] initWithTitle:@"Facebook Login Failed." message:@"Something went wrong. Try continuing as a guest." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [FBLoginFailed show];
            
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            user[@"isConnectedToFacebook"] = @YES;
            user[@"Points"] = @0.0;
            user[@"Honors"] = @0.0;
            [user saveInBackground];
            [self performSegueWithIdentifier: @"toMainPage" sender:self];
            [self showGuestNeedsToLoginPopupWithStyle:CNPPopupStyleCentered withTitle:@"Welcome to Debatika!" withMessage:@"All debators must select a pseudonym (username)."];
        } else {
            
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier: @"toMainPage" sender:self];
            
        }
    }];
}

//popup for facebook users who need to select a username
- (void)showGuestNeedsToLoginPopupWithStyle:(CNPPopupStyle)popupStyle withTitle:(NSString *)titleString withMessage:(NSString *)message {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    popupTextField = [[UITextField alloc] init];
    popupTextField.delegate = self;
    popupTextField.layer.borderWidth = 1.0f;
    popupTextField.layer.borderColor = [[UIColor blackColor] CGColor];
    popupTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    popupTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    //close the popup
    CNPPopupButton *button1 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button1 setTitle:@"Submit Username" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:.46 alpha:1.0];
    button1.layer.cornerRadius = 4;
    button1.selectionHandler = ^(CNPPopupButton *button){
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:popupTextField.text]; // find all the women
        NSArray *arrayOfUsersWithName = [query findObjects];
        if ([popupTextField.text length] < 3) {
            [self.popupController dismissPopupControllerAnimated:YES];
            [self showGuestNeedsToLoginPopupWithStyle:CNPPopupStyleCentered withTitle:@"Whoops!" withMessage:@"Your username needs at least 3 charachters"];
        } else if ([arrayOfUsersWithName count] == 0) {
            [[PFUser currentUser] setUsername:popupTextField.text];
            [[PFUser currentUser] saveEventually];
            [self.popupController dismissPopupControllerAnimated:YES];
        }
        else {
            [self.popupController dismissPopupControllerAnimated:YES];
            [self showGuestNeedsToLoginPopupWithStyle:CNPPopupStyleCentered withTitle:@"Whoops, somebody already has that username." withMessage:@"Try another one."];
        }
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel,popupTextField, lineOneLabel, button1]];
    
    
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}


- (void)viewDidLoad {
    
    
    self.permissions = @[@"public_profile"];
    _username.delegate = self;
    _password.delegate = self;
    //Current user. It would be bothersome if the user had to log in every time they open your app. You can avoid this by using the cached currentUser object.
    
    //tests for an internet connection
    [self testInternetConnection];
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
