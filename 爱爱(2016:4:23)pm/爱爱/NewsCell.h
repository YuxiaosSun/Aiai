//
//  NewsCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///新的自定义cell，用于展示资讯(能够容纳长篇幅的大图)


#define TopMargin  10 //图片距离上部的距离


#import <UIKit/UIKit.h>

@protocol NewCellImageDelegate <NSObject>   //代理方法
@required
-(void)reloadCellAtIndexPathWithUrl:(NSString *)url IsimageExist:(BOOL)exist;

@end

@interface NewsCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;   //数据模型

@property (nonatomic,strong) NSString *imageUrl;    //图片地址

@property (nonatomic,strong) UIImageView *backView;    //配图

@property (nonatomic,strong) id<NewCellImageDelegate> delegate; //代理


@end
