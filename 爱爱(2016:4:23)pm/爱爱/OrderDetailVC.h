//
//  OrderDetailVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/6.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///订单详情页



@class OrderSourceModel;

#import <UIKit/UIKit.h>

@interface OrderDetailVC : UIViewController<UIAlertViewDelegate,UIGestureRecognizerDelegate>

{

    DGActivityIndicatorView *activityIndicatorView; //加载指示器

}

@property (nonatomic,strong) UIButton *leftButton;      //返回键

@property (nonatomic,assign) BOOL hideLeftBtn;          //是否隐藏左按键

@property (nonatomic,strong) OrderSourceModel *model;   //订单模型

@property (nonatomic,strong) NSMutableDictionary *orderDic; //保存订单信息的字典


@end
