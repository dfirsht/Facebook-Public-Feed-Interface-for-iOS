//
//  ViewController.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/16/14.
//
//

#import "InputViewController.h"
#import "PageFeedTableViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestPageFeed:(id)sender {
    [self performSegueWithIdentifier:@"feedSegue" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(PageFeedTableViewController*)segue.destinationViewController setPageID:_idTextField.text];
}
@end
