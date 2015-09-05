//
//  FeaturedTableViewCell.h
//  Debatika
//
//  Created by Alexander Claussen on 6/2/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeaturedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *descriptionSubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end
