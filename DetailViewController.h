//
//  DetailViewController.h
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/29/14.
//
//

#import <UIKit/UIKit.h>
#import "FacebookFeed.h"

@interface DetailViewController : UIViewController <UITableViewDataSource>

@property NSInteger postIndex;
@property FacebookFeed* facebookFeed;

@property (weak, nonatomic) IBOutlet UITextView *postMessage;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextView *postLikes;
@property (weak, nonatomic) IBOutlet UITextField *likeButtonView;
@property (weak, nonatomic) IBOutlet UITextField *commentButtonView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *likeActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *commentActivityIndicator;


- (IBAction)commentButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;
@end
