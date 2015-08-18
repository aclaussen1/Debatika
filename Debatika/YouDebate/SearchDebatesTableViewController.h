//
//  SearchDebatesTableViewController.h
//  Debatika
//
//  Created by Alexander Claussen on 7/11/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface SearchDebatesTableViewController : UITableViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
