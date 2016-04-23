//
//  SwitchCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self loadCell];
        
        self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        
    }
    
    return self;
}

-(void)loadCell
{
    //标题
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    _titleLabel.dk_textColorPicker=DKColorWithColors(RGBA(50, 50, 50, 1), TitleTextColorNight);
    
    _titleLabel.numberOfLines=1;
    
    [self.contentView addSubview:_titleLabel];
    
    
    //标题下方的描述
    _detailContent =[[UILabel alloc]init];
    _detailContent.font = [UIFont systemFontOfSize:12];
    _detailContent.dk_textColorPicker=DKColorWithColors([UIColor redColor], UnimportantContentTextColorNight);
    _detailContent.numberOfLines=1;
    [_detailContent setText:@"您可能错过重要资讯通知,点击去设置允许通知"];
    [_detailContent sizeToFit];
    [self.contentView addSubview:_detailContent];
    
    [_detailContent setHidden:YES];
    
    
    //开关按钮
    _Switch =[[UISwitch alloc]init];
    _Switch.onTintColor=MainThemeColor;
    _Switch.on=NO;
    _Switch.frame=CGRectMake(Width-_Switch.frame.size.width-15, 33-_Switch.frame.size.height/2, _Switch.frame.size.width, _Switch.frame.size.height);
    [self.contentView addSubview:_Switch];
    
}

-(void)settitleWithText:(NSString *)string     //填充标题
{

    [_titleLabel setText:string];
    [_titleLabel sizeToFit];
    _titleLabel.frame=CGRectMake(20, 33-_titleLabel.frame.size.height/2, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    
    _detailContent.frame=CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+5, _detailContent.frame.size.width, _detailContent.frame.size.height);
    [_detailContent setHidden:NO];

}






@end
