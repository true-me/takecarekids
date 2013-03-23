//
//  HomeRefreshableViewController.h
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
#import "SHKActivityIndicator.h"
#import "LPBaseCell.h"
#import "DesireCell.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "MessageManager.h"

@interface HomeRefreshableViewController : PullRefreshTableViewController<UITableViewDelegate, UITableViewDataSource, POHorizontalListDelegate, EGORefreshTableHeaderDelegate, DesireCellDelegate>
{
    NSMutableArray *datasrcArr;
    UITableView *tblView;
    UINib   *cellNib;    
    NSNotificationCenter *defaultNotifCenter;
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    
    BOOL shouldLoad;
    ASINetworkQueue *requestQueue;
    MessageManager *manager;
    
    BOOL isFirstCell;
    int _page;
    long long _maxID;
    BOOL _shouldAppendTheDataArr;
}

@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray *datasrcArr;
@property (nonatomic, retain) UINib *cellNib;
@property (nonatomic, retain) ASINetworkQueue *requestQueue;


- (void) reloadTableViewDataSource;
- (void) doneLoadingTableViewData;
@end
