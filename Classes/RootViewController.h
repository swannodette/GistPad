//
//  RootViewController.h
//  Gist
//
//  Created by David Nolen on 4/14/10.
//  Copyright David Nolen 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCURLRequest.h"

@class DetailViewController;

@interface RootViewController : UITableViewController <LCURLRequestDelegate> {
  DetailViewController *detailViewController;
  NSArray *gists;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSArray *gists;

@end
