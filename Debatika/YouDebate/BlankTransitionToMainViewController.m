//
//  BlankTransitionToMainViewController.m
//  Debatika
//
//  Created by Alexander Claussen on 5/30/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "BlankTransitionToMainViewController.h"


@interface BlankTransitionToMainViewController ()

@end

@implementation BlankTransitionToMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    //[self performSegueWithIdentifier:@"toMainMenu" sender:self];

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
