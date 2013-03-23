//
//  TableDemoViewController.h
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
@interface TableDemoViewController : PullRefreshTableViewController<UITableViewDelegate, UITableViewDataSource, POHorizontalListDelegate, EGORefreshTableHeaderDelegate> {
    NSMutableArray *itemArray;
    
    NSMutableArray *freeList;
    NSMutableArray *paidList;
    NSMutableArray *grossingList;
    UITableView *tblView;
    
    NSNotificationCenter *defaultNotifCenter;
    UINib   *cellNib;
    NSMutableArray      *statuesArr;
    NSMutableDictionary *headDictionary;
    NSMutableDictionary *imageDictionary;
//    ImageBrowser        *browserView;
    
    BOOL                shouldShowIndicator;
    BOOL                shouldLoad;
    
    BOOL                isFirstCell;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic, retain) NSMutableArray *freeList;
@property (nonatomic, retain) NSMutableArray *paidList;
@property (nonatomic, retain) NSMutableArray *grossingList;

@property (nonatomic, retain)   UINib                   *cellNib;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   NSMutableDictionary     *headDictionary;
@property (nonatomic, retain)   NSMutableDictionary     *imageDictionary;


- (void) doneLoadingTableViewData;
- (void) refreshVisibleCellsImages;

//- (void) setUpTitleView:(NSString*) title;
//- (void) setUpSecondTitleView:(NSString*) title;
//- (void) didTapBackButton:(id)sender;
//- (void) clickNowPlayingButton:(id)sender;
//- (void) setUpTitleImageView:(NSString *)imageName;
//- (void) setUpRightButton:(UIButton*) button;
//- (void) setUpLeftButton:(UIButton *) button;

@end
