//
//  HomeRefreshableViewController.m
//  TakeCareKids
//
//  Created by Jeffrey Ma on 3/21/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "HomeRefreshableViewController.h"

@interface HomeRefreshableViewController ()

@end

@implementation HomeRefreshableViewController
@synthesize datasrcArr;
@synthesize tblView;
@synthesize cellNib;
@synthesize requestQueue;

-(void)dealloc
{
    self.cellNib = nil;
    self.tblView = nil;
    self.datasrcArr = nil;
    self.requestQueue = nil;
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}
-(void)setup
{
    //init data
    isFirstCell = YES;
    shouldLoad = NO;
//    shouldShowIndicator = YES;
    manager = [MessageManager getInstance];
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    
    refreshFooterView.hidden = NO;
    _page = 1;
    _maxID = -1;
    _shouldAppendTheDataArr = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpRefreshView];
    shouldLoad = YES;
    [defaultNotifCenter addObserver:self selector:@selector(didGetHomeLine:) name:MMGotHomeLine object:nil];
}


-(void)viewDidUnload
{

    [defaultNotifCenter removeObserver:self name:MMGotHomeLine object:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (shouldLoad)
    {
        shouldLoad = NO;
        [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
        
        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
        //        [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (datasrcArr != nil && datasrcArr.count != 0)
    {
        return;
    }
//    //如果未授权，则调入授权页面。

//    
//    // 如果未登录，先显示登录界面
//    BOOL bHasLogin = NO;
//    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
//    if (authToken == nil || [manager isNeedToRefreshTheToken])
//    {
//        shouldLoad = YES;
//        LoginController *loginVC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
//        loginVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:loginVC animated:NO];
//        [loginVC release];
//    }
//    else
//    {
//        [self getDataFromCD];
//        
//        if (!statuesArr || statuesArr.count == 0) {
//            [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
//            [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
//        }
//        
//        [manager getUserID];
//        [manager getHOtTrendsDaily];
//    }
//    
//    // 原有登录验证
//    //    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_ACCESS_TOKEN];
//    //    NSLog([manager isNeedToRefreshTheToken] == YES ? @"need to login":@"did login");
//    //    if (authToken == nil || [manager isNeedToRefreshTheToken])
//    //    {
//    //        shouldLoad = YES;
//    //        OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
//    //        webV.hidesBottomBarWhenPushed = YES;
//    //        [self.navigationController pushViewController:webV animated:NO];
//    //        [webV release];
//    //    }
//    //    else
//    //    {
//    //        [self getDataFromCD];
//    //
//    //        if (!statuesArr || statuesArr.count == 0) {
//    //            [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
//    //            [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
//    //        }
//    //
//    //        [manager getUserID];
//    //        [manager getHOtTrendsDaily];
//    //    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = [view retain];
		[view release];
		
        [refreshFooterView setHidden:NO];
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    
}

-(void)reloadTableViewDataSource
{
    NSLog(@"==开始加载数据");
    [self.tableView reloadData];
    _reloading = YES;
    
}
- (void)doneLoadingTableViewData{
    
    NSLog(@"===加载完数据");
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    
}
#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if (scrollView.contentOffset.y < 200) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else
        [super scrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
    if (!decelerate)
	{
        //[self refreshVisibleCellsImages];
    }
    
    if (scrollView.contentOffset.y < 200)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
//    [self reloadTableViewDataSource];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    _reloading = YES;
	[manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    _shouldAppendTheDataArr = NO;
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading; // should return if data source model is reloading
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - Tableview delegate
#pragma mark
- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //_refreshHeaderView.frame = CGRectMake(0, 10 * 50, 320, 480);
    if (datasrcArr)
    {
        return datasrcArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  row = indexPath.row;
    DesireCell *cell = [self cellForTableView:tableView fromNib:self.cellNib];
    //cell.contentTF.text = [NSString stringWithFormat:@"%d-%@", row, @"majunfei"];
    if (row >= [datasrcArr count]) {
        return cell;
    }
    
    Group *groupOne = [datasrcArr objectAtIndex:row];
    groupOne.cellIndexPath = indexPath;
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    [cell updateCellTextWith:groupOne WithTableViewDelegate:self];
    
    if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
    {
//        if (status.user.avatarImage == nil)
//        {
//            [[HHNetDataCacheManager getInstance] getDataWithURL:status.user.profileImageUrl withIndex:row];
//        }
//        
//        if (status.statusImage == nil)
//        {
//            [[HHNetDataCacheManager getInstance] getDataWithURL:status.thumbnailPic withIndex:row];
//            [[HHNetDataCacheManager getInstance] getDataWithURL:status.retweetedStatus.thumbnailPic withIndex:row];
//        }
    }
//    cell.avatarImage.image = status.user.avatarImage;
//    cell.contentImage.image = status.statusImage;
//    cell.retwitterContentImage.image = status.statusImage;
    
    //开始绘制第一个cell时，隐藏indecator.
    if (isFirstCell)
    {
        [[SHKActivityIndicator currentIndicator] hide];
        //        [[ZJTStatusBarAlertWindow getInstance] hide];
        isFirstCell = NO;
    }
    return cell;
}

//#pragma mark  POHorizontalListDelegate
//
//- (void) didSelectItem:(ListItem *)item {
//    NSLog(@"Horizontal List Item %@ selected", item.imageTitle);
//}


//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    //    //    UIFont * font=[UIFont  systemFontOfSize:15];
    //    //    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
    //    //    CGFloat height = size.height + 44;
    //    CGFloat height = [DesireCell getJSHeight:contentText jsViewWith:with];
    //    return height;
    return 60;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib
{
    static NSString *cellID = @"DesireCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else
    {
        [(LPBaseCell *) cell reset];
    }
    
    return cell;
}

#pragma mark - 下拉刷新
-(UINib*)cellNib
{
    if (cellNib == nil)
    {
        [cellNib release];
        cellNib = [[DesireCell nib] retain];
    }
    return cellNib;
}

-(void)didGetHomeLine:(NSNotification*)sender
{
    if ([sender.object count] == 1) {
        NSDictionary *dic = [sender.object objectAtIndex:0];
        NSString *error = [dic objectForKey:@"error"];
        if (error && ![error isEqual:[NSNull null]]) {
            if ([error isEqualToString:@"expired_token"])
            {
                [[SHKActivityIndicator currentIndicator] hide];
                //                [[ZJTStatusBarAlertWindow getInstance] hide];
                shouldLoad = YES;
//                OAuthWebView *webV = [[OAuthWebView alloc]initWithNibName:@"OAuthWebView" bundle:nil];
//                webV.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:webV animated:NO];
//                [webV release];
            }
            return;
        }
    }
    
    [self stopLoading];
    [self doneLoadingTableViewData];
    
    if (datasrcArr == nil || _shouldAppendTheDataArr == NO /*|| _maxID < 0*/)
    {
        self.datasrcArr = sender.object;
//        Status *sts = [statuesArr objectAtIndex:0];
//        _maxID = sts.statusId;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:_maxID] forKey:@"homePageMaxID"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        _page = 1;
    }
    else
    {
        [datasrcArr addObjectsFromArray:sender.object];
    }
//    _page++;

    refreshFooterView.hidden = NO;
    [self.tableView reloadData];
    [[SHKActivityIndicator currentIndicator] hide];
//    [self refreshVisibleCellsImages];
    
//    if (timer == nil) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerOnActive) userInfo:nil repeats:YES];
//    }
}


//上拉
-(void)refresh
{
    [manager getHomeLine:-1 maxID:_maxID count:-1 page:_page baseApp:-1 feature:-1];
    _shouldAppendTheDataArr = YES;
}

- (void) setupListItem
{
//    ListItem *item1 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"Weather"];
//    ListItem *item2 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Shopping"];
//    ListItem *item3 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"E-Trade"];
//    ListItem *item4 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"Voice Recorder"];
//    ListItem *item5 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"News Reader"];
//    ListItem *item6 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"10_64x64.png"] text:@"Game Pack"];
//    ListItem *item7 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Movies"];
//    ListItem *item8 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"12_64x64.png"] text:@"Forecast"];
//    ListItem *item9 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"10_64x64.png"] text:@"Game Pack"];
//    ListItem *item10= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Movies"];
//    ListItem *item11= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"News Reader"];
//    ListItem *item12= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"Voice Recorder"];
//    ListItem *item13= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"E-Trade"];
//    ListItem *item14= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Shopping"];
//    ListItem *item15= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"Weather"];
//    
//    freeList = [[NSMutableArray alloc] initWithObjects: item1, item2, item3, item4, item5, nil];
//    paidList = [[NSMutableArray alloc] initWithObjects: item6, item7, item8, item9, item10, nil];
//    grossingList = [[NSMutableArray alloc] initWithObjects: item11, item12, item13, item14, item15, nil];
//    
//    [item1 release];
//    [item2 release];
//    [item3 release];
//    [item4 release];
//    [item5 release];
//    [item6 release];
//    [item7 release];
//    [item8 release];
//    [item9 release];
//    [item10 release];
//    [item11 release];
//    [item12 release];
//    [item13 release];
//    [item14 release];
//    [item15 release];
}
@end
