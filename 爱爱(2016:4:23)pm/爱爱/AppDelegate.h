//
//  AppDelegate.h
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/7.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"  //数据库
#import "YRSideViewController.h"    //侧边栏

@class JTNavigationController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic ,strong)FMDatabase *db;

@property (strong,nonatomic) YRSideViewController *sideViewController;

@property (nonatomic,strong) JTNavigationController *rootViewController;    //"资讯"

@property (nonatomic,strong) JTNavigationController *hotelViewController;   //"酒店"

@property (nonatomic,strong) JTNavigationController *userDataViewController;//"我的"


@property (nonatomic,strong) UITabBarController *tabbarController;  //首页总的tabberController


@end

