//
//  ViewDebateNavigationController.m
//  Debatika
//
//  Created by Alexander Claussen on 6/6/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "ViewDebateNavigationController.h"
#import "ViewDebateTableViewController.h"

@interface ViewDebateNavigationController ()

@end

@implementation ViewDebateNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewDebateTableViewController *vc = (ViewDebateTableViewController *)[self.viewControllers objectAtIndex:0];
    NSLog(@"%@ is obectID that nav controller is passing to table view", objectID);
    [vc setObjectID:objectID];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setObjectID:(NSString *)object {
    objectID = object;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
