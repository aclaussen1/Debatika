//
//  MainDebateTableViewCell.h
//  Debatika
//
//  Created by Alexander Claussen on 6/6/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface MainDebateTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *debateTitle;
@property (weak, nonatomic) IBOutlet UIButton *posedBy;
- (IBAction)upvote:(id)sender;
- (IBAction)downvote:(id)sender;
- (IBAction)Honor:(id)sender;
- (IBAction)report:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *visibilityPoints;
@property (weak, nonatomic) PFObject *currentDebate;
@property (weak, nonatomic) NSString *currentDebateObjectID;
@property (weak, nonatomic) PFObject *currentReply;
@property (weak, nonatomic) IBOutlet UILabel *honorPoints;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfDebate;
@property (weak, nonatomic) IBOutlet UITextView *debateDescription;
@property (weak, nonatomic) PFUser *userThatCreatedDebate;
@property (weak, nonatomic) PFUser *currentUser;

@end
