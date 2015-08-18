//
//  ForgotPasswordViewController.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/11/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Parse/Parse.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation ForgotPasswordViewController

- (IBAction)resetPassword:(id)sender {
    
    if ( [PFUser requestPasswordResetForEmail:self.email.text
                                        error:nil] ) {
        [PFUser requestPasswordResetForEmailInBackground:self.email.text];
        UIAlertView *resetPasswordConfrimedAlertView = [[UIAlertView alloc] initWithTitle:@"Password Reset" message:@"Expect an email to reset your password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [resetPasswordConfrimedAlertView show];
        [self performSegueWithIdentifier: @"toLogin" sender:self];
    }
    else {
                UIAlertView *resetPasswordFailedAlertView = [[UIAlertView alloc] initWithTitle:@"Password Reset Failed" message:@"The email you entered is incorrect." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [resetPasswordFailedAlertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
