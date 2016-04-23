//
//  NewsCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewsCell.h"

#import "UIImageView+ProgressView.h"

@implementation NewsCell

{
    
    UILabel     *titleLabel;    //标题
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setUpView];
        
    }
    
    return self;

}

//加载基本视图
-(void)setUpView
{

    _backView = [UIImageView new];
    
    titleLabel = [UILabel new];
    
    titleLabel.numberOfLines = 0;
    
    [self.contentView sd_addSubviews:@[_backView,titleLabel]];
    
    //参照某一高度进行布局(只需要使用一次)
    [self setupAutoHeightWithBottomView:titleLabel bottomMargin:50];    //此处必须使用self，否则会计算失败

}

//加载图片
-(void) setImageUrl:(NSString *)imageUrl
{
    if (imageUrl) {
        _imageUrl = imageUrl;
        
        //图片的真实地址需要拼接
        NSString *imageStr = [MainUrl stringByAppendingString:imageUrl];
        
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        // 没有缓存图片
        if (!cachedImage) {
            __weak typeof(self) weakSelf = self;
            // 利用 SDWebImage 框架提供的功能下载图片
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageStr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
//                NSLog(@"imageurlStr:%@-----image.size.width:%f-----image.size.height:%f \n\n",imageStr,image.size.width,image.size.height);
                
                BOOL exist = NO;
                
                //只有当图片存在时才修改图片视图的大小
                if (image.size.width>0&&image.size.height>0) {
                    
                    //将图片保存到磁盘
                    [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl toDisk:YES]; //
                    
                    [weakSelf configPreviewImageViewWithImage:image];
                    
                    exist= YES;
                    
                    //此时触发代理方法
                    if ([self.delegate respondsToSelector:@selector(reloadCellAtIndexPathWithUrl:IsimageExist:)]) {
                        [self.delegate reloadCellAtIndexPathWithUrl:imageUrl IsimageExist:exist];
                    }
                    
                }
                
            }];
        }else
        {
//            NSLog(@"imageurlStr:%@-----cachedImage.size.width:%f-----cachedImage.size.height:%f \n\n",imageStr,cachedImage.size.width,cachedImage.size.height);
            
            [self configPreviewImageViewWithImage:cachedImage];
            
        }
        
        
    }
}


/**
 * 加载图片成功后设置image's frame
 */
- (void)configPreviewImageViewWithImage:(UIImage *)image
{
    CGFloat previewWidth = Width-20;   //宽度参照为屏幕宽度
    CGFloat previewHeight =  image.size.height * previewWidth/image.size.width;
    
//    NSLog(@"image.size.width:%f",image.size.width);   ///出现了为0的情况
    CGRect rect = _backView.frame;
    rect.size.width = previewWidth;
    rect.size.height = previewHeight;
    _backView.frame = rect;
    _backView.sd_cornerRadius = @(5);
    _backView.image = image;
    [self resetLayoutByPreviewImageView];
}

-(void)resetLayoutByPreviewImageView    //重新布局
{

    [self loadBackView];    //布局图片控件
    
    [self loadRemainView];  //布局除图片外的其它控件

}

-(void)setModel:(NSDictionary *)model
{
    
    _model = [model copy];

    [self loadBackView];    //布局图片控件
    
    [self loadRemainView];  //布局除图片外的其它控件
    
    [titleLabel setText:[model objectForKey:@"title"]];
        
    [self setImageUrl:[_model objectForKey:@"imageSrc"]];

}


-(void)loadBackView     //布局图片控件
{
    
    _backView.sd_layout
    .topSpaceToView(self.contentView,TopMargin)
    .centerXEqualToView(self.contentView)
    ;
    
}

-(void)loadRemainView   //布局除图片外的其它控件
{

    //设置标题
    titleLabel.sd_layout
    .topSpaceToView(_backView,10)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0)
    ;

}














@end
