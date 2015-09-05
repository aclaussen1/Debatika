//
//  Debates1v1TabBarController.m
//  Debatika
//
//  Created by Alexander Claussen on 9/5/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "Debates1v1TabBarController.h"

@interface Debates1v1TabBarController ()

@end

@implementation Debates1v1TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //UIBarButtonItem *one = [[UIBarButtonItem alloc]initWithTitle:@"One" style:UIBarButtonItemStylePlain target:self action:@selector(homeButton:)];
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeBarButtonItem"] style:UIBarButtonItemStylePlain target:self action:@selector(homeButton:)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc]initWithTitle:@"Two" style:UIBarButtonItemStylePlain target:self action:@selector(testMethod)];
    UIBarButtonItem *three = [[UIBarButtonItem alloc]initWithTitle:@"Three" style:UIBarButtonItemStylePlain target:self action:@selector(testMethod)];
    
    // create a spacer
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 30;
    
    NSArray *buttons = @[one, space, two, space, three];
    
    self.navigationItem.rightBarButtonItems = buttons;
}

- (IBAction)homeButton:(id)sender {
    [self performSegueWithIdentifier:@"unwindToMain" sender:self];
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
