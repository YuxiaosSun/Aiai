//
//  NewSettingViewController+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewSettingViewController+Methods.h"

@implementation NewSettingViewController (Methods)

#pragma mark ----- 处理方法

-(void)creatView  //视图创建
{

    [self creatNavigationView];
    
    [self creatTableView];  //创建视图
    
    [self getCurrentAppCaches]; //获取当前项目的缓存大小

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
    
    //修改标题字体大小和颜色
    self.title=@"设置";
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
}






#pragma mark --- 辅助方法

-(void)touchToPop       //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController  showLeftViewController:YES];
    
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


-(IBAction)touchToGetMessage:(UISwitch *)sender    //修改是否获取消息推送的状态
{
    
    if (sender.isOn==YES) {     //开启后台消息推送
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"GetMessage"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{                      //关闭后台消息推送
    
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"GetMessage"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    
    [self.tableView reloadData];

}



-(NSString *)getCachesPath{     //获取缓存目录路径

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
//    NSString *filePath = [cachesDir stringByAppendingPathComponent:@"com.aiai.information"];
    
    return cachesDir;
}


- (long long) fileSizeAtPath:(NSString*) filePath       //计算单个缓存文件的大小(单位M)
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        //        //取得一个目录下得所有文件名
        //        NSArray *files = [manager subpathsAtPath:filePath];
        //        NSLog(@"files1111111%@ == %ld",files,files.count);
        //
        //        // 从路径中获得完整的文件名（带后缀）
        //        NSString *exe = [filePath lastPathComponent];
        //        NSLog(@"exeexe ====%@",exe);
        //
        //        // 获得文件名（不带后缀）
        //        exe = [exe stringByDeletingPathExtension];
        //
        //        // 获得文件名（不带后缀）
        //        NSString *exestr = [[files objectAtIndex:1] stringByDeletingPathExtension];
        //        NSLog(@"files2222222%@  ==== %@",[files objectAtIndex:1],exestr);
        
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}


- (float ) folderSizeAtPath:(NSString*) folderPath      //获取所有缓存文件的大小(单位M)
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){  //循环获取缓存文件里所有文件名
//        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
//    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0*1024.0);
    
}


-(void)getCurrentAppCaches  //获取当前项目的缓存大小
{

    //获取缓存路径
    NSString *cachesFileName =[self getCachesPath];
//    NSLog(@"cachesFileName:%@",cachesFileName);
    
    //计算缓存大小
    cachesFileSizes=[self folderSizeAtPath:cachesFileName];
    NSLog(@"fileSizes:%.2f",cachesFileSizes);
    
}


#pragma mark ----- UIAlertViewdelegate 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==1) {
        
        NSLog(@"开始清理缓存");
        
        NSFileManager* manager = [NSFileManager defaultManager];
        
        NSString *cachesFileName =[self getCachesPath]; //缓存路径
        
        //开启子线程进行费时操作,以免卡住界面
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            if (![manager fileExistsAtPath:cachesFileName]) return;
            
            //从前向后枚举器
            NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachesFileName] objectEnumerator];
            
            NSString* fileName;
            
            while ((fileName = [childFilesEnumerator nextObject]) != nil){
                
                NSString* fileAbsolutePath = [cachesFileName stringByAppendingPathComponent:fileName];
                
                [manager removeItemAtPath:fileAbsolutePath error:nil];  //删除当前文件名的缓存文件
                
            }
            
        });
        
        [self showString:@"缓存已清空"];
        
        cachesFileSizes=0;  //置空
        
        [self.tableView reloadData];
        
    }

}













@end
