//
//  GlobalVars.h
//  YouDebate
//
//  Created by Alexander Claussen on 5/12/15.
//  Copyright (c) 2015 MudLord. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject
{
    BOOL *_isAFacebookUser;
}

+ (GlobalVars *)sharedInstance;


@end
