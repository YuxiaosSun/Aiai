//
//  BrowsingHistoryViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/3.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "BrowsingHistoryViewController+Methods.h"

@implementation BrowsingHistoryViewController (Methods)

#pragma mark ----- 处理方法

-(void)creatView  //视图创建
{
    
    if (newsArr.count==0)//创建log
    {
        logImage =[[UIImageView alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.3, 69, 24)];
        [logImage setImage:[UIImage imageNamed:@"log_small.png"]];
        [self.view addSubview:logImage];
    }
    
    [self creatNavigationView];
    
    [self creatTableView];  //创建视图
    
}

-(void)getDataFromLocation      //从本地读取历史纪录表
{
    
    newsArr =[NSMutableArray new];
    allArr  =[NSMutableArray new];
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db = app.db;
    
    //降序排列查询
    FMResultSet *result = [db executeQuery:@"select * from BrowsHistoryTable order by browsTime desc"];
    
    while ([result next]) {
        
        NewsSourceModel *newsModel =[[NewsSourceModel alloc]init];
        newsModel.newsId=[NSNumber numberWithInteger:[[result stringForColumn:@"newsId"] integerValue]];
        newsModel.contentType=[NSNumber numberWithInt:[result intForColumn:@"contentType"]];
        newsModel.title=[result stringForColumn:@"title"];
        newsModel.titleImg=[UIImage imageWithData:[result dataForColumn:@"titleImg"]];
        newsModel.publishTime=[result stringForColumn:@"publishTime"];
        newsModel.source=[result stringForColumn:@"source"];
        newsModel.browsTime=[result stringForColumn:@"browsTime"];
        
        [allArr addObject:newsModel];
    }
    
    //处理当前数组返回新的数组
    if (allArr.count>0) {
        
        [self processTheArr:allArr];
        
        [rightBtn setHidden:NO];
        
    }else{
        
        [self showString:@"暂无浏览历史"];
        
        [rightBtn setHidden:YES];
        
    }
    
}

-(void)touchToDeleteHistory     //一键清除浏览历史
{
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"清空浏览记录" message:@"想掩盖些神马呢?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    
    [alert show];
}

-(void)processTheArr:(NSArray *)arr     //将已经浏览的新闻按时间分组
{
    
    NewsSourceModel *firstNewsModel;   //先得到第一元素
    static int i=1;
    
    while (1) {
        
        //首先确定需要进行比较的第一个对象
        
        if (middleNewsModel) {
            
            firstNewsModel =middleNewsModel;
            
        }else{
            
            firstNewsModel =arr[0];
            
        }
        
        if (([arr indexOfObject:firstNewsModel]+1)>=arr.count){ //满足条件说明后面已经没有元素了
            
            //避免有保存之前比较时残留的数值,必须清空
            str1=nil;
            str2=nil;
            
            [self addArrToNewsArrWithArr:arr AndFirstModel:firstNewsModel];
            
            break;
            
        }
        
        
        //再确定第二个对象
        
        while (1) {
            
            if (([arr indexOfObject:firstNewsModel]+i)<arr.count){ //如果后面取不到对象直接跳出
                
                middleNewsModel =arr[([arr indexOfObject:firstNewsModel]+i)];
                
            }else{
                
                i=1;
                
                [self addArrToNewsArrWithArr:arr AndFirstModel:firstNewsModel];
                
                
                break;
                
                
            }
            
            str1 =[firstNewsModel.browsTime substringWithRange:NSMakeRange(0, 8)];
            //                        NSLog(@"str1:%@",str1);
            
            
            str2 =[middleNewsModel.browsTime substringWithRange:NSMakeRange(0, 8)];
            //                        NSLog(@"str2:%@",str2);
            
            
            //进行比较
            if ([str1 isEqualToString:str2]) {
                
                i++;
                
            }else{
                
                i=1;
                
                [self addArrToNewsArrWithArr:arr AndFirstModel:firstNewsModel];
                
                break;
            }
            
        }
        
        
        //避免最后一个对象的重复使用
        
        if (middleNewsModel==[allArr lastObject]&&middleNewsModel==[[newsArr lastObject] lastObject]) {
            
            break;
            
        }
        
        
    }
    
    middleNewsModel=nil;    //重置
    
    [self.tableView reloadData];
    
    //    NSLog(@"newsArr的长度为:%lu",(unsigned long)newsArr.count);
    //
    //    for (NSArray *arr in newsArr) {
    //
    //        for (NewsSourceModel *newsmodel in arr) {
    //
    //            NSLog(@"浏览时间为:%@",newsmodel.browsTime);
    //            //                NSLog(@"newsmodel:%@",newsmodel);
    //
    //        }
    //        NSLog(@"---------");
    //    }
    
    
    
}



#pragma mark ---视图加载



-(void)creatNavigationView//添加导航栏按钮相关
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
    
    //添加右按钮
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"cleaner"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(touchToDeleteHistory)forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [rightBtn setHidden:YES];
    
    //修改标题字体大小和颜色
    self.title=@"浏览历史";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:RGBA(50, 50, 50, 1)}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //打开手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // 关闭侧边栏效果
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
}

-(void)creatTableView//创建表视图
{
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 20, 0, 20);
}









#pragma mark --- 辅助方法


#pragma mark ----- alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {   //一键清除所有浏览记录
        
        AppDelegate *app =[UIApplication sharedApplication].delegate;
        FMDatabase *db =app.db;
        
        BOOL delete = [db executeUpdate:@"delete from BrowsHistoryTable"];
        
        if (delete) {
            
            [self showString:@"已清空所有历史"];
            
            [newsArr removeAllObjects];
            
            [rightBtn setHidden:YES];
            
            [self.tableView reloadData];
            
            [self delayTimeToExecute];  //延时1s跳回前一个页面
            
        }
        
    }
    
}

-(void)touchToPop       //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController  showLeftViewController:YES];
}

-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self touchToPop];
        
    });
    
}


-(void)showString:(NSString *)str//提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    //    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

-(NSMutableString *)getTheCurrentDate       //取得当前时间字符串数据
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];//取得当前时间的字符串
    
    NSMutableString *str =[date mutableCopy];//copy为可变的
    
    //对时间字符串进行加工
    [str deleteCharactersInRange:NSMakeRange(16, 1)];
    [str deleteCharactersInRange:NSMakeRange(13, 1)];
    [str deleteCharactersInRange:NSMakeRange(10, 1)];
    [str deleteCharactersInRange:NSMakeRange(7, 1)];
    [str deleteCharactersInRange:NSMakeRange(4, 1)];
    
    return str;
}


-(NSMutableString *)getTheYesterDate        //取得前一天的时间字符串数据
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];//前一天
    
    NSString *date=[nsdf2 stringFromDate:lastDay];//取得前一天时间的字符串
    
    //    NSLog(@"nsdf2:%@",date);
    
    NSMutableString *str =[date mutableCopy];//copy为可变的
    
    //对时间字符串进行加工
    [str deleteCharactersInRange:NSMakeRange(16, 1)];
    [str deleteCharactersInRange:NSMakeRange(13, 1)];
    [str deleteCharactersInRange:NSMakeRange(10, 1)];
    [str deleteCharactersInRange:NSMakeRange(7, 1)];
    [str deleteCharactersInRange:NSMakeRange(4, 1)];
    
    return str;
}


//将处理后得到的数组添加到全局数组(可以复用的方法,用来给浏览新闻的时间分组)
-(void)addArrToNewsArrWithArr:(NSArray *)arr AndFirstModel:(NewsSourceModel *)firstNewsModel
{
    
    NSRange range ; //取值的范围
    
    range.location = [arr indexOfObject:firstNewsModel];    //起点
    
    if (middleNewsModel) {                                  //长度
        
        if (str1&&str2&&![str1 isEqualToString:str2]) {
            
            range.length = [arr indexOfObject:middleNewsModel]-range.location;
            
        }else{
            
            range.length = [arr indexOfObject:middleNewsModel]-range.location+1;
            
        }
        
    }else{
        
        range.length=1;
        
    }
    
    NSArray *middleArr = [arr subarrayWithRange:range];
    
    [newsArr addObject:middleArr];
    
}


@end
