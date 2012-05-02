# ASPullToRefresh

## A simple UITableViewController for adding "Pull-to-Refresh" functionality.

### Features:

1. Works with Synchronous and Asyncrhonous calls
1. Works with custom UITableViewDataSources and custom UITableViewDelegates
1. Compatible with iOS 4 and iOS 5
1. Compatible with iPhone and iPad
1. Compatible with all device/interface orientations

### Installation Instruction:

1. Copy the 'ASPullToRefresh' folder into your Xcode project. The following files will be added:
	1. ASPullToRefreshTableViewController.h
	1. ASPullToRefreshTableViewController.m
	1. pullToRefreshArrow.png 
1. Link against the QuartzCore framework (used for rotating the arrow image).
1. Create a UITableViewController that is a subclass of ASPullToRefreshTableViewController.
1. Customize your subclassed UITableViewController by adding the following method:

<pre> /// FOR SYNCHRONOUS CALLS ///

/// GENERAL ///
/*
 
 Add the following message to your Table ViewController's 'shouldAutorotateToInterfaceOrientation' method.
 
 [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishRefreshing object:nil];
 
 */


/// FOR SYNCHRONOUS CALLS ///

/* 
 In your subclassed ASPullToRefreshTableViewController, call the following method:
 
 - (void)dataToRefresh
 {
    // Object to refresh goes here
 
    // For synchronous calls, post the following notification before exiting this method: 
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishRefreshing object:nil];
 }
 
*/

/// FOR ASYNCHRONOUS CALLS ///

/* 
 In your subclassed ASPullToRefreshTableViewController, call the following method:
 
 - (void)dataToRefresh
 {
    // Object to refresh goes here
 }
 
 Then, call 
 
 [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishRefreshing object:nil]; 
 
 in the success/failure delegate methods
 
*/
</pre>


### Inspired by:
- [Tweetie 2](http://www.atebits.com/tweetie-iphone/)
- [Oliver Drobnik's blog post](http://www.drobnik.com/touch/2009/12/how-to-make-a-pull-to-reload-tableview-just-like-tweetie-2/)
- [EGOTableViewPullRefresh](http://github.com/enormego/EGOTableViewPullRefresh).  

### Forked from:
- [Leah Culver's PullToRefresh](https://github.com/leah/PullToRefresh/)  

###  Release Notes (v1.3.1):
- Removed observer for Interface Orientation Change
- Removed unnecessary tableView reload

###  Previous Release Notes:

#### v1.3.0:
- More abstraction to code to 
	- supprt iPad displays
	- support retina displays
	- device orientaiton changes
- Improved Documentation

####  v1.2.2:
- Re-added support for iOS 4.3
- Modified orientation detection methods
- Retained text from refreshTimeStampLabel's text property


####  v1.2.1:
- Removed public access to dataToRefresh method
- Minor code tweaks

####  v1.2.0:
- Added support for 'LandscapeLeft', 'LandscapeRight', and 'PortraitUpsideDown' orientations
- Add observers for call to didFinishRefreshing
- Changed name of arrow to pullToRefreshArrow
- Added more documentation


####  v1.1.0:
- Renamed all methods for clarity
- Added support for asynchronous calls
	- Exposed two methods to achieve this; dataToRefresh &amp; didFinishRefreshing.
- Added more documentation

#### v1.0.1
- Added more comments
- Removal of a couple lines of unnecessary code

#### v1.0.0 
- Forked from [Leah Culver's PullToRefresh](https://github.com/leah/PullToRefresh/) 
- Added Auto Reference Counting 
- Removed setupStrings method in favor of macros
- Encapsulated existing PullRefreshTableViewController, and renamed it to ASPullToRefreshTableViewController
- Added Refresh Timestamp
- Removed unncessary UITableView-related code
- Improved readability


###  Other Notes:
- If loading local or static data, the PullToRefresh view will fly up in an instance
- If loading remote data (i.e., from an API), the PullToRefresh view will be visible until all data has been retrieved from your remote data source.

Best,

[Arthur Ariel Sabintsev](http://www.sabintsev.com)  