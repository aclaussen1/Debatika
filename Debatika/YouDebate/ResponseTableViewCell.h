//
//  ResponseTableViewCell.h
//  Debatika
//
//  Created by Alexander Claussen on 6/6/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResponseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleOfReply;
@property (weak, nonatomic) IBOutlet UITextView *reponseBody;

@end
