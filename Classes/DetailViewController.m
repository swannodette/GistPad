//
//  DetailViewController.m
//  Gist
//
//  Created by David Nolen on 4/14/10.
//  Copyright David Nolen 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "LCCategories.h"
#import "JSON.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
- (void)showGist:(NSNumber *)gistId;
@end


@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, webView;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem 
{
  NSLog(@"set detail item %@", newDetailItem);
  if (detailItem != newDetailItem) {
    [detailItem release];
    detailItem = [newDetailItem retain];
    
    NSLog(@"%@", detailItem);
    
    // Update the view.
    [self configureView];
  }
  
  if (popoverController != nil) {
    [popoverController dismissPopoverAnimated:YES];
  }        
}


- (void)configureView 
{
  [self showGist:self.detailItem];
}


- (IBAction)edit
{
  NSLog(@"edit");
  // get the path to the latest revision of the gist
  NSString *script = @" \
  var metas = document.querySelectorAll('.gist-meta'); \
  var result = []; \
  for(var i = 0; i < metas.length; i++) { \
    meta = metas[i]; \
    result.push({ \
      'raw': meta.getElementsByTagName('a')[0].href \
    }); \
  } \
  JSON.stringify(result); \
  ";
  NSArray *rawUrls = [[self.webView stringByEvaluatingJavaScriptFromString:(NSString *)script] JSONValue];
  [[LCURLRequest alloc] initWithURL:[[rawUrls objectAtIndex:0] objectForKey:@"raw"] 
                           delegate:self];
}

#pragma mark -
#pragma mark LCURLRequestDelegate methods

- (void) requestDidFinishLoading:(LCURLRequest*)request
{
  NSString *code = [request response];
  [request autorelease];
}

- (void) request:(LCURLRequest*)request didFailWithError:(NSError*)error
{
  NSLog(@"request:%@ didFailWithError:%@", request, error);
  [request autorelease];
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
  
  barButtonItem.title = @"Root List";
  NSMutableArray *items = [[toolbar items] mutableCopy];
  [items insertObject:barButtonItem atIndex:0];
  [toolbar setItems:items animated:YES];
  [items release];
  self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  NSMutableArray *items = [[toolbar items] mutableCopy];
  [items removeObjectAtIndex:0];
  [toolbar setItems:items animated:YES];
  [items release];
  self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [self showGist:[NSNumber numberWithInt:364328]];
}

- (void)showGist:(NSNumber *)gistId
{
  NSString *gist = @"<html><body><script src=\"http://gist.github.com/{id}.js\"></script></body></html>";
  NSDictionary *d = [NSDictionary dictionaryWithObject:gistId forKey:@"id"];
  [self.webView loadHTMLString:[gist template:d] baseURL:nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  self.popoverController = nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate methods

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
  NSLog(@"webViewDidFinishLoad:%@", aWebView);
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
}

#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
  [popoverController release];
  [toolbar release];
  
  [detailItem release];
  [detailDescriptionLabel release];
  [super dealloc];
}

@end
