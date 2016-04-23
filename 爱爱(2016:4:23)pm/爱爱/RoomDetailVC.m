//
//  RoomDetailVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "RoomDetailVC.h"

#import "RoomDetailVC+Methods.h"    //引入分类

#import "RoomContentCell.h" //用于展示房间内容介绍的自定义cell

@implementation RoomDetailVC

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadBaseView];     //加载基本视图
    
    //注册cell
    [self.mytableView registerClass:[RoomContentCell class] forCellReuseIdentifier:NSStringFromClass([RoomContentCell class])];

}


-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=YES;

}



#pragma mark ----- UITableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Class currentClass = [RoomContentCell class];
    RoomContentCell *cell = nil;
    cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    cell.model=self.roomModel;
    
    [self addtapgestureToViewsWithViewsArr:cell.viewsArr AndMapTap:cell.location];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith] tableView:tableView];
    
    // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
    return [self.mytableView cellHeightForIndexPath:indexPath model:self.roomModel keyPath:@"model" cellClass:[RoomContentCell class] contentViewWidth:[self cellContentViewWith]];

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

}













@end
