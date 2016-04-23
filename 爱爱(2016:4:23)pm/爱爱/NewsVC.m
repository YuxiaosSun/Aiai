//
//  NewsVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define  tableF self.mytableView.mj_footer
#define DisposableNewsNum   5   //一次性加载的新闻条数

#import "NewsVC.h"

#import "UIScrollView+PullToRefreshCoreText.h"  //刷新头
#import "UIImageView+ProgressView.h"
#import "MJRefresh.h"       ///刷新库
#import "Reachability.h"

#import "NewsCell.h"    //自定义cell
#import "NewsWebVC.h"   //带网页的新闻界面



@interface NewsVC ()<NewCellImageDelegate>
{

    NSMutableArray *newsArr;    //新闻数组

}

@end


@implementation NewsVC




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    newsArr = [NSMutableArray new];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self creatTableView];  //创建表视图
    
    //注册cell
    [self.mytableView registerClass:[NewsCell class] forCellReuseIdentifier:NSStringFromClass([NewsCell class])];
    
    
//    [self.mytableView.pullToRefreshView startLoading];
}




#pragma mark ----- 视图创建

-(void)creatTableView       //创建表视图
{
    
    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-49-0)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mytableView.backgroundColor = [UIColor whiteColor];
    
    //添加头部刷新功能
//    __weak typeof(self.mytableView) weakTableView = self.mytableView;
    __weak typeof(self) weakSelf = self;
    
//    __weak typeof(newsArr) weaknewsArr = newsArr;
    
    [self.mytableView addPullToRefreshWithPullText:@"从此,生活有情趣" pullTextColor:MainThemeColor pullTextFont:DefaultTextFont refreshingText:@"Refreshing..." refreshingTextColor:DefaultTextColor refreshingTextFont:DefaultTextFont action:^{
        
        [weakSelf upData];  //加载最新数据
        
    }];
    
    [self.mytableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 10)]];
    
}

-(void)upData       //下拉刷新
{
    
    downPull = YES; //代表下拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //无网络或在离线阅读的模式下(取本地数据)
    {
        
        
        
    }else if(status==0){//无网络
        
        showHudString(@"请检查网络情况");
        
    }else            //有网络(传入数据接口)
    {
        
        NSLog(@"下拉刷新最新新闻");
        
        [self refreshOtherNews];    //加载新闻
        
    }
    
}

-(void)loadNewData  //上拉加载
{
    
    downPull = NO;  //代表上拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //无网络或在离线阅读的模式下(取本地数据)
    {
        [tableF endRefreshing];
        
        [tableF setState:MJRefreshStateNoMoreData];
        
    }else if(status==0){//无网络
        
        showHudString(@"请检查网络情况");
        
        [tableF endRefreshing];
        
    }else               //有网络(传入数据接口)
    {
        NSLog(@"上拉加载更多新闻");
        
        [self refreshOtherNews];    //加载新闻
    }
    
}

-(void)addMjfooter  //添加上拉加载
{
    
    if (tableF) {
        
        return;
        
    }else{
        
        MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [footer setTitle:TableViewMJFooterUpLoadText forState:MJRefreshStateIdle];
        [footer setTitle:TableViewMJFooterRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
        tableF=footer;
        
    }
    
}


-(void)endHeaderRefresh
{

    [self.mytableView finishLoading];

}


///*********.....................表视图相关.................*********///

#pragma mark ----- UITableView Datasource 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return newsArr.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class currentClass = [NewsCell class];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    cell.delegate=self;
    
    [cell sd_clearSubviewsAutoLayoutFrameCaches];
    
    NSDictionary *model = newsArr[indexPath.row];
    
    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSDictionary *model = newsArr[indexPath.row];
//    
//    CGFloat height;
//    
//    if ([model objectForKey:@"backImage"]) {
//        
//        UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[model objectForKey:@"backImage"]];
//        
//        
//        height = img.size.height *Width/img.size.width;//Image宽度为屏幕宽度 ，计算宽高比求得对应的高度
//        NSLog(@"----------------return Height:%f",height);
        
//    }
    
//    return height;
    
    // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
    return [self.mytableView cellHeightForIndexPath:indexPath model:newsArr[indexPath.row] keyPath:@"model" cellClass:[NewsCell class] contentViewWidth:[self cellContentViewWith]];
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark ----- UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsWebVC *wvc = [NewsWebVC new];
    
    NSDictionary *newModel = newsArr[indexPath.row];
    
    self.hidesBottomBarWhenPushed=YES;
    
    wvc.webViewUrlStr = [MainUrl stringByAppendingString:[newModel objectForKey:@"shareUrl"] ];
    
    [self.navigationController pushViewController:wvc animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;

}

///cell的图片下载代理方法
-(void)reloadCellAtIndexPathWithUrl:(NSString *)url IsimageExist:(BOOL)exist
{
    
    if (url) {
        for (int i = 0; i< newsArr.count; i++) {
            //遍历当前数据源中并找到ImageUrl
            NSDictionary *dict  =   newsArr.count >i ? newsArr[i] :nil;
            NSString *imgURL = [dict objectForKey:@"imageSrc"];
            
            if ([imgURL isEqualToString:url]) {
                
                if (exist==YES) {
                    
                    [self.mytableView reloadData];
                    
                }else{
                    
//                    [newsArr removeObject:dict];
                    
                    [self.mytableView reloadData];
                    
                }
                
            }
            
            
//            if ([imgURL isEqualToString:url]) {
//                
//                if (exist) {
//                    
//                    //获取当前可见的Cell NSIndexPaths
//                    NSArray *paths  = self.mytableView.indexPathsForVisibleRows;
//                    //判断回调的NSIndexPath 是否在可见中如果存在则刷新页面
//                    NSIndexPath *pathLoad = [NSIndexPath indexPathForItem:i inSection:0];
//                    for (NSIndexPath *path in paths) {
//                        
//                        if (path && path == pathLoad ) {
//                            
//                            NSLog(@"重新刷新了cell");
//                            
//                            //刷新
////                            [self.mytableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:pathLoad, nil] withRowAnimation:UITableViewRowAnimationNone];
//                            
//                            [self.mytableView reloadData];
//                        }
//                        
//                    }
//                    
//                }else{
//                
////                    [newsArr removeObject:dict];
//                    
//                    [self.mytableView reloadData];
//                
//                }
//                
//            }
            
            
            
        }
    }
}


///*********.....................表视图相关.................*********///


#pragma  mark ----- 交互方法

-(void)refreshOtherNews     //加载新闻
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    //请求普通区新闻
    NSMutableString *newsUrl=[[MainUrl stringByAppendingString:newsList]mutableCopy];
    
    if (downPull) { //如果是下拉,使用最新的时间基点获取数据
        
        [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&contentType=%d&baseObjectId=&deviceId=%@",11,@"",DisposableNewsNum,2,deviceId]];
        
    }else{  //反之则是上拉加载,使用之前保存的时间基点
        
        [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&contentType=%d&baseObjectId=%@&deviceId=%@",11,self.myDatebase,DisposableNewsNum,2,self.baseObjectId,deviceId]];
        
    }
    
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newsUrl] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {//有数据过来
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"普通区新闻dict:%@",dict);
            
            if ([dict objectForKey:@"newsDateId"]&&[dict objectForKey:@"baseObjectId"]) {
                self.myDatebase=[dict objectForKey:@"newsDateId"];
                self.baseObjectId=[dict objectForKey:@"baseObjectId"];
                
            }else{
                
                [tableF endRefreshing];
                
                [(MJRefreshAutoStateFooter *)tableF setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateIdle];
                
                
                return ;
            }
            
            NSArray *arr = [dict objectForKey:@"result"];
            
            
            
            if (downPull) {

                //替换之前所有的
//                [newsArr replaceObjectsInRange:NSMakeRange(0, newsArr.count-1) withObjectsFromArray:[dict objectForKey:@"result"]];
                    
                [newsArr removeAllObjects];

            }
            
            [newsArr addObjectsFromArray:arr];
            

            GCDWithMain(^{  //主线程刷新表视图
            
                [self.mytableView reloadData];
                
                if (self.mytableView.pullToRefreshView.status==0||self.mytableView.pullToRefreshView.status==2) {
                    
                    [self endHeaderRefresh];
                    
                }
                
                if (tableF.state==MJRefreshStateRefreshing) {
                    
                    [tableF endRefreshing];
                    
                }
            
            });
            
            [self addMjfooter]; //添加刷新尾巴
            
        }else{
            
            showHudString(@"加载超时");
            
            [self endHeaderRefresh];
            
            [tableF endRefreshing];
            
        }
        
    }];
    
}






#pragma mark ----- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}



































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
