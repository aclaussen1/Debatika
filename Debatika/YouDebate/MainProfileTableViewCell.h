//
//  MainProfileTableViewCell.h
//  Debatika
//
//  Created by Alexander Claussen on 6/10/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainProfileTableViewCell : UITableViewCell

//called new because changing it from one not working
@property (weak, nonatomic) IBOutlet UIImageView *theNewProfilePic;



@property (weak, nonatomic) IBOutlet UILabel *totalPoints;


@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
