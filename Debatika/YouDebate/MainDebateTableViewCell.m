//
//  MainDebateTableViewCell.m
//  Debatika
//
//  Created by Alexander Claussen on 6/6/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "MainDebateTableViewCell.h"

@implementation MainDebateTableViewCell {

    NSMutableArray *debatesCurrentUserHasUpvoted;
    NSMutableArray *debatesCurrentUserHasDownvoted;
    __weak IBOutlet UIButton *upvoteButtonOutlet;
}

- (void)awakeFromNib {
    //even though currentUser is passed, it is nessary to refresh this every time the ViewdebateTableViewController is displayed because the previous view has not updated the currentUser
    self.currentUser = [PFUser currentUser];
    
    debatesCurrentUserHasDownvoted = [NSMutableArray arrayWithArray:self.currentUser[@"DebatesDownvoted"] ];
    debatesCurrentUserHasUpvoted = [NSMutableArray arrayWithArray:self.currentUser[@"DebatesUpvoted"] ];
    
    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)upvote:(id)sender {
    
    
    
    if ([debatesCurrentUserHasUpvoted containsObject:_currentDebateObjectID]) { //user already upvoted
        UIAlertView *alreadyUpvoted = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You already upvoted this debate." delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [alreadyUpvoted show];
    }
    
    else if ([debatesCurrentUserHasDownvoted containsObject:_currentDebateObjectID]) { //user downvoted, but wants to change to upvote
        NSNumber *votes = self.currentDebate[@"votes"];
         NSNumber *votesPlusTwo = @([votes intValue] + 2);
        self.currentDebate[@"votes"] = votesPlusTwo;
        [self.currentDebate saveInBackground];
        
        NSNumber *PointsThatUserHas = self.userThatCreatedDebate[@"Points"];
        NSNumber *PointsPlusTwo = @([PointsThatUserHas intValue] + 2);
        self.userThatCreatedDebate[@"Points"] = PointsPlusTwo;
        [self.userThatCreatedDebate saveInBackground];

        
        
        [debatesCurrentUserHasDownvoted removeObject:_currentDebateObjectID];
        [debatesCurrentUserHasUpvoted addObject:_currentDebateObjectID];
        NSArray *upvotedArray = [debatesCurrentUserHasUpvoted copy];
        NSArray *downvotedArray = [debatesCurrentUserHasDownvoted copy];
        self.currentUser[@"DebatesUpvoted"] = upvotedArray;
        self.currentUser[@"DebatesDownvoted"] = downvotedArray;
        [self.currentUser saveInBackground];
        
        self.visibilityPoints.text = [NSString stringWithFormat:@"%@%@", @"Points: ", self.currentDebate[@"votes"] ];
        
        
        
    } else { //user has yet to upvote or downvote
        NSNumber *votes = self.currentDebate[@"votes"];
        NSNumber *votesPlusOne = @([votes intValue] + 1);
        self.currentDebate[@"votes"] = votesPlusOne;
        [self.currentDebate saveInBackground];
        
        NSNumber *pointsUserHas = self.userThatCreatedDebate[@"Points"];
        NSNumber *pointsPlusOne = @([pointsUserHas intValue] + 1);
        self.userThatCreatedDebate[@"Points"] = pointsPlusOne;
        [self.userThatCreatedDebate saveInBackground];
        
        
        [debatesCurrentUserHasUpvoted addObject:_currentDebateObjectID];
        NSArray *array = [debatesCurrentUserHasUpvoted copy];
        self.currentUser[@"DebatesUpvoted"] = array;
        [self.currentUser saveInBackground];
        
        self.visibilityPoints.text = [NSString stringWithFormat:@"%@%@", @"Points: ", self.currentDebate[@"votes"] ];
    }
    
}

- (IBAction)downvote:(id)sender {
    if ([debatesCurrentUserHasDownvoted containsObject:_currentDebateObjectID]) { //user already downvoted
        UIAlertView *alreadyDownvoted = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You already downvoted this debate." delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:nil, nil];
        [alreadyDownvoted show];
    }
    else if ([debatesCurrentUserHasUpvoted containsObject:_currentDebateObjectID]) { //user upvoted, but wants to change to downvote
        NSNumber *votes = self.currentDebate[@"votes"];
        NSNumber *votesPlusTwo = @([votes intValue] - 2);
        self.currentDebate[@"votes"] = votesPlusTwo;
        [self.currentDebate saveInBackground];
        
        NSNumber *PointsThatUserHas = self.userThatCreatedDebate[@"Points"];
        NSNumber *PointsMinusTwo = @([PointsThatUserHas intValue] - 2);
        self.userThatCreatedDebate[@"Points"] = PointsMinusTwo;
        [self.userThatCreatedDebate saveInBackground];
        
        [debatesCurrentUserHasDownvoted addObject:_currentDebateObjectID];
        [debatesCurrentUserHasUpvoted removeObject:_currentDebateObjectID];
        NSArray *upvotedArray = [debatesCurrentUserHasUpvoted copy];
        NSArray *downvotedArray = [debatesCurrentUserHasDownvoted copy];
        self.currentUser[@"DebatesUpvoted"] = upvotedArray;
        self.currentUser[@"DebatesDownvoted"] = downvotedArray;
        [self.currentUser saveInBackground];
        
        self.visibilityPoints.text = [NSString stringWithFormat:@"%@%@", @"Points: ", self.currentDebate[@"votes"] ];
        
        
        
    }
    else { //user has yet to upvote or downvote
        NSNumber *votes = self.currentDebate[@"votes"];
        NSNumber *votesMinusOne = @([votes intValue] - 1);
        self.currentDebate[@"votes"] = votesMinusOne;
        [self.currentDebate saveInBackground];
        
        
        NSNumber *pointsUserHas = self.userThatCreatedDebate[@"Points"];
        NSNumber *pointsMinusOne = @([pointsUserHas intValue] - 1);
        self.userThatCreatedDebate[@"Points"] = pointsMinusOne;
        [self.userThatCreatedDebate saveInBackground];
        
        [debatesCurrentUserHasDownvoted addObject:_currentDebateObjectID];
        NSArray *array = [debatesCurrentUserHasDownvoted copy];
        self.currentUser[@"DebatesDownvoted"] = array;
        [self.currentUser saveInBackground];
        
        self.visibilityPoints.text = [NSString stringWithFormat:@"%@%@", @"Points: ", self.currentDebate[@"votes"] ];
    }
    
}

- (IBAction)honor:(id)sender {
    self.honorPoints.text = @"changed to penis";
}

- (IBAction)report:(id)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Someone up to trouble?" message:@"Don't worry. The Debatika authorities will be on the case! Thanks for reporting this issue." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alertview show];
}
@end
