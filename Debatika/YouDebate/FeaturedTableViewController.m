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
   
    return 200;
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
