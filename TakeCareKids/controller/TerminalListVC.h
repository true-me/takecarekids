//
//  TerminalListVC.h

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "BaseViewController.h"
#import "TerminalCell.h"
#import "CustomNavBarVC.h"
#import "Terminal.h"

@interface TerminalListVC : UITableViewController  <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource, EGORefreshTableFooterDelegate, MBProgressHUDDelegate>{
	
	EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;

	BOOL _reloading;
}
@property (nonatomic, retain) UITableView *tbl;
@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) NSString *taID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) UIImageView *ima;
@property(nonatomic, retain) MessageRouter *msgRouter;




- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
