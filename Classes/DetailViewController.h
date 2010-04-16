//
//  DetailViewController.h
//  Gist
//
//  Created by David Nolen on 4/14/10.
//  Copyright David Nolen 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate> {
  
  UIPopoverController *popoverController;
  UIToolbar *toolbar;
  
  id detailItem;
  UILabel *detailDescriptionLabel;
  
  UIWebView *webView;
  
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (void)showGist:(NSNumber *)gistId;
- (IBAction)edit;

@end
