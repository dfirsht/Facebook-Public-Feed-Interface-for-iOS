//
//  DetailViewController.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/29/14.
//
//

#import "DetailViewController.h"
#import "CommentDialogViewController.h"
#import "FacebookFeed.h"
#import "FacebookUserInteraction.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
const double GRAYED_BUTTON_ALPHA_VALUE = 0.7;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // adjust frames for 3.5" screens
    _buttonsView.frame = CGRectOffset(_buttonsView.frame, 0, [UIScreen mainScreen].bounds.size.height - _buttonsView.frame.origin.y - 70);
    _commentsTableView.frame = CGRectMake(_commentsTableView.frame.origin.x, _commentsTableView.frame.origin.y, _commentsTableView.frame.size.width,_buttonsView.frame.origin.y - _commentsTableView.frame.origin.y);
    // fill in post information
    _postMessage.text = [_facebookFeed postMessageForIndex:_postIndex];
    NSData *imageData = [NSData dataWithContentsOfURL:[_facebookFeed postPictureUrlForIndex:_postIndex]];
    _postImage.image =  [UIImage imageWithData:imageData];
    [self printLikes];
    // grab user info to check if previously liked
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookUserInteractionFinishedGettingUserInfo:) name:@"FinishedGettingUserInfo" object:nil];
    _likeButtonView.alpha = GRAYED_BUTTON_ALPHA_VALUE;
    [FacebookUserInteraction getCurrentUserInfo];
    [_likeActivityIndicator startAnimating];
    _likeActivityIndicator.hidesWhenStopped = true;
    _commentActivityIndicator.hidesWhenStopped = true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commentButtonPressed:(id)sender {
    // create and initalize commentDialog
    CommentDialogViewController* commentDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"commentDialog"];
    commentDialogViewController.postID = [_facebookFeed postIDForIndex:_postIndex];
    commentDialogViewController.selfViewController = commentDialogViewController;
    commentDialogViewController.commentActivityIndicator = _commentActivityIndicator;
    commentDialogViewController.commentButtonView = _commentButtonView;
    [self.view addSubview:commentDialogViewController.view];
    // set commentDialog size and position
    commentDialogViewController.view.frame = CGRectMake(0,0,280,400);
    commentDialogViewController.view.frame = CGRectOffset(commentDialogViewController.view.frame, [UIScreen mainScreen].bounds.size.width /2 - commentDialogViewController.view.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height /2 - commentDialogViewController.view.frame.size.height / 2);
    // subscribe to notification sent out by FacebookUserInteraction (the commentDialogController will call the appropriate FacebookUserInteraction method)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookUserInteractionFinishedInteraction:) name:@"FinishedCommentingPost" object:nil];
}

- (IBAction)likeButtonPressed:(id)sender {
    if(_likeButtonView.alpha == 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookUserInteractionFinishedInteraction:) name:@"FinishedLikingPost" object:nil];
        // This function sends out FinishedLikingPost notification after successfully sending the call to like post
        [FacebookUserInteraction likePostWithID:[_facebookFeed postIDForIndex:_postIndex]];
        [_likeActivityIndicator startAnimating];
        _likeActivityIndicator.alpha = GRAYED_BUTTON_ALPHA_VALUE;
    }
}
- (void)facebookUserInteractionFinishedGettingUserInfo:(NSNotification *)notification {
    // [notification userInfo] contains a dictionary with userInfo
    if([self checkIfAlreadyLiked:[notification userInfo]]) {
        _likeButtonView.text = @"Liked";
        _likeButtonView.alpha = GRAYED_BUTTON_ALPHA_VALUE;
    }
    else {
        _likeButtonView.alpha = 1;
    }
    [_likeActivityIndicator stopAnimating];
}
- (void)facebookUserInteractionFinishedInteraction:(NSNotification *)notification {
    // After either liking or commenting, post is reloaded to comfirm change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookFeedFinishedPostRefresh:) name:@"FinishedGettingPost" object:nil];
    [_facebookFeed requestPostInfoWithID:[_facebookFeed postIDForIndex:_postIndex]];
    _commentButtonView.alpha = 1;
}
- (void)facebookFeedFinishedPostRefresh:(NSNotification *)notification {
    [self printLikes];
    [_commentsTableView reloadData];
    [_commentActivityIndicator stopAnimating];
    // after refresh, it is again checked if user has liked post (since user info is not saved, it is fetched again)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookUserInteractionFinishedGettingUserInfo:) name:@"FinishedGettingUserInfo" object:nil];
    [FacebookUserInteraction getCurrentUserInfo];
}
- (void)printLikes {
    NSArray* likes = [_facebookFeed postLikesForIndex:_postIndex];
    _postLikes.text = @"";
    if(likes.count > 1) {
        for (int i = 0; i < likes.count - 2; ++i){
            _postLikes.text = [NSString stringWithFormat:@"%@%@, ", _postLikes.text, [[likes objectAtIndex:i] valueForKey:@"name"]];
        }
        _postLikes.text = [NSString stringWithFormat:@"%@%@ and %@ like this", _postLikes.text, [[likes objectAtIndex:likes.count - 2] valueForKey:@"name"], [[likes objectAtIndex:likes.count - 1] valueForKey:@"name"]];
    }
    else if(likes.count == 1) {
        _postLikes.text = [NSString stringWithFormat:@"%@ likes this", [[likes objectAtIndex:0] valueForKey:@"name"]];
    }
    else {
        _postLikes.text = @"No Likes Yet";
    }
}
- (BOOL)checkIfAlreadyLiked: (NSDictionary*) userInfo {
    NSString* userID = [userInfo valueForKey:@"id"];
    NSArray* likes = [_facebookFeed postLikesForIndex:_postIndex];
    for (NSDictionary* like in likes) {
        if([[like valueForKey:@"id"]isEqualToString:userID]){
            return true;
        }
    }
    return false;
}
#pragma mark - Table managment
// data for comment table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    NSMutableArray* comments = [_facebookFeed postCommentsForIndex:_postIndex];
    // create and set attributedText for bold commenter name
    const CGFloat fontSize = 13;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    NSString* commentName = [[[comments objectAtIndex:indexPath.row]valueForKey:@"from"]valueForKey:@"name"];
    NSString* comment = [NSString stringWithFormat:@"%@ %@",commentName,[[comments objectAtIndex:indexPath.row]valueForKey:@"message"]];
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              boldFont, NSFontAttributeName,nil];
    const NSRange range = NSMakeRange(0,commentName.length);
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:comment
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    // Set it in our UILabel and we are done!
    [cell.textLabel setAttributedText:attributedText];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_facebookFeed postCommentsForIndex:_postIndex].count;
}
@end
