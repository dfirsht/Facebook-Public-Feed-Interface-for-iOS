//
//  AppInfo.h
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/29/14.
//
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject
@property NSString* appID;
@property NSString* appSecret;
@property NSString* pageID;
- (id)initWithAppID:(NSString*)appID appSecret:(NSString*)appSecret pageID:(NSString*)pageID;
@end
