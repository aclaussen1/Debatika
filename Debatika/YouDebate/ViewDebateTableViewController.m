//
//  ViewDebateTableViewController.m
//  Debatika
//
//  Created by Alexander Claussen on 6/6/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//


//test comment. totally useless, can be deleted


#import "ViewDebateTableViewController.h"
#import "Parse/Parse.h"
#import "MainDebateTableViewCell.h"
#import "ResponseTableViewCell.h"
#import "Parse/Parse.h"
#import "FBSDKCoreKit/FBSDKAccessToken.h"
#import "FBSDKCoreKit/FBSDKProfilePictureView.h"
#import "LeaveACommentViewController.h"
#import "SimpleLeaveYouReplyHeretableViewCell.h"

@interface ViewDebateTableViewController () {
    PFQuery *query;
    PFObject *currentDebate;
    //there is also objectID in the header file
    NSArray *replies;
    PFUser *userThatCreatedDebate;
    PFUser *currentUser;
}


@end

@implementation ViewDebateTableViewController

- (IBAction)unwindFromAnotherViewToViewDebate:(UIStoryboardSegue *)segue
{

    NSLog(@"Back to View Debate scene");
    
}

- (IBAction) buttonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:@"toFeaturedViewController" sender:self];
}

- (void)viewDidLoad {
    query = [PFQuery queryWithClassName:@"Debate"];
    currentDebate = [query getObjectWithId:objectID];
    
    query = [PFUser query];
    userThatCreatedDebate = [query getObjectWithId:currentDebate[@"createdBy"] ];
    
    /*
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(buttonTouchUpInside:)];
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    */
    
    currentUser = [PFUser currentUser];
    
    
    
    //load replies
    PFQuery *query2 = [PFQuery queryWithClassName:@"Responses"];
    [query2 whereKey:@"parent" equalTo:objectID];
    replies = [query2 findObjects];
    

    
    NSLog(@"%@ are the replies for this debate", replies.description);
    
    [super viewDidLoad];
    
    NSLog(@"%@ is the objectID", objectID);
    
    //avoid collision with status bar
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setObjectID:(NSString *)object {
    objectID = object;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2 + [replies count];
    NSLog(@"%@ is the number of replies to this debate", [replies count]);
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *firstTableIdentifier = @"mainDebate";
    static NSString *responseTableIdentifier = @"response";
    MainDebateTableViewCell *mainCell;
    ResponseTableViewCell *responseCell;
    if (indexPath.row == 0) {
        
        MainDebateTableViewCell *mainCell = [self.tableView dequeueReusableCellWithIdentifier:firstTableIdentifier forIndexPath:indexPath];
        
        NSString *stringToUseForLabel = [NSString stringWithFormat:@"%@%@", @"Points: ", currentDebate[@"votes"] ];
        mainCell.visibilityPoints.text = stringToUseForLabel;
        
        
        //setting image
        mainCell.imageOfDebate.image= [UIImage imageNamed:@"Lincoln"];
        mainCell.imageOfDebate.layer.cornerRadius = mainCell.imageOfDebate.frame.size.width / 2 ;
        mainCell.imageOfDebate.clipsToBounds = YES;
        //forces to go into mode
        [mainCell.imageOfDebate setContentMode:UIViewContentModeScaleAspectFit];
        PFFile *file = [userThatCreatedDebate objectForKey:@"profilePicture"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                NSLog(@"Setting image of debate creator from parse");
                UIImage *image = [UIImage imageWithData:data];
                 mainCell.imageOfDebate.image = image;
                
            }
        }];
        //imageOfDebate
        
        mainCell.debateTitle.text = currentDebate[@"Title"];
        mainCell.debateDescription.text = currentDebate[@"description"];
        mainCell.debateDescription.editable = NO;
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        mainCell.userThatCreatedDebate = userThatCreatedDebate;
        mainCell.currentUser = currentUser;
        mainCell.currentDebate = currentDebate;
        mainCell.currentDebateObjectID = objectID;

        //setting posedBy
        [mainCell.posedBy setTitle:userThatCreatedDebate[@"username"] forState:UIControlStateNormal];
        
        
        
        return mainCell;
    } else if (indexPath.row == 1) {
        SimpleLeaveYouReplyHereTableViewCell *leaveYourreply = [self.tableView dequeueReusableCellWithIdentifier:@"LeaveYourReply" forIndexPath:indexPath];
       
        if ( [replies count] == 0) {
        leaveYourreply.theOnlyTextLabel.text = @"Be the first to comment.";
        }
        return leaveYourreply;
    }
    
    
        
       else {
            
            ResponseTableViewCell *responseCell =  [self.tableView dequeueReusableCellWithIdentifier:responseTableIdentifier forIndexPath:indexPath];
           PFObject *thisReply = [replies objectAtIndex:indexPath.row - 2];
           responseCell.titleOfReply.text = thisReply[@"title"];
           responseCell.reponseBody.text = thisReply[@"responseText"];
           
           return responseCell;
            
        }
        
        
        
    
   
    //should never return nil
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 454;
    }
    else if (indexPath.row == 1) {
        return 119;
    }
    
    else return 302;
}



/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
     
     
     if ([[segue identifier] isEqualToString:@"toLeaveAComment"]) {
     
     // Get reference to the destination view controller
     LeaveACommentViewController *vc = [segue destinationViewController];
     
     
     // Pass any objects to the view controller here, like...
     [vc setCurrentDebate:currentDebate];
     [vc setObjectID:objectID];
     
     }
 }

 @end
