
//
//  AppInfo.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/29/14.
//
//

#import "AppInfo.h"

@implementation AppInfo
- (id)initWithAppID:(NSString*)appID appSecret:(NSString*)appSecret pageID:(NSString*)pageID {
    if(self = [super init]) {
        _appID = appID;
        _appSecret = appSecret;
        _pageID = pageID;
    }
    return self;
}
@end
