//
//  TerminalListVC.m
//  TableViewPull

#import "TerminalListVC.h"

@implementation TerminalListVC
@synthesize titleStr = _titleStr;
@synthesize taID = _taID;
@synthesize type = _type;
@synthesize dataArr = _dataArr;
@synthesize pageSize = _pageSize;
@synthesize pageNo = _pageNo;
@synthesize tbl = _tbl;
@synthesize msgRouter = _msgRouter;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.msgRouter = [MessageRouter getInstance];
    self.view.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:223/255.0f green:225/255.0f blue:225/255.0f alpha:1];
    CustomNavBarVC *navc= (CustomNavBarVC *)self.navigationController;
    [navc leftButtonWithImage:[UIImage imageNamed:@"topbar_menu.png"] withSelector:@selector(LeftButtonPress:) onTarget:self];
    
    [navc setupTitle:@"亲情号码"];

    self.pageNo = 1;
    self.pageSize = 10;
    self.dataArr = [[NSMutableArray alloc] init];

    self.tableView.backgroundColor = [UIColor colorWithRed:215/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
	if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];

    [self reloadTableViewDataSource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TerminalCell";
    
    TerminalCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[TerminalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
	// Configure the cell.
    NSDictionary *user = [self.dataArr objectAtIndex:indexPath.row];
    
    if ([DataCheck isValidString:[NSString stringWithFormat:@"%@", [user objectForKey:@"name"]]])
    {
        cell.lblName.text = [NSString stringWithFormat:@"%@", [user objectForKey:@"name"]];
    }
    
    if ([DataCheck isValidString:[NSString stringWithFormat:@"%@", [user objectForKey:@"id"]]])
    {
        cell.lblId.text = [NSString stringWithFormat:@"%@", [user objectForKey:@"id"]];
    }
    
    if ([DataCheck isValidString:[NSString stringWithFormat:@"%@", [user objectForKey:@"num"]]])
    {
        cell.lblNum.text = [NSString stringWithFormat:@"%@", [user objectForKey:@"num"]];
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//	
//	return [NSString stringWithFormat:@"Section %i", section];
//	
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    OtherProfileViewController *otherProfile = [[OtherProfileViewController alloc] init];
//    otherProfile.userId = [[arr objectAtIndex:indexPath.row] objectForKey:@"taId"];
//    [self.navigationController pushViewController:otherProfile animated:YES];
//    [otherProfile release];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    self.pageNo = 1;
	[self getTerminalList];
}

- (void)moreTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    self.pageNo++;
	[self getTerminalList];
}

- (void)showPlaceHolder
{
    if (self.tableView.tableHeaderView)
    {
        self.tableView.tableHeaderView = nil;
    }

    UIImageView *placeholder = [[UIImageView alloc] initWithFrame:self.tableView.frame];
    [placeholder setContentMode:UIViewContentModeCenter];
    [placeholder setImage:[UIImage imageNamed:@"null_pattern.png"]];
    self.tableView.tableHeaderView = placeholder;
    [placeholder release];
}
- (void)hidePlaceHolder
{
    if (self.tableView.tableHeaderView)
    {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [self.tableView reloadData];    
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    if ([self.dataArr count] == 0)
    {
        [self showPlaceHolder];
    }
    else
    {
        [self hidePlaceHolder];
    }
}

- (void)doneLoadingMoreTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [self.tableView reloadData];
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:[self.dataArr count]-1];
//    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	[_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    [self removeFooterView];

//    CGRect frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
//    [_refreshFooterView setFrame:frame];
    
    if ([self.dataArr count] == 0)
    {
        [self showPlaceHolder];
    }
    else
    {
        [self hidePlaceHolder];
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if ([self isScrollToBottom:scrollView])
    {
//        if (!_refreshFooterView)
//        {
            [self setFooterView];
//        }
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if ([self isScrollToBottom:scrollView])
    {
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
    [_titleStr release];
    [_taID release];
    [_dataArr release];
    [super dealloc];
}

#pragma mark - NavButtonFunction
- (void)LeftButtonPress:(id)sender
{
    if ([self isEqual:self.navigationController.topViewController] && [self.navigationController.viewControllers count] == 1)
{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)RightButtonPress:(id)sender
{
    
    
}

#pragma mark - RequestFunction
- (void)getTerminalList
{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"正在加载";
    [HUD show:YES];
	
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];

    [_msgRouter getTerminalListWithUid:uid password:pwd
                             delegate:self
                             selector:@selector(getTerminalListSuccess:)
                        errorSelector:@selector(getTerminalListError:)];
 }

#pragma mark - NetworkDelegate
#pragma mark Recive data
#pragma mark - private

- (void)getTerminalListSuccess:(NSDictionary *)response
{
    NSLog(@"%s=%@", __PRETTY_FUNCTION__, response);
    NSInteger result = [[response objectForKey:@"rst"] intValue];
    if (result == 0)
    {
        NSArray * tms = [response objectForKey:@"tms"];
        if ([DataCheck isValidArray:tms])
        {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:tms];
            [self saveTodb:tms];
        }
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        if (hud)
        {
            hud.labelText = @"完成！";
            [hud hide:YES afterDelay:0.5f];
        }
        
        [self performSelectorOnMainThread:@selector(doneLoadingMoreTableViewData) withObject:nil waitUntilDone:YES];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        if (hud)
        {
            hud.labelText = @"请求数据失败！";
            [hud hide:YES afterDelay:0.5f];
        }
    }
}


- (void)getTerminalListError:(NSDictionary *)errorInfo
{
    DLog(@"errorInfo=%@", errorInfo);
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    if (hud)
    {
        hud.labelText = @"请求数据失败！";
        [hud hide:YES afterDelay:0.5f];
    }
}

-(void) saveTodb:(NSArray *) arr
{
    for (NSDictionary *dictOne in arr)
    {
        NSMutableDictionary *dicModel = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (NSString *key in dictOne.allKeys)
        {
            NSString *newKey = [NSString stringWithFormat:@"tm%@", key];
            NSString *value = [dictOne objectForKey:key];
            [dicModel setObject:value forKey:newKey];
        }
        
        Terminal *modelOne = [Terminal objectWithProperties:dicModel];
        [modelOne setToDB];
        [dicModel release];
    }
}

#pragma mark -
#pragma mark EGORefreshTableFooterDelegate Methods
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self moreTableViewDataSource];

}
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _reloading; // should return if data source model is reloading

}
- (NSDate*)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView*)view
{
    return [NSDate date];
}

#pragma mark-==============================上拉  下拉  刷新  ======================
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview])
    {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview])
    {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView
{

    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.tableView.bounds.size.height);
    }
    else
    {
        // create the footerView
        EGORefreshTableFooterView *view = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.view addSubview:view];
        _refreshFooterView = view;
        [view release];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView setHidden:NO];
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView setHidden:YES];
//        [_refreshFooterView removeFromSuperview];
    }
//    _refreshFooterView = nil;
}
-(BOOL) isScrollToBottom:(UIScrollView *) scrollView
{
    BOOL ret =NO;
    CGPoint contentOffsetPoint = scrollView.contentOffset;
    CGRect frame = scrollView.frame;
    if (contentOffsetPoint.y >= scrollView.contentSize.height - frame.size.height || scrollView.contentSize.height < frame.size.height)
    {
        ret = YES;
    }
    return ret;
}

- (void)launchRefreshing {
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:.18f animations:^{
        self.tableView.contentOffset = CGPointMake(0, -60.f-1);
    } completion:^(BOOL bl){
        [self tableViewDidEndDragging:self.tableView];
    }];
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView {
//    
//    //    CGPoint offset = scrollView.contentOffset;
//    //    CGSize size = scrollView.frame.size;
//    //    CGSize contentSize = scrollView.contentSize;
//    if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading) {
//        return;
//    }
//    if (_headerView.state == kPRStatePulling) {
//        //    if (offset.y < -kPROffsetY) {
//        if (!self.headerEnable) {
//            return;
//        }
//        _isFooterInAction = NO;
//        _headerView.state = kPRStateLoading;
//        
//        [UIView animateWithDuration:kPRAnimationDuration animations:^{
//            self.contentInset = UIEdgeInsetsMake(kPROffsetY, 0, 0, 0);
//        }];
//        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
//            [_pullingDelegate pullingTableViewDidStartRefreshing:self];
//        }
//    } else if (_footerView.state == kPRStatePulling) {
//        //    } else  if (offset.y + size.height - contentSize.height > kPROffsetY){
//        if (self.reachedTheEnd || !self.footerEnable) {
//            return;
//        }
//        _isFooterInAction = YES;
//        _footerView.state = kPRStateLoading;
//        [UIView animateWithDuration:kPRAnimationDuration animations:^{
//            self.contentInset = UIEdgeInsetsMake(0, 0, kPROffsetY, 0);
//        }];
//        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
//            [_pullingDelegate pullingTableViewDidStartLoading:self];
//        }
//    }
}


@end

