//
//  FacebookFeed.h
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/16/14.
//
//

// This class pulls all posts for a given page (or app page) and stores it in the posts array
// Note that this class does not use the FacebookSDK.framework but instead directly queries the Facebook API (https://graph.facebook.com/)
// All methods in this class do not require a user to be logged in
// In order to use this class in a project, include this class plus the helper classes: Post and AppInfo

#import <Foundation/Foundation.h>


@interface FacebookFeed : NSObject
@property NSString* pageName;
@property NSString* pageAbout;
@property NSString* pageDescription;
@property NSString* pageLikeCount;
// This init sends out the notification "FinishedGettingPosts" when loading is complete, to subscribe to this notification use the [[NSNotificationCenter defaultCenter] addObserver: selector: name:@"FinishedGettingPosts" object:] method.
// If the posts fail to load, it will send out the notification "ErrorGettingPosts"
- (id)initWithAppID:(NSString*)appID appSecret:(NSString*)appSecret pageID:(NSString*)pageID;
// Sends notification "FinishedGettingPost" on success, "ErrorGettingPost" on failure
- (void)requestPostInfoWithID:(NSString*)ID;
- (void)refreshAllPostInfo;
- (NSInteger) numberOfPosts;
// Returns information on posts by their index position in _posts array. This index is guaranteed not to change
- (NSString*)postIDForIndex:(NSInteger)index;
- (NSString*)postMessageForIndex:(NSInteger)index;
- (NSURL*)postPictureUrlForIndex:(NSInteger)index;
- (NSURL*)postLinkUrlForIndex:(NSInteger)index;
- (NSDate*)postCreateTimeForIndex:(NSInteger)index;
- (NSMutableArray*)postLikesForIndex:(NSInteger)index;
- (NSMutableArray*)postCommentsForIndex:(NSInteger)index;
@end
