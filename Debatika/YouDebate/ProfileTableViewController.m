//
//  ProfileTableViewController.m
//  Debatika
//
//  Created by Alexander Claussen on 6/8/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "FBSDKCoreKit/FBSDKGraphRequest.h"
#import "ProfileTableViewController.h"
#import  "MainProfileTableViewCell.h"
#import "FBSDKCoreKit/FBSDKProfile.h"
#import "Parse/Parse.h"
#import "ParseUI/PFImageView.h"

@interface ProfileTableViewController () {
    FBSDKAccessToken *fbToken;
    PFUser *currentUser;
}


@end

@implementation ProfileTableViewController

- (IBAction)unwindToHome:(id)sender {
    [self performSegueWithIdentifier:@"returnHome" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //creating the home button
    UIBarButtonItem *returnToHomeButton = [[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(unwindToHome:)];
    self.navigationItem.leftBarButtonItem = returnToHomeButton;
    
    currentUser = [PFUser currentUser];
    
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainProfile" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    

    
    NSString *stringToUseForLabel = [NSString stringWithFormat:@"%@%@", @"Total Points: ", currentUser[@"Points"] ];
    cell.totalPoints.text = stringToUseForLabel;
    cell.userName.text = currentUser[@"username"];
    
    //if current user is not logged in
    if (!currentUser) {
        cell.userName.text = @"Guest";
        cell.totalPoints.text = @"Total Points: 0";
    }
    
    
        cell.theNewProfilePic.layer.cornerRadius =  cell.theNewProfilePic.frame.size.width / 2 ;
    cell.theNewProfilePic.clipsToBounds = YES;
    PFFile *imageFile = [currentUser objectForKey:@"profilePicture"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            cell.theNewProfilePic.image = image;
            
        }
    }];
    

    /*
    //for facebook users, takes their profile picture and makes it a circle
    if (currentUser[@"isConnectedToFacebook"]) {
        NSLog(@"Current user is connected to facebook.");
        FBSDKProfilePictureView *facebookProfilePic= [[FBSDKProfilePictureView alloc] initWithFrame:cell.profilePicture.frame];
        
     [facebookProfilePic setProfileID:fbToken.userID];
        cell.profilePicture = facebookProfilePic;
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2;
        cell.profilePicture.clipsToBounds = YES;
        
      [self.view addSubview:cell.profilePicture];
        cell.userName.text = currentUser[@"username"];
        
        
        
     
        //uploads the facebookimage to parse
        UIGraphicsBeginImageContext(cell.profilePicture.frame.size);
        [cell.profilePicture.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *convertingFBViewToImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *data=UIImagePNGRepresentation(convertingFBViewToImage);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:data];
        [imageFile saveInBackground];
        
        [currentUser setObject:imageFile forKey:@"profilePicture"];
        [currentUser saveInBackground];
     
       
        
        
        
     }
    else {
        //doing the same thing for now, but would like to have an array of pictures that will be used for users who have not set a profile picture
        FBSDKProfilePictureView *facebookProfilePic= [[FBSDKProfilePictureView alloc] initWithFrame:cell.profilePicture.frame];
        
        [facebookProfilePic setProfileID:fbToken.userID];
        cell.profilePicture = facebookProfilePic;
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2;
        cell.profilePicture.clipsToBounds = YES;
    }
     */
    
    
    
    
    return cell;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
