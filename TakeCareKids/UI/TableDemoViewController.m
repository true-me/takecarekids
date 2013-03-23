//
//  TableDemoViewController.m
//  TakeCareKids
//
//  Created by Jeffrey Ma on 3/21/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "TableDemoViewController.h"

@interface TableDemoViewController ()
-(void)setup;
-(void)refreshVisibleCellsImages;
@end

@implementation TableDemoViewController
@synthesize tblView;
@synthesize itemArray;
@synthesize freeList;
@synthesize paidList;
@synthesize grossingList;

@synthesize cellNib;
@synthesize statuesArr;
@synthesize headDictionary;
@synthesize imageDictionary;

#pragma mark - Life recycle
#pragma mark
- (void)dealloc
{
    [tblView release];
    [itemArray release];
    [freeList release];
    [paidList release];
    [grossingList release];
    
    self.headDictionary = nil;
    self.imageDictionary = nil;
    self.cellNib = nil;
    self.statuesArr = nil;
    _refreshHeaderView=nil;
    
    [super dealloc];
}

-(void)setup
{
    CGRect frame = tblView.frame;
    frame.size.height = frame.size.height + REFRESH_FOOTER_HEIGHT;
    tblView.frame = frame;
    
    //init data
    isFirstCell = YES;
    shouldLoad = NO;
    shouldShowIndicator = YES;
    //manager = [WeiBoMessageManager getInstance];
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
    headDictionary = [[NSMutableDictionary alloc] init];
    imageDictionary = [[NSMutableDictionary alloc] init];
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
        
//        [defaultNotifCenter addObserver:self selector:@selector(getAvatar:)         name:HHNetDataCacheNotification object:nil];
//        [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:)   name:MMSinaRequestFailed object:nil];
//        [defaultNotifCenter addObserver:self selector:@selector(loginSucceed)       name:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
        
        ListItem *item1 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"Weather"];
        ListItem *item2 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Shopping"];
        ListItem *item3 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"E-Trade"];
        ListItem *item4 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"Voice Recorder"];
        ListItem *item5 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"News Reader"];
        ListItem *item6 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"10_64x64.png"] text:@"Game Pack"];
        ListItem *item7 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Movies"];
        ListItem *item8 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"12_64x64.png"] text:@"Forecast"];
        ListItem *item9 = [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"10_64x64.png"] text:@"Game Pack"];
        ListItem *item10= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"11_64x64.png"] text:@"Movies"];
        ListItem *item11= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"9_64x64.png"] text:@"News Reader"];
        ListItem *item12= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"8_64x64.png"] text:@"Voice Recorder"];
        ListItem *item13= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"7_64x64.png"] text:@"E-Trade"];
        ListItem *item14= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"6_64x64.png"] text:@"Shopping"];
        ListItem *item15= [[ListItem alloc] initWithFrame:CGRectZero image:[UIImage imageNamed:@"5_64x64.png"] text:@"Weather"];
        
        freeList = [[NSMutableArray alloc] initWithObjects: item1, item2, item3, item4, item5, nil];
        paidList = [[NSMutableArray alloc] initWithObjects: item6, item7, item8, item9, item10, nil];
        grossingList = [[NSMutableArray alloc] initWithObjects: item11, item12, item13, item14, item15, nil];
        
        [item1 release];
        [item2 release];
        [item3 release];
        [item4 release];
        [item5 release];
        [item6 release];
        [item7 release];
        [item8 release];
        [item9 release];
        [item10 release];
        [item11 release];
        [item12 release];
        [item13 release];
        [item14 release];
        [item15 release];  
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpRefreshView];
    self.tblView.contentInset = UIEdgeInsetsOriginal;
    refreshFooterView.hidden = YES;
}

- (void)viewDidUnload
{
//    [defaultNotifCenter removeObserver:self name:HHNetDataCacheNotification object:nil];
//    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed        object:nil];
//    [defaultNotifCenter removeObserver:self name:DID_GET_TOKEN_IN_WEB_VIEW  object:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview delegate
#pragma mark
- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [self.tblView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *title = @"";
    POHorizontalList *list;
    
    if ([indexPath row] == 0) {
        title = @"Top Free";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:freeList];
    }
    else if ([indexPath row] == 1) {
        title = @"Top Paid";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:paidList];
    }
    else if ([indexPath row] == 2) {
        title = @"Top Grossing";
        
        list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 155.0) title:title items:grossingList];
    }
    
    [list setDelegate:self];
    [cell.contentView addSubview:list];
    
    if (indexPath.row >= 3)
    {
        return cell;
    }
    
    if (self.tblView.dragging == NO && self.tblView.decelerating == NO)
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
    
    //开始绘制第一个cell时，隐藏indecator.
    if (isFirstCell)
    {
        [[SHKActivityIndicator currentIndicator] hide];
//        //        [[ZJTStatusBarAlertWindow getInstance] hide];
        isFirstCell = NO;
    }
    return cell;
 
}

#pragma mark  POHorizontalListDelegate

- (void) didSelectItem:(ListItem *)item {
    NSLog(@"Horizontal List Item %@ selected", item.imageTitle);
}

#pragma mark - 下拉刷新
//-(UINib*)cellNib
//{
//    if (cellNib == nil)
//    {
//        [cellNib release];
//        cellNib = [[CustomCell nib] retain];
//    }
//    return cellNib;
//}

-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tblView.bounds.size.height, self.view.frame.size.width, self.tblView.bounds.size.height)];
		view.delegate = self;
		[self.tblView addSubview:view];
		_refreshHeaderView = [view retain];
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - Methods
-(void)loginSucceed
{
    shouldLoad = YES;
}

-(void)refreshVisibleCellsImages
{
//    NSArray *cellArr = [self.table visibleCells];
//    for (DesireCell *cell in cellArr) {
//        NSIndexPath *inPath = [self.table indexPathForCell:cell];
//        Status *status = [statuesArr objectAtIndex:inPath.row];
//        User *user = status.user;
//        
//        if (user.avatarImage == nil)
//        {
//            [[HHNetDataCacheManager getInstance] getDataWithURL:user.profileImageUrl withIndex:inPath.row];
//        }
//        else {
//            cell.avatarImage.image = user.avatarImage;
//        }
//        
//        if (status.statusImage == nil)
//        {
//            [[HHNetDataCacheManager getInstance] getDataWithURL:status.thumbnailPic withIndex:inPath.row];
//            [[HHNetDataCacheManager getInstance] getDataWithURL:status.retweetedStatus.thumbnailPic withIndex:inPath.row];
//        }
//        else {
//            cell.contentImage.image = status.statusImage;
//            cell.retwitterContentImage.image = status.statusImage;
//        }
//    }
}

//得到图片
-(void)getAvatar:(NSNotification*)sender
{
//    NSDictionary * dic = sender.object;
//    NSString * url          = [dic objectForKey:HHNetDataCacheURLKey];
//    NSNumber *indexNumber   = [dic objectForKey:HHNetDataCacheIndex];
//    NSInteger index         = [indexNumber intValue];
//    NSData *data            = [dic objectForKey:HHNetDataCacheData];
//    UIImage * image     = [UIImage imageWithData:data];
//    
//    if (data == nil) {
//        NSLog(@"data == nil");
//    }
//    //当下载大图过程中，后退，又返回，如果此时收到大图的返回数据，会引起crash，在此做预防。
//    if (indexNumber == nil || index == -1) {
//        NSLog(@"indexNumber = nil");
//        return;
//    }
//    
//    if (index >= [statuesArr count]) {
//        //        NSLog(@"statues arr error ,index = %d,count = %d",index,[statuesArr count]);
//        return;
//    }
//    
//    Status *sts = [statuesArr objectAtIndex:index];
//    User *user = sts.user;
//    
//    DesireCell *cell = (DesireCell *)[self.table cellForRowAtIndexPath:sts.cellIndexPath];
//    
//    //得到的是头像图片
//    if ([url isEqualToString:user.profileImageUrl])
//    {
//        user.avatarImage = image;
//        cell.avatarImage.image = user.avatarImage;
//    }
//    
//    //得到的是博文图片
//    if([url isEqualToString:sts.thumbnailPic])
//    {
//        sts.statusImage = image;
//        cell.contentImage.image = sts.statusImage;
//        cell.retwitterContentImage.image = sts.statusImage;
//    }
//    
//    //得到的是转发的图片
//    if (sts.retweetedStatus && ![sts.retweetedStatus isEqual:[NSNull null]])
//    {
//        if ([url isEqualToString:sts.retweetedStatus.thumbnailPic])
//        {
//            sts.statusImage = image;
//            cell.retwitterContentImage.image = sts.statusImage;
//        }
//    }
}

-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
    [[SHKActivityIndicator currentIndicator] hide];
//    //    [[ZJTStatusBarAlertWindow getInstance] hide];
}

//上拉刷新
-(void)refresh
{
    //    [manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
    //    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
//    //    UIFont * font=[UIFont  systemFontOfSize:15];
//    //    CGSize size=[contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - kTextViewPadding, 300000.0f) lineBreakMode:kLineBreakMode];
//    //    CGFloat height = size.height + 44;
//    CGFloat height = [DesireCell getJSHeight:contentText jsViewWith:with];
//    return height;
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib
{
//    static NSString *cellID = @"DesireCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil)
//    {
//        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
//        cell = [nibObjects objectAtIndex:0];
//    }
//    else
//    {
//        [(LPBaseCell *)cell reset];
//    }
//    
//    return cell;
    return nil;
}

#pragma mark -
#pragma mark  - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
}

//调用此方法来停止。
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tblView];
	refreshFooterView.hidden = NO;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 200) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else
        [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshVisibleCellsImages];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
	{
        [self refreshVisibleCellsImages];
    }
    
    if (scrollView.contentOffset.y < 200)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _reloading = YES;
	//[manager getHomeLine:-1 maxID:-1 count:-1 page:-1 baseApp:-1 feature:-1];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
