//
//  WakeUpListVC.h

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "RegardViewCell.h"
#import "OtherProfileViewController.h"
#import "CustomNavBarVC.h"

@interface WakeUpListVC : UITableViewController  <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, CustomNavgationDelegate,WMParserResultDelegate, EGORefreshTableFooterDelegate>{
	
	EGORefreshTableHeaderView *_refreshHeaderView;

    EGORefreshTableFooterView *_refreshFooterView;

	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *taID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSMutableArray *wkupArr;
@property (nonatomic, retain) WMCenter *center;
@property (nonatomic, retain) WMParserResult *wakeUpParser;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) UIImageView *ima;



- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
