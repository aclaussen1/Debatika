//
//  RegisterViewController.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/5/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "RegisterViewController.h"
#import "Parse/Parse.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation RegisterViewController

/*
    initialization of isConnectedToFacebook, honors, and points in Parse occurs when user first logs in
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)registration:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    user.password = self.password.text;
    user.email = self.email.text;
   
    user[@"Points"] = @0.0;
    user[@"Honors"] = @0.0;
    user[@"isConnectedToFacebook"] = @NO;
    
    
    
   
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertView *registrationConfrimedAlertView = [[UIAlertView alloc] initWithTitle:@"You are registered!" message:@"Looks good. Heading back to login screen." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            
            [registrationConfrimedAlertView show];
            [self performSegueWithIdentifier: @"toLogin" sender:self];
        } else {
            
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong! Try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}

*/
@end
