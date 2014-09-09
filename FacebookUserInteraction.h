//
//  FacebookUserInteraction.h
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/29/14.
//
//

#import <Foundation/Foundation.h>

// Note that this class uses the FacebookSDK. In order to use this class you must follow the guidelines provided here: https://developers.facebook.com/docs/ios/getting-started

// This class also logs in the user when needed. In order for login to be successful, the - (BOOL)application:openURL:sourceApplication:annotation: method must be overwriten in the AppDelegate.

@interface FacebookUserInteraction : NSObject

+ (void)loginUser;
// Sends notification "FinishedLikingPost" on success, "ErrorLikingPost" on failure
+ (void)likePostWithID:(NSString*)ID;
// Sends notification "FinishedCommentingPost" on success, "ErrorCommentingPost" on failure
+ (void)commentPostWithID:(NSString*)ID andComment: (NSString*)comment;
// // Sends notification "FinishedGettingUserInfo" on success, "ErrorGettingUserInfo" on failure
+ (void)getCurrentUserInfo;
@end
