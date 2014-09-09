//
//  FacebookUserInteraction.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/29/14.
//
//

#import "FacebookUserInteraction.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookUserInteraction

+ (void)loginUser {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // session is already open, just return
        return;
    }
    // check if active session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                      }];
    }
    else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
         }];
    }
}
+ (void)likePostWithID:(NSString *)ID {
    [self loginUser];
    if(FBSession.activeSession.state != FBSessionStateOpen && FBSession.activeSession.state != FBSessionStateOpenTokenExtended) {
        NSLog(@"FBSession not open!");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorLikingPost" object:self];
        return;
    }
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/likes",ID]
                                 parameters:nil
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              FBErrorCategory errorCat = [FBErrorUtility errorCategoryForError:error];
                              if(errorCat) {
                                  NSLog(@"Error liking post: Error category: %d",errorCat);
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorLikingPost" object:self];
                              }
                              else {
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedLikingPost" object:self];
                              }
                          }];
}
+ (void)commentPostWithID:(NSString*)ID andComment:(NSString *)comment {
    [self loginUser];
    if(FBSession.activeSession.state != FBSessionStateOpen && FBSession.activeSession.state != FBSessionStateOpenTokenExtended) {
        NSLog(@"FBSession not open!");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorCommentingPost" object:self];
        return;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            comment, @"message",
                            nil
                            ];
    /* make the API call */
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/comments",ID]
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              FBErrorCategory errorCat = [FBErrorUtility errorCategoryForError:error];
                              if(errorCat) {
                                  NSLog(@"Error liking post: Error category: %d",errorCat);
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorCommentingPost" object:self];
                              }
                              else {
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedCommentingPost" object:self];
                              }
                          }];
}

+ (void)getCurrentUserInfo
{
    [self loginUser];
    if(FBSession.activeSession.state != FBSessionStateOpen && FBSession.activeSession.state != FBSessionStateOpenTokenExtended) {
        NSLog(@"FBSession not open!");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorGettingUserInfo" object:self];
        return;
    }
    [FBRequestConnection
     startForMeWithCompletionHandler: ^(FBRequestConnection *connection, id result, NSError *error) {
         NSMutableDictionary* userDictionary = nil;
         if (!error) {
             userDictionary = [[NSMutableDictionary alloc]initWithDictionary:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedGettingUserInfo" object:self userInfo:userDictionary];
         }
         else {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorGettingUserInfo" object:self];
             return;
         }
     }];
}
@end
