//
//  FacebookFeed.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/16/14.
//
//


#import "FacebookFeed.h"
#import "Post.h"
#import "AppInfo.h"

@interface FacebookFeed ()

@end

@implementation FacebookFeed
AppInfo *appInfo;
NSMutableArray* _posts;
- (id)initWithAppID:(NSString *)appID appSecret:(NSString *)appSecret pageID:(NSString *)pageID {
    if((self = [super init])) {
        appInfo = [[AppInfo alloc]initWithAppID:appID appSecret:appSecret pageID:pageID];
        _posts = [[NSMutableArray alloc]init];
        [self performSelectorInBackground:@selector(getPostsWithAppInfo:) withObject:appInfo];
    }
        return self;
}
- (void) getPostsWithAppInfo:(AppInfo *)appInfo {
    @try {
        NSString *access_token_string = [self getAccessToken:appInfo];
        // get page info
        NSData* responseData = [self sendHTTPRequest:[[NSString stringWithFormat:@"https://graph.facebook.com/%@?access_token=%@",appInfo.pageID,access_token_string] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSError* error = [[NSError alloc]init];
        NSDictionary* appResponse= [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        _pageName = [appResponse valueForKey:@"name"];
        _pageAbout = [appResponse valueForKey:@"about"];
        _pageDescription = [appResponse valueForKey:@"description"];
        _pageLikeCount = [appResponse valueForKey:@"likes"];
        // get page posts
        responseData = [self sendHTTPRequest:[[NSString stringWithFormat:@"https://graph.facebook.com/%@/posts?access_token=%@",appInfo.pageID,access_token_string] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        appResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSMutableArray* posts = [appResponse valueForKey:@"data"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        // date is given in this format by fb
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        // add all posts into _posts array
        for(NSDictionary* post in posts) {
            if([post valueForKey:@"message"]) {
                [_posts addObject:[[Post alloc]initWithID:[post valueForKey:@"id"] message:[post valueForKey:@"message"] pictureURL:[NSURL URLWithString:[post valueForKey:@"picture"]] link:[NSURL URLWithString:[post valueForKey:@"link"]] createTime:[dateFormat dateFromString:[post valueForKey:@"created_time"]]likes:[[post valueForKey:@"likes"]valueForKey:@"data"] comments:[[post valueForKey:@"comments"]valueForKey:@"data"]]];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedGettingPosts" object:self];
    }
    @catch (NSException* exception){
        NSLog(@"Error loading posts:%@",exception);
       [[NSNotificationCenter defaultCenter] postNotificationName:@"ErrorGettingPosts" object:self];
    }
}
- (void)requestPostInfoWithID:(NSString*)ID {
    @try {
        NSString *access_token_string = [self getAccessToken:appInfo];
        // get post info
        NSData* responseData = [self sendHTTPRequest:[[NSString stringWithFormat:@"https://graph.facebook.com/%@?access_token=%@",ID,access_token_string] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSError* error;
        NSDictionary* appResponse = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        // date is given in this format by fb
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        bool found = false;
        // update post if found
        for(Post* post in _posts) {
            if([post.ID isEqualToString:ID]) {
                [post updateWithMessage:[appResponse valueForKey:@"message"] pictureURL:[NSURL URLWithString:[appResponse valueForKey:@"picture"]] link:[NSURL URLWithString:[appResponse valueForKey:@"link"]] createTime:[dateFormat dateFromString:[appResponse valueForKey:@"created_time"]]likes:[[appResponse valueForKey:@"likes"]valueForKey:@"data"] comments:[[appResponse valueForKey:@"comments"]valueForKey:@"data"]];
                found = true;
                break;
            }
        }
        // add new post if not found
        if(!found) {
            [_posts addObject:[[Post alloc]initWithID:[appResponse valueForKey:@"id"] message:[appResponse valueForKey:@"message"] pictureURL:[NSURL URLWithString:[appResponse valueForKey:@"picture"]] link:[NSURL URLWithString:[appResponse valueForKey:@"link"]] createTime:[dateFormat dateFromString:[appResponse valueForKey:@"created_time"]]likes:[[appResponse valueForKey:@"likes"]valueForKey:@"data"] comments:[[appResponse valueForKey:@"comments"]valueForKey:@"data"]]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishedGettingPost" object:self];
    }
    @catch (NSException* exception){
        NSLog(@"Error loading posts:%@",exception);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FailedToGetPost" object:self];
    }
    
}
- (void)refreshAllPostInfo {
    for (Post* post in _posts) {
        [self performSelectorInBackground:@selector(requestPostInfoWithID:) withObject:post.ID];
    }
}
- (NSInteger) numberOfPosts {
    return _posts.count;
}
- (NSString*)postIDForIndex:(NSInteger)index {
    return ((Post*)[_posts objectAtIndex:index]).ID;
}
- (NSString*) postMessageForIndex:(NSInteger)index {
    return ((Post*)[_posts objectAtIndex:index]).message;
}
- (NSURL*)postPictureUrlForIndex:(NSInteger)index {
    return ((Post*)[_posts objectAtIndex:index]).pictureURL;
}
- (NSURL*)postLinkUrlForIndex:(NSInteger)index {
    return ((Post*)[_posts objectAtIndex:index]).link;
}
- (NSDate*)postCreateTimeForIndex:(NSInteger)index {
    return ((Post*)[_posts objectAtIndex:index]).createTime;
}
- (NSMutableArray*)postLikesForIndex:(NSInteger)index {
    return ((Post*)[_posts objectAtIndex:index]).likes;
}
- (NSMutableArray*)postCommentsForIndex:(NSInteger)index {
    return ((Post*)[_posts objectAtIndex:index]).comments;
}
- (NSString*)getAccessToken:(AppInfo *) appInfo {
    NSData* responseData = [self sendHTTPRequest:[NSString stringWithFormat:@"https://graph.facebook.com/oauth/access_token?client_id=%@&client_secret=%@&grant_type=client_credentials",appInfo.appID,appInfo.appSecret]];
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSRange access_token_range = [responseString rangeOfString:@"access_token="];
    if (access_token_range.length == 0) {
        [NSException raise:@"Loading of Posts Failed" format:@"Error Unable to find access_token in string: %@", responseString];
    }
    int from_index = access_token_range.location + access_token_range.length;
    return [responseString substringFromIndex:from_index];
}
- (NSData*)sendHTTPRequest: (NSString*)address {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:address]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSException* exception = [[NSException alloc]initWithName: @"HTTPRequest failed" reason:[NSString stringWithFormat: @"Request for %@ recieved error HTTP status code %i", address, [responseCode statusCode]] userInfo:nil];
        @throw exception;
    }
    return oResponseData;
}
@end
