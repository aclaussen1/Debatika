//
//  FeaturedTableViewController.m
//  Debatika
//
//  Created by Alexander Claussen on 5/31/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "FeaturedTableViewController.h"
#import "Parse/Parse.h"
#import "FeaturedTableViewCell.h"
#import "ViewDebateTableViewController.h"

@interface FeaturedTableViewController ()

 
 


@end

@implementation FeaturedTableViewController


{
    NSArray *tableData;
    NSMutableArray *tableDataMutable;
}

- (void) viewDidAppear:(BOOL)animated {
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    
 
    PFQuery *query = [PFQuery queryWithClassName:@"Debate"];
    [query orderByDescending:@"createdAt"];
    tableData = [query findObjects];
    for (id obj in tableData) {
        NSLog(@"Featured Table View Controller has generated debate: %@", [obj valueForKey:@"objectId"]);
    }
    
    
    tableDataMutable = [NSMutableArray arrayWithArray:tableData];
    
    /*
    PFObject *firstDebateActuallyAnAd = [PFObject objectWithClassName:@"Debate"];
    firstDebateActuallyAnAd[@"Title"] = @"Want your debate featured here?";
    firstDebateActuallyAnAd[@"description"] = @"Get your debate featured at the top slot!";
    [tableDataMutable insertObject:firstDebateActuallyAnAd atIndex:0];
    */
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    FeaturedTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    cell.title.text = [tableDataMutable objectAtIndex:indexPath.row][@"Title"];
    cell.descriptionSubtitle.text = [tableDataMutable objectAtIndex:indexPath.row][@"description"];
    
    /* There is some magic going on here that I do not quite understand. I used some code from stackoverflow. http://stackoverflow.com/questions/26920632/how-to-asynchronously-load-uitableviewcell-images-so-that-scrolling-doesnt-lag
        Without the dispatch_async, the featured debates was very laggy. I would get warnings saying that there was long running operation going on in the main thread. I think this had to do with the image of debate creators constantly coming from Parse. I need to read into this more so I'm not just a monkey who copies code. I should read about concurrency on iOS. But it whatever it is doing, it fixed the problem.
     
        The code that is commented out right below this is what existed before, that was causing the lagginess.
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PFQuery * query = [PFUser query];
        PFUser *userThatCreatedDebate = [query getObjectWithId:[tableDataMutable objectAtIndex:indexPath.row][@"createdBy"] ];
        PFFile *file = [userThatCreatedDebate objectForKey:@"profilePicture"];
        UIImage *image = [UIImage imageWithData:[file getData]];
        // Use main thread to update the view. View changes are always handled through main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // Refresh image view here
            cell.profilePicture.image = image;
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2 ;
            cell.profilePicture.clipsToBounds = YES;
            [cell setNeedsLayout];
        });
    });
    
    
    /*
    PFQuery * query = [PFUser query];
    PFUser *userThatCreatedDebate = [query getObjectWithId:[tableDataMutable objectAtIndex:indexPath.row][@"createdBy"] ];
    PFFile *file = [userThatCreatedDebate objectForKey:@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.profilePicture.image = image;
            
        }
    }];
     */
    
    /*
    //first row for featuring
    if (indexPath.row == 0) {
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"WantYourDebateFeatured?" forIndexPath:indexPath];
    [cell.contentView.layer setBorderColor:[UIColor yellowColor].CGColor];
    [cell.contentView.layer setBorderWidth:4.0f];
    
    cell.title.text = [tableDataMutable objectAtIndex:0][@"Title"];
    cell.descriptionSubtitle.text = [tableDataMutable objectAtIndex:0][@"description"];

        
    }
    */
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *debateDescription = [tableDataMutable objectAtIndex:indexPath.row][@"description"];
    
   
                              
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 350;
}


- (void)viewWillAppear:(BOOL)animated {
    //sets title of navigation bar
    [self.tabBarController setTitle:@"Featured Debates"];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"toViewDebate"])
    {
        NSLog(@"executing prepare for segue snipit");
        // Get reference to the destination view controller
        ViewDebateTableViewController *vc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        PFObject *nsobject = [tableDataMutable objectAtIndex:path.row];
        NSString *objectID = [nsobject valueForKey:@"objectId"];
        NSLog(@"%@", objectID);
       
        // Pass any objects to the view controller here, like...
        [vc setObjectID:objectID];
    }
}


@end
