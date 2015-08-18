//
//  LeaveACommentViewController.h
//  Debatika
//
//  Created by Alexander Claussen on 6/20/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface LeaveACommentViewController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) PFObject *currentDebate;
@property (weak, nonatomic) NSString *objectID; //of currentDebate

@end
