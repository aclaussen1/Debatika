//
//  SearchDebatesTableViewController.m
//  Debatika
//
//  Created by Alexander Claussen on 7/11/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "FeaturedTableViewCell.h"
#import "SearchDebatesTableViewController.h"
#import "Parse/Parse.h"
#import "ViewDebateTableViewController.h"


@interface SearchDebatesTableViewController () {
    
    NSArray *tableDataComingFromDescription;
    NSArray *tableDataComingFromTitle;
    NSArray *tableDataNoDuplicates;
    NSArray *categories;
    NSMutableArray *colors;
    //if no, then categories of debates will be displayed. otherwise only search results will be displayed
    BOOL hasSearched;
    
}

@end

@implementation SearchDebatesTableViewController

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

- (void)viewDidLoad {
    self.tableView.delegate = self;
    [self.tableView setAllowsSelection:YES];
    
    
    //sets array to colors of the rainbow
    colors = [NSMutableArray array];
    float INCREMENT = 0.1;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
    
    
    categories = @[@"Politics", @"Culture", @"Sports", @"Philosophy", @"Technology", @"Local Issues", @"Science", @"Other"];
    hasSearched = false;
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    
    //for UIScrollView+EmptyDataSet.h;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators. this removes the seperator lines when the empty data set display is shown
    self.tableView.tableFooterView = [UIView new];
    
    [super viewDidLoad];
    
    
    
    //tap gesture recognizers recognizes a tap and will call dismiss keyboard (declared in leaveacommentviewcomment.m) which wil dismiss any keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    //must be no, not yes, because having a gesture regonizer defaults to true and this prevents didSelectRowIndexPath: from being called
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    //this is to prevent the navigation bar from covering over the search bar
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!hasSearched) {
    return [categories count];
    } else {
        return [tableDataNoDuplicates count];
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!hasSearched) {
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
        
        cell.testLabel.text = [categories objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [colors objectAtIndex:indexPath.row];
        
        
        
        return cell;
        
        
        
    } else {
        FeaturedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleTableItem" forIndexPath:indexPath];
        
        cell.title.text = [tableDataNoDuplicates objectAtIndex:indexPath.row][@"Title"];
        cell.descriptionSubtitle.text = [tableDataNoDuplicates objectAtIndex:indexPath.row][@"description"];
        
        [self.tableView setSeparatorColor:[UIColor grayColor]];
        
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (hasSearched) { //to show debates
      return 200;
    }
    else return 55; //to show categories
}

- (void)viewWillAppear:(BOOL)animated {
    //sets title of navigation bar
    [self.tabBarController setTitle:@"Search Debates"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

     
    if (!hasSearched) {
        PFQuery *query = [PFQuery queryWithClassName:@"Debate"];
        [query whereKey:@"Category" matchesRegex:[categories objectAtIndex:indexPath.row] modifiers:@"i"];
        tableDataNoDuplicates = [query findObjects];
        
        hasSearched = true;
        
        [self.tableView reloadData];
    }
}

#pragma mark - EmptyDataSet datasource methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *imageToUseForEmptyDataSet = [UIImage imageNamed:@"CryingBaby"];
    CGRect rect;
    UIImage *cornersCutOfImage = [self circularScaleAndCropImage:imageToUseForEmptyDataSet ];
    return cornersCutOfImage;
    
}

- (UIImage*)circularScaleAndCropImage:(UIImage*)image  {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = image.size.width/2;
    CGFloat imageCentreY = image.size.height/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = image.size.width/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, 1, 1);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Results";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Perhaps you could create the debate yourself?";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    //when there is empty data set, 0 height
    return 0;
}

#pragma mark - delegate implementation empty data set
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - UISearchView delegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    
    
    
    //first queries using description. then queries using title of debate. These are stored in two seperate arrays. the arrays are then combined into a new array. this is changed into an nsset which will remove duplicates. changed back to array
    PFQuery *query = [PFQuery queryWithClassName:@"Debate"];
    [query whereKey:@"description" matchesRegex:self.searchBar.text modifiers:@"i"];
    tableDataComingFromDescription = [query findObjects];
    [query whereKey:@"Title" matchesRegex:self.searchBar.text modifiers:@"i"];
    tableDataComingFromTitle = [query findObjects];
    NSArray *newArray= [tableDataComingFromDescription arrayByAddingObjectsFromArray:tableDataComingFromTitle];
    NSSet *mergedDataSetForm = [NSSet setWithArray:newArray];
   
    tableDataNoDuplicates = [mergedDataSetForm allObjects];
    for (id obj in tableDataNoDuplicates) {
        NSLog(@"IN the tableData there is a debate with this objectID :%@", [obj valueForKey:@"objectId"]);
    }
   
    hasSearched = true;
    
    
    [self.tableView reloadData];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"toViewDebate"])
    {
        NSLog(@"executing prepare for segue snipit");
        // Get reference to the destination view controller
        ViewDebateTableViewController *vc = [segue destinationViewController];
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        PFObject *nsobject = [tableDataNoDuplicates objectAtIndex:path.row];
        NSString *objectID = [nsobject valueForKey:@"objectId"];
        NSLog(@"%@", objectID);
        
        // Pass any objects to the view controller here, like...
        [vc setObjectID:objectID];
    }
}



@end
