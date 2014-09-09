//
//  Post.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/17/14.
//
//

#import "Post.h"

@implementation Post
- (id)initWithID:(NSString *)ID message:(NSString *)message pictureURL:(NSURL *)pictureURL link:(NSURL *)link createTime:(NSDate *)createTime likes:(NSMutableArray *)likes comments:(NSMutableArray *)comments
{
    if((self = [super init]))
    {
        _ID = ID;
        _message = message;
        _pictureURL = pictureURL;
        _link = link;
        _createTime = createTime;
        _likes = likes;
        _comments = comments;
    }
    return self;
}
- (void)updateWithMessage:(NSString *)message pictureURL:(NSURL *)pictureURL link:(NSURL *)link createTime:(NSDate *)createTime likes:(NSMutableArray *)likes comments:(NSMutableArray *)comments
{
    _message = message;
    _pictureURL = pictureURL;
    _link = link;
    _createTime = createTime;
    _likes = likes;
    _comments = comments;
}
@end
