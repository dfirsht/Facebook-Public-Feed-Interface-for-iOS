//
//  ViewController.h
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/16/14.
//
//

#import <UIKit/UIKit.h>

@interface InputViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
- (IBAction)requestPageFeed:(id)sender;

@end
