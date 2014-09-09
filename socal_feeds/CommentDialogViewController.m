
//
//  CommentDialogViewController.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/30/14.
//
//

#import "CommentDialogViewController.h"
#import "FacebookUserInteraction.h"

@implementation CommentDialogViewController
- (void)viewDidLoad {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialogTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [_commentTextView addGestureRecognizer:singleTap];
}
- (IBAction)cancelButtonPressed:(id)sender {
    [_selfViewController.view removeFromSuperview];
}

- (IBAction)postButtonPressed:(id)sender {
    [FacebookUserInteraction commentPostWithID:_postID andComment:_commentTextView.text];
    [_commentActivityIndicator startAnimating];
    _commentButtonView.alpha = .7;
    [_selfViewController.view removeFromSuperview];
}
- (void)dialogTapped:(id)sender {
    static bool keyboardVisable = false;
    if(keyboardVisable) {
        [_commentTextView resignFirstResponder];
        keyboardVisable = false;
    }
    else {
        [_commentTextView becomeFirstResponder];
        keyboardVisable = true;
    }
}
@end
