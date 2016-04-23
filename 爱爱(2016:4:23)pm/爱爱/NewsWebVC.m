//
//  NewsWebVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define  tableF mytableView.mj_footer

#import "NewsWebVC.h"

#import "YSWebView.h"
#import "MJRefresh.h"

@interface NewsWebVC ()<YSWebViewDelegate,UITableViewDataSource,UITableViewDelegate>

{

    YSWebView *headerWebView; //作为表头
    
    UITableView *mytableView;
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
    
    NSMutableArray *commentsArr;    //评论数组

}

@end

@implementation NewsWebVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    commentsArr = [NSMutableArray new];
    
    [self updataTheNavigationbar];
    
    [self loadWebView];
}

#pragma mark ----- 视图加载方法

-(void)updataTheNavigationbar   //导航栏设置
{
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(touchToPop)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //处理左按钮靠右的情况(当前设备的版本>=ios7.0)
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                           
                                                                                          target : nil action : nil ];
        
        negativeSpacer. width = - 20 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.leftBarButtonItems = @[ negativeSpacer, leftItem ] ;
        
    }else{//低于7.0版本不需要考虑
        
        self.navigationItem.leftBarButtonItem= leftItem;
        
    }
    
    
//    [self.navigationController setNavigationBarHidden:YES];
    
    //修改标题字体大小和颜色
//    self.title=@"新闻详情";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle(18, RGBA(50, 50, 50, 1));
        
    }else{
        
        SetNavigationBarTitle(18, [UIColor whiteColor]);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)creatTableView       //创建表视图
{
    
    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64)];
    mytableView=table;
    [self.view addSubview:mytableView];
    mytableView.dataSource=self;
    mytableView.delegate=self;
    mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    mytableView.backgroundColor = [UIColor whiteColor];
    
    headerWebView.frame = CGRectMake(0,0,Width,headerWebView.scrollView.contentSize.height);
    
    //设置表头
    [mytableView setTableHeaderView:headerWebView];
    
}



-(void)loadWebView  //加载网页
{
    
    headerWebView = [[YSWebView alloc]initWithFrame:CGRectMake(0, 0, Width, Height+49)];
    
    headerWebView.delegate =self;
    
    [headerWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewUrlStr]]];
    
//    headerWebView.userInteractionEnabled = NO;
    
    [self.view addSubview:headerWebView];

}

-(void)loadIndicator    //加载指示器
{
    
    if (!activityIndicatorView) {
        
        activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:7 tintColor:MainThemeColor size:Width/8];
        
    }
    
    [self.view addSubview:activityIndicatorView];
    
    //布局下
    activityIndicatorView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    ;
    
    [activityIndicatorView startAnimating]; //加载等待视图
    
}


#pragma mark ----- UITableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld条评论",indexPath.row];
    
    return cell;

}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//
//    if (section==0) {
//        
//        return headerWebView.scrollView.contentSize.height;
//        
//    }
//    return 0;
//
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    if (section==0) {
//        
//        return headerWebView;
//        
//    }
//    
//    return nil;
//
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark ---- YSWebView Delegate
//开始加载时调用
- (void)webViewDidStartLoad:(YSWebView *)webView
{

    [self loadIndicator];

}

//完成加载后调用
- (void)webViewDidFinishLoad:(YSWebView *)webView
{
    
//    NSLog(@"height1:%f",webView.webView.scrollView.contentSize.height);
//    NSLog(@"height2:%f",webView.webViewWK.scrollView.contentSize.height);
//    
//    
//    [self creatTableView];  //此时再开始加载表视图
    
    [activityIndicatorView stopAnimating]; //隐藏加载动画
    
//    [mytableView reloadData];

}
//加载失败时调用
- (void)webView:(YSWebView *)webView didFailLoadWithError:(NSError *)error
{

    showHudString(@"请求出错~");

}


#pragma mark ----- 辅助方法

-(void)touchToPop
{

    [self.navigationController popViewControllerAnimated:YES];

}


























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
