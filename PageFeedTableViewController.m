//
//  PageFeedTableViewController.m
//  facebook_social_feeds
//
//  Created by Daniel Firsht on 7/16/14.
//
//

#import "PageFeedTableViewController.h"
#import "DetailViewController.h"
#import "FacebookFeed.h"

@interface PageFeedTableViewController ()

@end

@implementation PageFeedTableViewController
FacebookFeed* facebookFeed;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_pageID) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookFeedFinishedGettingPosts:) name:@"FinishedGettingPosts" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookFeedFailedLoading:) name:@"ErrorGettingPosts" object:nil];
        facebookFeed = [[FacebookFeed alloc]initWithAppID:@"xxxxxxxxxx" appSecret:@"xxxxxxxxxxxxxxxxxxxx" pageID:_pageID];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) facebookFeedFinishedGettingPosts:(NSNotification*)note {
    self.navigationItem.title = facebookFeed.pageName;
    [self.tableView reloadData];
}
- (void) facebookFeedFailedLoading:(NSNotification*)note {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error loading page's posts"
                          message:@"Check spelling of page ID and make sure the AppID and appSecret are properally set"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [facebookFeed numberOfPosts];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [facebookFeed postMessageForIndex:indexPath.row];
    NSData *imageData = [NSData dataWithContentsOfURL:[facebookFeed postPictureUrlForIndex:indexPath.row]];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    return cell;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ((DetailViewController*)[segue destinationViewController]).postIndex = indexPath.row;
        ((DetailViewController*)[segue destinationViewController]).facebookFeed = facebookFeed;
    }
}


@end
