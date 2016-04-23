//
//  NewSettingViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewSettingViewController.h"
#import "NewSettingViewController+Methods.h"    //引入分类

#import "SwitchCell.h"      //带开关按钮的自定义cell
#import "TableViewCell8.h"  //带辅助视图和文字的自定义cell

@interface NewSettingViewController ()

@end

@implementation NewSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self creatView];   //加载视图
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    // 关闭侧滑效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
}


#pragma mark ----- TableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section==0) {
        
        return 3;
        
    }else{
    
        return 2;
    
    }

}

//cell填充内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0&&indexPath.row==0) {
        
        SwitchCell *cell =(SwitchCell *)[tableView dequeueReusableCellWithIdentifier:@"switchcell"];
        
        if (cell==nil) {
            
            cell = [[SwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switchcell"];
            
        }
        
        [cell settitleWithText:@"消息推送"];
        
        [cell.Switch addTarget:self action:@selector(touchToGetMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"GetMessage"]isEqualToString:@"YES"]) {
            
            cell.Switch.on=YES;
            
            [cell.detailContent setHidden:YES];
            
        }else{
        
            cell.Switch.on=NO;

            [cell.detailContent setHidden:NO];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
    
        TableViewCell8 *cell =(TableViewCell8 *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell==nil) {
            
            cell = [[TableViewCell8 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
        if (indexPath.section==0) {     //分区1
            
            switch (indexPath.row) {
                case 1:
                {
                    
                    [cell settitleWithText:@"清理缓存"];
                    [cell setintrodictionWithText:[NSString stringWithFormat:@"%.1fM",cachesFileSizes]];
                    
                }
                    break;
                    
                case 2:
                {
                    
                    [cell settitleWithText:@"浏览历史保存时间"];
                    [cell setintrodictionWithText:@"最近一周"];
                    
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{                          //分区2
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    [cell settitleWithText:@"当前版本"];
                    
                }
                    break;
                    
                case 1:
                {
                    
                    [cell settitleWithText:@"关于我们"];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        return cell;
    
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 66;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }else{
        return 0;
    }
}

#pragma mark --- TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
            case 1:
            {
            
                UIAlertView *cachesView ;
                if (cachesFileSizes>0) {
                    
                    cachesView=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"当前缓存大小为%.2fM,确定要清理嘛?",cachesFileSizes] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [cachesView show];
                }else{
                    
                    cachesView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有缓存,不需要清理哟~" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [cachesView show];
                    
                }
            
            }
                break;
                
                case 2:
            {
            
                UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"请选择清除哪种缓存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清除离线阅读缓存", nil];
            
                [action showInView:self.view];
                
            }
                break;
                
            default:
                break;
        }
        
    }else{
    
        
    
    }


}



#pragma mark ----- UIActionsheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"清除离线阅读缓存");
            
            //开启子线程进行费时操作,以免卡住界面
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                FMDatabase *db = app.db;
                
                BOOL deleteData = [db executeUpdate:@"delete from offlineNewsDataTable"];
                
                if (deleteData) {
                    
                    NSLog(@"离线资源已清空");
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:offLineReadState];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //                NSLog(@"offLineReadState:%@",[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]);
                    
                }
                
            });
        
        }
            break;

            
        default:
            break;
    }

}




@end
