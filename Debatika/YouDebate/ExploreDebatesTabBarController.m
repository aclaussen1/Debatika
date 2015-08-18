//
//  ExploreDebatesTabBarController.m
//  Debatika
//
//  Created by Alexander Claussen on 5/30/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "ExploreDebatesTabBarController.h"
#import "BlankTransitionToMainViewController.h"

@interface ExploreDebatesTabBarController ()

@end

@implementation ExploreDebatesTabBarController

- (IBAction)unwindToFeaturedTableViewController:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"Back to Featured Table View Screen");
}

- (IBAction)homeButton:(id)sender {
    [self performSegueWithIdentifier:@"toMainMenu" sender:self];
}


- (void)viewDidLoad {
    NSArray *controllers = self.viewControllers;
    
    NSLog(@"%@", controllers);
    
    UIViewController *firstViewController = [controllers objectAtIndex:0];
   
    
    
    //setting icons
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    tabBarItem1.title = @"Featured";
    //[tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"AddBarButtonItem"] withFinishedUnselectedImage:[UIImage imageNamed:@"ios7-plus-outline2x"]];
    [tabBarItem2 initWithTitle:@"Create Debate" image:[UIImage imageNamed:@"AddBarButtonItem"]  selectedImage:[UIImage imageNamed:@"AddBarButtonSelectedItem"] ];
    [tabBarItem3 initWithTitle:@"Search" image:[UIImage imageNamed:@"search@2x"]  selectedImage:[UIImage imageNamed:@"search@2x"] ];
    
    
    [self setDelegate:self];
    [super viewDidLoad];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
  
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
