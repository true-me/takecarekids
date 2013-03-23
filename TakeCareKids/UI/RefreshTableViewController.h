//
//  RefreshTableViewController.h
//  TakeCareKids
//
//  Created by Jeffrey Ma on 3/21/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POHorizontalList.h"
#import "BaseViewController.h"
#import "PullRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface RefreshTableViewController : UITableViewController<EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, POHorizontalListDelegate>
{
    NSMutableArray *datasrcArr;
    UITableView *tblView;
    UINib   *cellNib;
    NSNotificationCenter *defaultNotifCenter;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
}

@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray *datasrcArr;
@property (nonatomic, retain) UINib *cellNib;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end
