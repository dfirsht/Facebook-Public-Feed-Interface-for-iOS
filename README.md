Facebook-Public-Feed-Interface-for-iOS
======================================
This library is designed to create a simple interface for viewing and interacting with the public feed for Facebook pages and apps

The library is split up into two files:

FacebookFeed includes all functions that do not require a user to login, such as pulling all posts from a public wall

FacebookUserInteraction allows users to like and comment on these posts. By using any of these functions, the user will first be prompted to login if they are not already so.

Note: Post and AppInfo are helper classes and should not be directly imported

====================================
Usage:

1. Add all files in the "Facebook Feed Library" folder to your project
2. Add the FacebookSDK to your project, details on how to get this and set it up can be found here: https://developers.facebook.com/docs/ios/getting-started
Note: In order for login to be successful, the - (BOOL)application:openURL:sourceApplication:annotation: method must be overwriten in the AppDelegate (see example).


Thats it!
To get started, you can init a FacebookFeed obj with the initWithAppID:(NSString*)appID appSecret:(NSString*)appSecret pageID:(NSString*)pageID method, filling in your Facebook app id, secret and the page id you want to pull from.
Note: In order for the example app to work, the app id and secret needs to be filled in, in PageFeedTableViewController.m; this was removed for security purposes.

For usage information and method names, check out the example app and class headers.

If you have any questions or comments, you can email me at: dfirsht@umich.edu
