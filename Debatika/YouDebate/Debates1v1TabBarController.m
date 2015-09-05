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

    
    /*
     The following code creates 4 bar button items for this tab bar controller to add to the navigation bar. It spaces them out by finding the width of the screen. Funcitonally, it puts the the bar buttons that sit out on the outer edge, then puts a space equal to the width of the screen divided by 7. This is because there are essentially 7 things in the navigation bar (4 buttons and 3 spaces). Two arrays are used, one for the rightBarButtonItmes and one for the LeftBarButtonItems.
     */
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeBarButtonItem"] style:UIBarButtonItemStylePlain target:self action:@selector(homeButton:)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc]initWithTitle:@"Two" style:UIBarButtonItemStylePlain target:self action:@selector(homeButton:)];
    UIBarButtonItem *three = [[UIBarButtonItem alloc]initWithTitle:@"Three" style:UIBarButtonItemStylePlain target:self action:@selector(homeButton:)];
    UIBarButtonItem *four = [[UIBarButtonItem alloc]initWithTitle:@"Four" style:UIBarButtonItemStylePlain target:self action:@selector(homeButton:)];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = screenWidth / 7;
    
    NSArray *rightButtons = @[one, space, two];
    NSArray *leftButtons = @[four, space, three];
    self.navigationItem.rightBarButtonItems = rightButtons;
    self.navigationItem.leftBarButtonItems = leftButtons;
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
