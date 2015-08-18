//
//  SectionHeader.m
//  Debatika
//
//  Created by Alexander Claussen on 6/2/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "AlwaysOnTopSectionHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"

@implementation AlwaysOnTopSectionHeader
{
    PFUser *currentUser;
}

- (void)didMoveToWindow {
    currentUser = [PFUser currentUser];
    if (currentUser) {
        self.titleLabel.text = currentUser.username;
        self.userName.text = currentUser.username;
        
    } else {
        self.titleLabel.text = @"Guest";
        self.userName.text = @"Guest";
    }
    //self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    //self.profilePicture.clipsToBounds = YES;
}

- (IBAction)homeButtonPressed:(id)sender {
   
    //[self.]
}


- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {

    
   
    
    
    
    [UIView beginAnimations:@"" context:nil];
    
    if (layoutAttributes.progressiveness <= 0.58) {
        self.titleLabel.alpha = 1;
    } else {
        self.titleLabel.alpha = 0;
    }
    
    if (layoutAttributes.progressiveness >= 1) {
        self.searchBar.alpha = 1;
    } else {
        self.searchBar.alpha = 0;
    }
    
    [UIView commitAnimations];
}

@end
