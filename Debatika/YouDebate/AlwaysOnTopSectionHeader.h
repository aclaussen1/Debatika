//
//  SectionHeader.h
//  Debatika
//
//  Created by Alexander Claussen on 6/2/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSCell.h"
#import "Parse/Parse.h"

@interface AlwaysOnTopSectionHeader : CSCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
