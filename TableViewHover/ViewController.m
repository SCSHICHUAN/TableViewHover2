//
//  ViewController.m
//  TableViewHover
//
//  Created by Stan on 2021/5/2.
//

#define w ([UIScreen mainScreen].bounds.size.width)
#define h ([UIScreen mainScreen].bounds.size.height)
#define hover 100
#define header_1 200

#import "ViewController.h"
#import "ChildTableView.h"
#import "MJRefresh.h"
#import "SuperScrollView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic)UIScrollView *scroll;
@property (nonatomic)ChildTableView *tableView;
@property(nonatomic,assign)BOOL isSuper;//super
@property (nonatomic, assign) BOOL isChild;//child
@property (nonatomic,assign)BOOL isTopLoading;
@property (nonatomic,assign)BOOL isBottonLoading;
@property (nonatomic)BOOL isStartLoading;
@property (nonatomic) UIView *contenView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SuperScrollView *scroll = [[SuperScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    scroll.backgroundColor = UIColor.orangeColor;
    scroll.contentSize = CGSizeMake(w, h+hover);
    //    scroll.bounces = NO;
    _scroll = scroll;
    
    
    
    UIView *contenView = [[UIView alloc] initWithFrame:CGRectMake(0, header_1, w, scroll.contentSize.height-header_1)];
    [self.scroll addSubview:contenView];
    self.contenView = contenView;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 44)];
    lab.text = @"Button view";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = UIColor.blueColor;
    lab.textColor = UIColor.whiteColor;
    [self.contenView addSubview:lab];
    
    
    
    ChildTableView *tableView = [[ChildTableView alloc] initWithFrame:CGRectMake(0, 44, w, self.contenView.bounds.size.height-44)];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.contenView addSubview:self.tableView];
    
    
    //    ChildTableView *tableView = [[ChildTableView alloc] initWithFrame:CGRectMake(0, header_1, w, scroll.contentSize.height-header_1)];
    //    tableView.delegate = self;
    //    tableView.dataSource = self;
    //    _tableView = tableView;
    //    [scroll addSubview:self.tableView];
    
    //
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //       //Call this Block When enter the refresh status automatically
    //    }];
    
    // Set the callback???Once you enter the refresh status???then call the action of target???that is call [self loadNewData]???
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // Enter the refresh status immediately
    //    [self.tableView.mj_header beginRefreshing];
    
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        //Call this Block When enter the refresh status automatically
    //    }];
    
    // Set the callback???Once you enter the refresh status???then call the action of target???that is call [self loadMoreData]???
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    self.isChild = NO;
    self.isSuper = YES;
    self.isStartLoading = YES;
    
}
-(void)loadNewData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isStartLoading = YES;
        [self.tableView.mj_header endRefreshing];
    });
}
-(void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        self.isBottonLoading = NO;
    });
}

#pragma mar-UITableViewDataSource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%lu",indexPath.row];
    return cell;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 44)];
//    lab.text = @"title";
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.backgroundColor = UIColor.blueColor;
//    lab.textColor = UIColor.whiteColor;
//    return lab;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44;
//}


#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset_y = self.scroll.contentOffset.y;
    NSLog(@"self.scroll. = %lf",offset_y);
    
    
    if (scrollView == self.tableView) {
        CGFloat offset_y = self.tableView.contentOffset.y;
        NSLog(@"self.tableView = %lf",offset_y);
        
        if (offset_y <= 0) {//????????????
            self.isSuper = YES;
            self.isChild = NO;
        }
        
        
        //???????????????
        if (self.isTopLoading) {
            if (offset_y > 0) {
                self.isTopLoading = NO;//?????????????????????????????????
            }
        }
        
    }
    
    

    
    
    if (scrollView == self.scroll) {
        CGFloat offset_y = self.scroll.contentOffset.y;
        NSLog(@"self.scroll = %lf",offset_y);
        
        if (offset_y >= hover) {
            self.isSuper = NO;
            self.isChild = YES;
        }
        
        
        
        
        //??????????????? ????????????
        //???view ????????????
        if (offset_y < -48) {//????????????view???????????????????????????????????????
            self.isTopLoading = YES;
        }
        
        //???view ????????????
        if (offset_y > hover) {//????????????view???????????????????????????????????????
            self.isBottonLoading = YES;
        }
        
    }
    
    
    
    
    
    
    
    //???????????????????????????????????? offset
    if (self.isTopLoading) {
        
        if (self.isStartLoading) {
            self.tableView.contentOffset = CGPointMake(0,self.scroll.contentOffset.y+48);//????????????????????????????????????????????????
        }
        
        //????????????60?????????????????????????????????????????????????????????????????????????????????????????????
        if (self.tableView.contentOffset.y <= -60) {
            [self.tableView.mj_header beginRefreshing];
            self.isStartLoading = NO;
        }
    }
    
    
    //????????????
    if (self.isBottonLoading) {
        [self.tableView.mj_footer beginRefreshing];
    }
    
    

    
    
    //????????????????????????????????? ??????????????????
    if ((!self.isChild && self.isSuper)) {
        if (!self.isTopLoading) {//??????????????? ?????????????????????????????????view offset
            self.tableView.contentOffset = CGPointZero;
        }
    }else{
        self.scroll.contentOffset = CGPointMake(0, hover);
    }
    
    
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end
