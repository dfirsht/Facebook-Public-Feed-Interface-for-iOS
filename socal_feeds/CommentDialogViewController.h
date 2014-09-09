//
//  CommentDialogViewController.h
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/30/14.
//
//

#import <UIKit/UIKit.h>

@interface CommentDialogViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property NSString* postID;
@property CommentDialogViewController* selfViewController;
@property (weak, nonatomic) UIActivityIndicatorView* commentActivityIndicator;
@property (weak, nonatomic) UITextField* commentButtonView;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)postButtonPressed:(id)sender;
@end
