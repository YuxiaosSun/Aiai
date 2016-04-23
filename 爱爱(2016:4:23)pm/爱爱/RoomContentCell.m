//
//  RoomContentCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#define NoticeDeatailText @"1、预定时间：一般情况下请提前三天向我们预定，春节、五一、十一、会展期间请至少提前七天向我们预定，以确保您的旅行顺利。\n\n2、价格：本站提供优惠的酒店客房代定服务，预定客房5间以上，我们将给予您更大的优惠。如果您发现我们提供的价格与酒店门市价格倒挂，请立即致电或E-mail给我们，我们会立即与酒店宾馆进行交涉。如情况属实，我们将给您双倍差价赔偿。本站所提供的价格为净房价，不含政府调节基金及税金。\n\n3、接送站服务：通过本站预定客房，我们将为您提供桂林市范围内的免费接站服务；如果您还预订了旅游，本站将提供桂林市范围内的免费接、送站服务（不含机场接送）；\n\n4、定金：4人以下定金为100元；4人以上定金为200元；春节、五一节、国庆节期间订金为所订第一天房款的总额。定金须于入住前3日（春节、五一、十一须提前7日）汇入本网账户。\n\n5、房费支付：您可以通过在线支付、银行或者邮局汇款等方式把房费全额提前支付给本我们，为感谢您对于我们的信任，我们为您准备了精美的礼品。如果您采用预付订金的方式，您所付的订房定金会在您应支付的总房款中扣出,剩余房费由您在酒店前台支付或由我们到酒店收取。\n\n6、入离店时间按国际惯例，酒店的入店时间为当日中午的12：00以后，离店时间为次日的12：00之前。如提前入住或推迟离店，均须加收半日房费。酒店对房间预定的最晚保留时间为当天18：00，所以，预订者需在住店当日18：00之前到达酒店，办理入住手续，如不能在此时间之前到达，务必电话告知我们以便我们通知酒店前台延迟保留时间。\n\n7、入住登记及离店手续：入住酒店时请出示您的订单号码，并以您在网站预订时所登记的姓名办理相关手续，填写入住登记表格后缴纳房牌钥匙押金（该押金将在办理完退房手续后退还给您），即可入住酒店。退房前请提前通知酒店客房中心或总台，待酒店查房完毕，结清除房费之外的其他费用，酒店退还您的房牌钥匙押金后，即可离店。\n\n8、预定变更：所有的预定变更，包括延期抵达、提前离店、房间类型，定房数量等，请您均事先通知我们，或者进入本网站的订单查询栏进行订单的修改或取消，以便我们能为您及时地调整，避免空房而造成的损失。\n\n9、预定取消：如果您在入住酒店的前三天通知我们取消预定，我们将不收取任何费用，并将定金退还给您。如果在此时间之后通知我们取消预定，定金将不予退还，请您见谅。\n\n10、退款方式：采用网上支付的客人，将通过信用卡公司将款项退回原卡；采用现金支付的客人，将退还现金。如由于您的原因造成此退款，退款手续费将由您本人承担。"

//浪漫服务单个视图的宽度
#define ServiceViewWidth    80

#import "ThemeRoomModel.h"  //房间模型

#import "JT3DScrollView.h"  //滚动特效库

#import "RoomContentCell.h"

#import "RomanticServieView.h"  //情趣浪漫服务视图

#import "RoomDeviceView.h"  //自定义情趣设施视图

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库

CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@implementation RoomContentCell

{
    
    UILabel *storyDetail;   //物语描述
    
    UILabel *roomDetail;    //房间详情
    
    UIImageView *hotelLog;  //所属酒店的图标
    
    UILabel *belongHotel;   //所属酒店
    
    NSMutableArray *viewArr;    //保存图片的数组
    
    UILabel *noticeDetail;  //须知详情
    
    NSString *noticeDetailStr;
    
    UIButton *moreBtn;  //查看预订须知详情的按钮

    RoomDeviceView *deviceView; //情趣设施视图
    
    UIView *scrollbackView; //滚动视图的背景
    
    UIImageView *locationLog;   //方位小图标
    
    UIView *backLine5;  //分割框5
    
    ///浪漫服务相关
    NSMutableArray *serviceArr; //浪漫服务数组
    
    NSMutableArray *selectedServiceArr; //被选择的浪漫服务数组
    
    RomanticServieView *serviceView;    //浪漫服务视图
    
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup   //初始化方法
{
    
    if (!selectedServiceArr) {
        
        selectedServiceArr = [NSMutableArray new];
        
    }

    //先统一添加后再布局
    
    
    //物语描述
    storyDetail =[UILabel new];
    [self setUpTheLabe:storyDetail];
//    storyDetail.textAlignment=1;//居中
    [self.contentView addSubview:storyDetail];
    
    
    //分割框2
    UIView *backLine2 =[UIView new];
    [self.contentView addSubview:backLine2];
    backLine2.backgroundColor = RGBA(240, 240, 240, 0.8);
    
    UILabel *serviceLabel = [UILabel new];
    [self setUpTheLabel:serviceLabel AndText:@"浪漫服务"];
    [self.contentView addSubview:serviceLabel];
    
    //浪漫服务
    serviceView =[[RomanticServieView alloc]initWithFrame:CGRectMake(0, 0, Width, 0)];
    [self.contentView addSubview:serviceView];

    
    
    //分割框6(中途加入的)
    UIView *backLine6 =[UIView new];
    [self.contentView addSubview:backLine6];
    backLine6.backgroundColor = RGBA(240, 240, 240, 0.8);
    
    
    //情趣设施
    UILabel *sexFacilities = [UILabel new];
    [self setUpTheLabel:sexFacilities AndText:@"情趣设施"];
    [self.contentView addSubview:sexFacilities];
    
    
    deviceView =[[RoomDeviceView alloc]initWithFrame:CGRectMake(0, 0, Width, 0)];
    [self.contentView addSubview:deviceView];
    
    
    //分割框3
    UIView *backLine3 =[UIView new];
    [self.contentView addSubview:backLine3];
    backLine3.backgroundColor = RGBA(240, 240, 240, 0.8);
    
    
    //预订须知标签
    UILabel *bookNotice =[UILabel new];
    [self setUpTheLabel:bookNotice AndText:@"预订须知"];
    [self.contentView addSubview:bookNotice];
    
    
    //须知详情
    noticeDetail =[UILabel new];
    noticeDetail.textColor=RGBA(100, 100, 100, 1);
    noticeDetail.font=[UIFont systemFontOfSize:15];
    noticeDetail.textAlignment=1;
//    [noticeDetail setText:NoticeDeatailText];
    [self.contentView addSubview:noticeDetail];
    noticeDetail.numberOfLines=0;
    if (maxContentLabelHeight == 0) {   //最多只显示3行
        maxContentLabelHeight = noticeDetail.font.lineHeight * 3;
    }
    
    //"全文按钮"
    moreBtn= [UIButton new];
    [moreBtn setTitle:@"详情" forState:UIControlStateNormal];
    [moreBtn setTitleColor:MainThemeColor forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    moreBtn.layer.borderColor = MainThemeColor.CGColor;
    moreBtn.layer.borderWidth = 1.0;
    moreBtn.layer.cornerRadius = 5.0 ;
    
    
    [self.contentView addSubview:moreBtn];
    
    
    //分割框5
    backLine5 =[UIView new];
    [self.contentView addSubview:backLine5];
    backLine5.backgroundColor = RGBA(240, 240, 240, 0.8);
    
    
    //所属酒店图标
    hotelLog =[UIImageView new];
    [self.contentView addSubview:hotelLog];
    hotelLog.clipsToBounds = YES;
    
    
    //所属酒店
    belongHotel =[UILabel new];
    [self setUpTheLabel:belongHotel AndText:nil];
    [self.contentView addSubview:belongHotel];
    
    //方位
    _location = [UILabel new];
    [self.contentView addSubview:_location];
    _location.textAlignment=1;
    _location.numberOfLines = 0;
    _location.textColor=ContentTextColorNormal;
    _location.font=[UIFont systemFontOfSize:14];
    _location.userInteractionEnabled=YES;
//    _location.backgroundColor=MainThemeColor;
    
    locationLog =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"landmark_icon"]];
    [self.contentView addSubview:locationLog];
    
    
    //其他类似主题标签
    UILabel *otherThemes =[UILabel new];
    otherThemes.font=[UIFont systemFontOfSize:18];
    otherThemes.textColor=[UIColor whiteColor];
    [otherThemes setText:@"         其他类似主题"];
    otherThemes.backgroundColor=[UIColor blackColor];
    
    [self.contentView addSubview:otherThemes];
    
    
    //滚动视图的背景
    scrollbackView =[UIView new];
    [self.contentView addSubview:scrollbackView];
    scrollbackView.backgroundColor=[UIColor blackColor];
    
    
    
    //滚动视图
    [self loadScrollViewWithPageNum:5];
    [scrollbackView addSubview:self.scrollView];
    
    
#pragma mark ----- 设置布局属性
    CGFloat margin = 15;    //间隔
    UIView *contentView = self.contentView; //自身参照物
    
    //物语详情
    storyDetail.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, 10)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    backLine2.sd_layout
    .leftSpaceToView(contentView,0)
    .topSpaceToView(storyDetail,20)
    .rightSpaceToView(contentView,0)
    .heightIs(5);
    
    serviceLabel.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(backLine2, 10)
    .rightSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    
    //浪漫服务
    serviceView.sd_layout
    .topSpaceToView(serviceLabel,margin)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    ;
    
    backLine6.sd_layout
    .leftSpaceToView(contentView,0)
    .topSpaceToView(serviceView,20)
    .rightSpaceToView(contentView,0)
    .heightIs(5);
    
    //情趣设施
    sexFacilities.sd_layout
    .leftSpaceToView(contentView, 10)
    .topSpaceToView(backLine6, 10)
    .rightSpaceToView(contentView, 10)
    .autoHeightRatio(0);
    
    
    deviceView.sd_layout
    .topSpaceToView(sexFacilities,10)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    ;
    
    backLine3.sd_layout
    .leftSpaceToView(contentView,0)
    .topSpaceToView(deviceView,10)
    .rightSpaceToView(contentView,0)
    .heightIs(5);
    
    //预订须知
    bookNotice.sd_layout
    .topSpaceToView(backLine3, 10)
    .leftSpaceToView(contentView,10)
    .rightSpaceToView(contentView,10)
    .autoHeightRatio(0);
    
    
    noticeDetail.sd_layout
    .topSpaceToView(bookNotice, 15)
    .leftSpaceToView(contentView,10)
    .rightSpaceToView(contentView,10)
    .heightIs(maxContentLabelHeight);
    
    // morebutton的高度在setmodel里面设置
    moreBtn.sd_layout
    .centerXEqualToView(contentView)
    .topSpaceToView(noticeDetail, 10)
    .widthIs(50)
    .heightIs(30);
    
    
    backLine5.sd_layout
    .leftSpaceToView(contentView,0)
    .topSpaceToView(moreBtn,margin)
    .rightSpaceToView(contentView,0)
    .heightIs(5);
    
    //酒店所属
    hotelLog.sd_layout
    .widthIs(0)
    .heightEqualToWidth()
    .centerXEqualToView(contentView)
    .topSpaceToView(backLine5,15);
    
    
    belongHotel.sd_layout
    .topSpaceToView(hotelLog, 10)
    .leftSpaceToView(contentView,10)
    .rightSpaceToView(contentView,10)
    .autoHeightRatio(0);
    
    //地理位置
    _location.sd_layout
    .topSpaceToView(belongHotel, 10)
    .centerXEqualToView(contentView)
    .autoHeightRatio(0);
    //单行文本宽度自适应
    [_location setSingleLineAutoResizeWithMaxWidth:Width*3/4];
    
    
    //其他类似酒店推荐
    otherThemes.sd_layout
    .topSpaceToView(_location,20)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
//    .autoHeightRatio(0)
    .heightIs(40)
    ;
    
    scrollbackView.sd_layout
    .topSpaceToView(otherThemes,0)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    .heightIs(_scrollView.frame.size.width*3/4+20)
    ;
    
    _scrollView.sd_layout
    .topSpaceToView(scrollbackView,0)
    .heightIs(_scrollView.frame.size.width*3/4)
    .centerXEqualToView(scrollbackView)
    ;
    
    //参照某一高度进行布局
    [self setupAutoHeightWithBottomView:scrollbackView bottomMargin:15];    //此处必须使用self，否则会计算失败
    
}




-(void)setModel:(ThemeRoomModel *)model
{
    
//    NSLog(@"model:%@",model);

    _model=model;
    
    [storyDetail setText:model.roomStory];      //物语
    
    [noticeDetail setText:model.stayNotice];    //须知
    
    [belongHotel setText:model.belongHotel];
    
    if (model.belongHotelLogSrc) {              //log
        
//        NSString *logUrlStr = [MainUrl stringByAppendingString:model.belongHotelLogSrc];
//        
//        [hotelLog sd_setImageWithURL:[NSURL URLWithString:logUrlStr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(0, 0)];
//
        [hotelLog setImage:[UIImage imageNamed:model.belongHotelLogSrc]];
        
        [hotelLog sd_clearViewFrameCache];
        
        hotelLog.sd_layout
        .widthIs(60)
        .heightEqualToWidth()
        .centerXEqualToView(self.contentView)
        .topSpaceToView(backLine5,15)
        ;
        
        //设置圆角，为宽度的多少倍数
        hotelLog.sd_cornerRadiusFromWidthRatio = @(0.5);
        
//        hotelLog.layer.cornerRadius = hotelLog.frame.size.width/2;
//        hotelLog.layer.borderColor = [UIColor whiteColor].CGColor;
//        hotelLog.layer.borderWidth = 1.0;
        
    }
    
    if (model.location) {
        
        [_location setText:model.location];         //方位
        
        locationLog.sd_layout
        .rightSpaceToView(_location,5)
        .centerYEqualToView(_location)
        .widthIs(15)
        .heightEqualToWidth()
        ;
        
    }else{
    
        [locationLog removeFromSuperview];
    
    }
    
    noticeDetailStr = model.stayNotice;
    
    [moreBtn addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    

//    NSArray *arr = [self creatModelArrWith:9];  //不能超过虚拟数据的总量
    
    [deviceView setUpViewWithDeviceArr:model.roomDevice];   //真实数据
    
//    [self creatArrWithCount:3];    //创建浪漫服务数组
//    
//    selectedServiceArr = [serviceArr mutableCopy];
    
    [serviceView setUpViewWithDeviceArr:model.hotelRomantics];
    
}



#pragma mark ---- 辅助方法

//设置log图标
-(void)sethotelIconImage:(UIImage *)image
{
    
    UIImage *img =[self scaleToSize:image size:CGSizeMake(150, 150)];
    
    UIImage *im =[self cutImage:img WithRadius:5];
    
    [hotelLog setImage:im];
    
}

//对传入的标签做属性修改(主要用于说明标签)
-(void)setUpTheLabel:(UILabel *)label AndText:(NSString *)text
{
    
    label.textAlignment=1;
    label.font=[UIFont systemFontOfSize:18];
    label.textColor=TitleTextColorNormal;
    [label setText:text];
    
}

//对传入的label载体的属性做适当修改(用于未知高度的文字展示)
-(void)setUpTheLabe:(UILabel *)label
{

    label.textColor=RGBA(100, 100, 100, 1);
    label.font=[UIFont systemFontOfSize:15];
    label.numberOfLines = 0;

}



-(void)loadScrollViewWithPageNum:(NSInteger)pageNum   //根据传过来的数量加载滚动视图(使用第三方库)
{
    
    CGFloat scrollViewWidth = Width*3/4;    //滚动视图的宽度
    CGFloat scrollViewHeight= scrollViewWidth*3/4;

    
    _scrollView = [[JT3DScrollView alloc]initWithFrame:CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)];
    
    _scrollView.delegate=self;
    
    _scrollView.effect = 2; //设置滚动特效
    
    _scrollView.translateX = .03;    //修改2张图之间的间距(比例越小则越近)
    
    //设置滚动视图的内容视图大小
    _scrollView.contentSize = CGSizeMake(scrollViewWidth*pageNum, scrollViewHeight);
    
//    viewArr = [[self creatImageViewsWithPageNum:pageNum]mutableCopy];
    
    for (int i=0; i<pageNum; i++) {
        
        
        UIImageView *view =[[UIImageView alloc]initWithFrame:CGRectMake(scrollViewWidth*i ,5, scrollViewWidth, scrollViewHeight)];
        view.userInteractionEnabled=YES;
//        [view setImage:viewArr[i]];
        
        view.tag=i;
        
        view.layer.borderWidth=10;
        view.layer.borderColor=[UIColor whiteColor].CGColor;
        
        
        
        if (!_viewsArr) {
            _viewsArr=[NSMutableArray new];
        }
        
        [_viewsArr addObject:view]; //添加到数组里
        
        [_scrollView addSubview:view];
        
    }
    
}

//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius
{
    UIGraphicsBeginImageContext(orImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+orImage.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+orImage.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, orImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}


//重绘至期望大小(方法3)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


#pragma mark - private actions

- (void)moreButtonClicked
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"预订须知" message:noticeDetailStr delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    
    
    [alert show];
    
}


-(NSArray *)creatModelArrWith:(NSInteger)num   //创建设施模拟数据
{
    
    if (num>6) {
        
        num = 6;
        
    }
    
    NSMutableArray *arr = [NSMutableArray new];
    
    NSArray *deviceNamesArr  = @[
                                 @"智能灯光",
                                
                                 @"吊床",
                                 
                                 @"情趣玩具",
                                 
                                 @"智能音乐",
                                 @"浴缸",
                                 @"情趣内衣",
                                 
                                 ];
    
    NSArray *deviceImagesArr = @[
                                 @"Light_icon",
                                 
                                 @"Hammock_icon",
                                 
                                 @"SexToy_icon",
                                 
                                 @"Music_icon",
                                 @"Bathtub_icon",
                                 @"Sexy underwears_icon",
                                 ];
    
    for (int i=0; i<num; i++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setValue:deviceNamesArr[i] forKey:@"deviceName"];    //设施名
        
        [dic setValue:deviceImagesArr[i] forKey:@"devicePicture"];   //设施图
        
        [arr addObject:dic];
    }
    
    return arr;
    
}

-(void)creatArrWithCount:(NSInteger)num     //创建浪漫服务模拟数据
{
    
    NSArray *titleArr =@[
                         
                         @"热情玫瑰",
                         @"甜蜜告白",
                         @"美味红酒",
                         
                         ];
    
    NSArray *imageArr = @[
                          
                          @"debugimage3.png",
                          @"debugimage2.png",
                          @"debugimage1.png",
                          
                          ];
    
    NSArray *priceArr = @[
                          
                          @"233",
                          @"520",
                          @"1314",
                          
                          ];
    
    
    serviceArr =[NSMutableArray new];
    
    for (int i = 0; i < num; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        [dict setValue:titleArr[arc4random()%titleArr.count] forKey:@"title"];
        [dict setValue:imageArr[arc4random()%imageArr.count] forKey:@"image"];
        [dict setValue:[NSString stringWithFormat:@"%d",100*(i+1)+10*(i+1)+(i+1)] forKey:@"serviceId"];
        [dict setValue:priceArr[arc4random()%priceArr.count] forKey:@"price"];
        
        [serviceArr addObject:dict];
    }
    
}











@end
