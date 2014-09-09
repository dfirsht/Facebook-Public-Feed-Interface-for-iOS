//
//  Post.h
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/17/14.
//
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
@property NSString* ID;
@property NSString* message;
@property NSURL* pictureURL;
@property NSURL* link;
@property NSDate* createTime;
@property NSMutableArray* likes;
@property NSMutableArray* comments;
- (id)initWithID:(NSString*)ID message:(NSString*)message pictureURL:(NSURL*)pictureURL link:(NSURL*)link createTime:(NSDate*)createTime likes:(NSMutableArray*)likes comments:(NSMutableArray*)comments;
- (void)updateWithMessage:(NSString*)message pictureURL:(NSURL*)pictureURL link:(NSURL*)link createTime:(NSDate*)createTime likes:(NSMutableArray*)likes comments:(NSMutableArray*)comments;
@end
