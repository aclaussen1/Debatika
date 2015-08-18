//
//  MainViewController.m
//  YouDebate
//
//  Created by Alexander Claussen on 5/8/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import "MainViewController.h"
@import GoogleMobileAds;
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "InternetConnectivity.h"
#import "CNPPopupController.h"


@interface MainViewController () {
    int numberOfTimesAppeared;
    InternetConnectivity *internetReachableFoo;
    
    //to track whether the internet has been disconnected before to prevent Internet Connectivty notfication from testInternetConnectionInBackground: unwinding and calling popup multiple times. We only want it to do that once. It will be initialized as false.
    BOOL internetIssueHasHappened;

}

@property (nonatomic, strong) CNPPopupController *popupController;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MainViewController
//uses InternetConnectivity.m
- (void)testInternetConnectionInBackground
{
    internetReachableFoo = [InternetConnectivity reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(InternetConnectivity*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(InternetConnectivity*reach)
    {
        
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //because we only want this to happen once. it will be reset to false once the user logs back in.
            if (!internetIssueHasHappened) {
                [self unwindToLoginDueToInternetIssues];
            };
            NSLog(@"Someone broke the internet :(");
            internetIssueHasHappened = true;
        });
        
        
    };
    
    [internetReachableFoo startNotifier];
}

- (void) unwindToLoginDueToInternetIssues {
    [self showPopupWithStyle:CNPPopupStyleCentered];
    [self performSegueWithIdentifier:@"logoutUnwindSegue" sender:self];
}


- (void)viewDidLoad {
    internetIssueHasHappened = false;
    [self testInternetConnectionInBackground];
    
    //to track for ads
    numberOfTimesAppeared = 1;
    
    PFUser *currentUser = [PFUser currentUser];
    [super viewDidLoad];
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-7163536193655330/9012535002"];
    
   
        

    GADRequest *request = [GADRequest request];
    
     //Requests test ads on test devices.
    request.testDevices = @[@"9c0dfcc6774b5a70a2169ffc00b86b93"];
    
    [self.interstitial loadRequest:request];
    
    
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"ad not ready!");
    }

    
    if(currentUser.username != nil) {
        NSLog(@"current user: %@", currentUser.username);
        
        //for notifications
        UIUserNotificationType types = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        
    } else {
        NSLog(@"currentUser is nil");
    }
    
    

}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"You don't seem to be connected to the Internet." attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Debatika requires an internet connection." attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    
    //close the popup
    CNPPopupButton *button3 = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button3 setTitle:@"Close Me" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:.46 alpha:1.0];
    button3.layer.cornerRadius = 4;
    button3.selectionHandler = ^(CNPPopupButton *button){
        [self.popupController dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UILabel *lineOneLabel = [[UILabel alloc] init];
    lineOneLabel.numberOfLines = 0;
    lineOneLabel.attributedText = lineOne;
    
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, lineOneLabel, button3]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}


- (void) viewDidAppear:(BOOL)animated {
    numberOfTimesAppeared++;
    if ( [_sendingController isEqualToString:@"CreateADebateController"] ) {
        _sendingController = nil;
        [self performSegueWithIdentifier:@"toSettings" sender:self];
    }
    
    if ([self.interstitial isReady] && numberOfTimesAppeared > 4) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"ad not ready!");
    }
    
}

- (IBAction)unwindFromAnotherViewToMain:(UIStoryboardSegue *)segue
{
    NSLog(@"%@", segue.description);
    NSLog(@"Back to Main Selection Screen");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
