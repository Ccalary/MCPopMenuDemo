//
//  MCPopMenuView.m
//  MCPopMenuDemo
//
//  Created by chh on 2018/3/1.
//  Copyright © 2018年 chh. All rights reserved.
//


#import "MCPopMenuView.h"

#define MC_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define MC_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define TRIANGLE_HEIGHT   5.0f // 箭头的高度,半个宽度
#define MC_SCREEN_MARGIN  10.0f //距离屏幕边缘最小距离

@interface MCPopMenuView()
@property (nonatomic, strong) UIView *bgHoldView;
@property (nonatomic, assign) MCPopViewType viewType; // 弹窗种类
@property (nonatomic, assign) CGPoint anchor;
@property (nonatomic, assign) CGFloat v_width, v_temWidth; //菜单的宽度
@property (nonatomic, assign) CGFloat v_height; //菜单的高度
@property (nonatomic, strong) UIView *anchorView; //目标View
@property (nonatomic, strong) NSString *content; //文本内容

@property (nonatomic, strong) NSArray *titleArray; //资源数组
@property (nonatomic, strong) NSArray *imageArray; //图片数组
@end

@implementation MCPopMenuView

- (instancetype)initWithAnchor:(CGPoint)anchor text:(NSString *)text viewWidth:(CGFloat)width{
    if (self = [super initWithFrame:CGRectMake(0, 0, MC_SCREEN_W, MC_SCREEN_H)]){
        self.anchorView = [[UIView alloc] initWithFrame:CGRectMake(anchor.x, anchor.y, 1, 1)];
        self.v_temWidth = width;
        self.content = text;
        self.viewType = MCPopViewTypeText;
        [self initView];
    }
    return self;
}

- (instancetype)initFromView:(UIView *)view text:(NSString *)text viewWidth:(CGFloat) width{
    if (self = [super initWithFrame:CGRectMake(0, 0, MC_SCREEN_W, MC_SCREEN_H)]){
        self.anchorView = view;
        self.v_temWidth = width;
        self.content = text;
        self.viewType = MCPopViewTypeText;
        [self initView];
    }
    return self;
}

- (instancetype)initFromView:(UIView *)view titleArray:(NSArray <NSString *>*)titleArray imageArray:(NSArray<NSString *>*)imageArray viewWidth:(CGFloat) width{
    if (self = [super initWithFrame:CGRectMake(0, 0, MC_SCREEN_W, MC_SCREEN_H)]){
        self.anchorView = view;
        self.v_temWidth = width;
        self.titleArray = titleArray;
        self.imageArray = imageArray;
        //增加断言
        NSAssert((self.titleArray.count == self.imageArray.count), @"MCPopMenuView titleArray count must equal to imageArray count");
        self.viewType = MCPopViewTypeMenu;
        [self initView];
    }
    return self;
}

- (void)initView{
    self.setting = [MCPopMenuSetting defaultSetting];
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:atap];
}

- (void)popView{
    if (self.viewType == MCPopViewTypeText){
        [self popTextView];
    }else if (self.viewType == MCPopViewTypeMenu){
        [self popMenuView];
    }
}

- (void)tapAction {
    [self removeFromSuperview];
}

#pragma mark - 弹出文本框
- (void)popTextView{
    [self removeFromSuperview];
    self.v_width = self.v_temWidth;
    self.backgroundColor = self.setting.maskColor;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    CGFloat text_height = [self calculateRowHeight:self.content font:self.setting.textFont width:self.v_width - self.setting.margin];
    self.v_height = text_height + self.setting.margin;
  
    // 形状绘制
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = self.setting.backgroundColor.CGColor;
    [self.layer addSublayer:shapeLayer];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 0;
    textLabel.text = self.content;
    textLabel.textAlignment = self.setting.textAlignment;
    textLabel.font = self.setting.textFont;
    textLabel.textColor = self.setting.textColor;
    [self addSubview:textLabel];
    // 获得转化后的rect
    CGRect rect = [self convertRect:self.anchorView.frame fromView:self.anchorView.superview];
 
    // 箭头在下面
    if (self.setting.dirction == MCPopMenuDirectionDown){
        //箭头顶点
        self.anchor = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height);
        CGFloat startX = self.anchor.x;
        CGFloat startY = self.anchor.y;
        CGFloat rectX = startX-self.v_width/2.0;
        CGFloat rectY = startY+TRIANGLE_HEIGHT;
        //箭头越界
        CGFloat arrowLeft = MC_SCREEN_MARGIN + TRIANGLE_HEIGHT + self.setting.cornerRadius;
        CGFloat arrowRight = MC_SCREEN_W - MC_SCREEN_MARGIN - TRIANGLE_HEIGHT - self.setting.cornerRadius;
        if (startX < arrowLeft){
            startX = arrowLeft ;
        }else if (startX > arrowRight){
            startX = arrowRight;
        }
        //View越界
        if (rectX < MC_SCREEN_MARGIN){ // 左侧
            rectX = MC_SCREEN_MARGIN;
        }else if (rectX > (MC_SCREEN_W - MC_SCREEN_MARGIN - self.v_width)){ //右侧
            rectX = MC_SCREEN_W - MC_SCREEN_MARGIN - self.v_width;
        }
        if (rectY > (MC_SCREEN_H - self.v_height - MC_SCREEN_MARGIN)){ // 下面
            self.setting.dirction = MCPopMenuDirectionUp;//转换箭头方向
            [self popView];
            return;
        }
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rectX, rectY, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
        [bezierPath moveToPoint:CGPointMake(startX-TRIANGLE_HEIGHT, startY+TRIANGLE_HEIGHT)];
        [bezierPath addLineToPoint:CGPointMake(startX, startY)];
        [bezierPath addLineToPoint:CGPointMake(startX+TRIANGLE_HEIGHT, startY+TRIANGLE_HEIGHT)];
        shapeLayer.path = bezierPath.CGPath;
        //确定文本位置
        textLabel.frame = CGRectMake(0, 0, self.v_width - self.setting.margin, self.v_height);
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(bezierPath.bounds.origin.x + bezierPath.bounds.size.width/2.0, bezierPath.bounds.origin.y + bezierPath.bounds.size.height/2.0 + TRIANGLE_HEIGHT/2.0);
       
    }else if (self.setting.dirction == MCPopMenuDirectionUp){ // 箭头在上面
        //箭头顶点
        self.anchor = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y);
        CGFloat startX = self.anchor.x;
        CGFloat startY = self.anchor.y;
        CGFloat rectX = startX-self.v_width/2.0;
        CGFloat rectY = startY-TRIANGLE_HEIGHT-self.v_height;
        //箭头越界
        CGFloat arrowLeft = MC_SCREEN_MARGIN + TRIANGLE_HEIGHT + self.setting.cornerRadius;
        CGFloat arrowRight = MC_SCREEN_W - MC_SCREEN_MARGIN - TRIANGLE_HEIGHT - self.setting.cornerRadius;
        if (startX < arrowLeft){
            startX = arrowLeft ;
        }else if (startX > arrowRight){
            startX = arrowRight;
        }
        //View越界处理
        if (rectX < MC_SCREEN_MARGIN){ // 左侧
            rectX = MC_SCREEN_MARGIN;
        }else if (rectX > (MC_SCREEN_W - MC_SCREEN_MARGIN - self.v_width)){ //右侧
            rectX = MC_SCREEN_W - MC_SCREEN_MARGIN - self.v_width;
        }
        if (rectY < MC_SCREEN_MARGIN){ // 下面
            self.setting.dirction = MCPopMenuDirectionDown;//转换箭头方向
            [self popView];
            return;
        }
        
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rectX, rectY, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
        [bezierPath moveToPoint:CGPointMake(startX-TRIANGLE_HEIGHT, startY-TRIANGLE_HEIGHT)];
        [bezierPath addLineToPoint:CGPointMake(startX, startY)];
        [bezierPath addLineToPoint:CGPointMake(startX+TRIANGLE_HEIGHT, startY-TRIANGLE_HEIGHT)];
        shapeLayer.path = bezierPath.CGPath;
        //确定文本位置
        textLabel.frame = CGRectMake(0, 0, self.v_width - self.setting.margin, self.v_height);
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(bezierPath.bounds.origin.x + bezierPath.bounds.size.width/2.0, bezierPath.bounds.origin.y + bezierPath.bounds.size.height/2.0 - TRIANGLE_HEIGHT/2.0);
        
    }else if (self.setting.dirction == MCPopMenuDirectionLeft){
        //箭头顶点
        self.anchor = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height/2.0);
        CGFloat startX = self.anchor.x;
        CGFloat startY = self.anchor.y;
        //箭头越界
        CGFloat arrowTop = MC_SCREEN_MARGIN + TRIANGLE_HEIGHT + self.setting.cornerRadius;
        CGFloat arrowBottom = MC_SCREEN_H - MC_SCREEN_MARGIN - TRIANGLE_HEIGHT - self.setting.cornerRadius;
        if (startY < arrowTop){
            startX = arrowTop ;
        }else if (startY > arrowBottom){
            startY = arrowBottom;
        }
        //左侧越界处理
        if (startX < (self.v_width + TRIANGLE_HEIGHT + MC_SCREEN_MARGIN)){
            self.v_width = startX - MC_SCREEN_MARGIN - TRIANGLE_HEIGHT;
            //调整高度
            CGFloat text_height = [self calculateRowHeight:self.content font:self.setting.textFont width:self.v_width - self.setting.margin];
            self.v_height = text_height + self.setting.margin;
            //宽度过窄，小于一行文字
            BOOL lessWidth = self.v_width < (self.setting.margin + self.setting.textFont.pointSize);
            //高度过高，大于屏幕的6/10
            BOOL tooHeigh = self.v_height > MC_SCREEN_H*0.6;
            if (lessWidth || tooHeigh){
                self.setting.dirction = MCPopMenuDirectionRight;
                [self popView];
                return;
            }
        }
        CGFloat rectX = startX-self.v_width-TRIANGLE_HEIGHT;
        CGFloat rectY = startY-self.v_height/2.0;
        if (rectY < MC_SCREEN_MARGIN){//上方
            rectY = MC_SCREEN_MARGIN;
        }else if (rectY > (MC_SCREEN_H - self.v_height - MC_SCREEN_MARGIN)){//下方
            rectY = MC_SCREEN_H - self.v_height - MC_SCREEN_MARGIN;
        }
        
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rectX, rectY, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
        [bezierPath moveToPoint:CGPointMake(startX-TRIANGLE_HEIGHT, startY-TRIANGLE_HEIGHT)];
        [bezierPath addLineToPoint:CGPointMake(startX, startY)];
        [bezierPath addLineToPoint:CGPointMake(startX-TRIANGLE_HEIGHT, startY+TRIANGLE_HEIGHT)];
        shapeLayer.path = bezierPath.CGPath;
        //确定文本位置
        textLabel.frame = CGRectMake(0, 0, self.v_width - self.setting.margin, self.v_height);
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(bezierPath.bounds.origin.x + bezierPath.bounds.size.width/2.0 - TRIANGLE_HEIGHT/2.0, bezierPath.bounds.origin.y + bezierPath.bounds.size.height/2.0);
    }else if (self.setting.dirction == MCPopMenuDirectionRight){
        //箭头顶点
        self.anchor = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.0);
        CGFloat startX = self.anchor.x;
        CGFloat startY = self.anchor.y;
        //箭头越界
        CGFloat arrowTop = MC_SCREEN_MARGIN + TRIANGLE_HEIGHT + self.setting.cornerRadius;
        CGFloat arrowBottom = MC_SCREEN_H - MC_SCREEN_MARGIN - TRIANGLE_HEIGHT - self.setting.cornerRadius;
        if (startY < arrowTop){
            startX = arrowTop ;
        }else if (startY > arrowBottom){
            startY = arrowBottom;
        }
        //右侧越界处理
        if (startX > (MC_SCREEN_W - TRIANGLE_HEIGHT - self.v_width - MC_SCREEN_MARGIN)){
            self.v_width = MC_SCREEN_W - startX - TRIANGLE_HEIGHT - MC_SCREEN_MARGIN;
            //调整高度
            CGFloat text_height = [self calculateRowHeight:self.content font:self.setting.textFont width:self.v_width - self.setting.margin];
            self.v_height = text_height + self.setting.margin;
            //宽度过窄，小于一行文字
            BOOL lessWidth = self.v_width < (self.setting.margin + self.setting.textFont.pointSize);
            //高度过高，大于屏幕的6/10
            BOOL tooHeigh = self.v_height > MC_SCREEN_H*0.6;
            if (lessWidth || tooHeigh){
                self.setting.dirction = MCPopMenuDirectionLeft;
                [self popView];
                return;
            }
        }
        CGFloat rectX = startX+TRIANGLE_HEIGHT;
        CGFloat rectY = startY-self.v_height/2.0;
        if (rectY < MC_SCREEN_MARGIN){//上方
            rectY = MC_SCREEN_MARGIN;
        }else if (rectY > (MC_SCREEN_H - self.v_height - MC_SCREEN_MARGIN)){//下方
            rectY = MC_SCREEN_H - self.v_height - MC_SCREEN_MARGIN;
        }
        
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rectX, rectY, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
        [bezierPath moveToPoint:CGPointMake(startX+TRIANGLE_HEIGHT, startY-TRIANGLE_HEIGHT)];
        [bezierPath addLineToPoint:CGPointMake(startX, startY)];
        [bezierPath addLineToPoint:CGPointMake(startX+TRIANGLE_HEIGHT, startY+TRIANGLE_HEIGHT)];
        shapeLayer.path = bezierPath.CGPath;
        //确定文本位置
        textLabel.frame = CGRectMake(0, 0, self.v_width - self.setting.margin, self.v_height);
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(bezierPath.bounds.origin.x + bezierPath.bounds.size.width/2.0 + TRIANGLE_HEIGHT/2.0, bezierPath.bounds.origin.y + bezierPath.bounds.size.height/2.0);
    }
}

#pragma mark - 弹出菜单选择框
- (void)popMenuView{
    [self removeFromSuperview];
    self.v_width = self.v_temWidth;
    self.v_height = (self.setting.rowHeight)*self.titleArray.count - self.setting.lineHeight;// + self.setting.cornerRadius;
    self.backgroundColor = self.setting.maskColor;
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    // 形状绘制
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = self.setting.backgroundColor.CGColor;
    [self.layer addSublayer:shapeLayer];
    
    // 获得转化后的rect
    CGRect rect = [self convertRect:self.anchorView.frame fromView:self.anchorView.superview];
    
    //箭头顶点
    self.anchor = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height);
    CGFloat startX = self.anchor.x;
    CGFloat startY = self.anchor.y;
    CGFloat rectX = startX-self.v_width/2.0;
    CGFloat rectY = startY+TRIANGLE_HEIGHT;
    //箭头越界
    CGFloat arrowLeft = MC_SCREEN_MARGIN + TRIANGLE_HEIGHT + self.setting.cornerRadius;
    CGFloat arrowRight = MC_SCREEN_W - MC_SCREEN_MARGIN - TRIANGLE_HEIGHT - self.setting.cornerRadius;
    if (startX < arrowLeft){
        startX = arrowLeft ;
    }else if (startX > arrowRight){
        startX = arrowRight;
    }
    //View越界
    if (rectX < MC_SCREEN_MARGIN){ // 左侧
        rectX = MC_SCREEN_MARGIN;
    }else if (rectX > (MC_SCREEN_W - MC_SCREEN_MARGIN - self.v_width)){ //右侧
        rectX = MC_SCREEN_W - MC_SCREEN_MARGIN - self.v_width;
    }
    if (rectY > (MC_SCREEN_H - self.v_height - MC_SCREEN_MARGIN)){ // 下面
        self.setting.dirction = MCPopMenuDirectionUp;//转换箭头方向
        [self popView];
        return;
    }
    //绘制背景区域
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rectX, rectY, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
    [bezierPath moveToPoint:CGPointMake(startX-TRIANGLE_HEIGHT, startY+TRIANGLE_HEIGHT)];
    [bezierPath addLineToPoint:CGPointMake(startX, startY)];
    [bezierPath addLineToPoint:CGPointMake(startX+TRIANGLE_HEIGHT, startY+TRIANGLE_HEIGHT)];
    shapeLayer.path = bezierPath.CGPath;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(rectX, rectY, self.v_width, self.v_height)];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.layer.cornerRadius = self.setting.cornerRadius;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    for (int i = 0; i < self.titleArray.count; i++){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*self.setting.rowHeight, self.v_width, self.setting.rowHeight - self.setting.lineHeight)];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:self.setting.textColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        button.titleLabel.font = self.setting.textFont;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [button setBackgroundImage:[self imageWithColor:self.setting.backgroundColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageWithColor:self.setting.highlightColor] forState:UIControlStateHighlighted];
        [bgView addSubview:button];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1)*self.setting.rowHeight-self.setting.lineHeight, self.v_width, self.setting.lineHeight)];
        lineView.backgroundColor = self.setting.lineColor;
        lineView.hidden = (i == self.titleArray.count - 1) ? YES : NO;
        [bgView addSubview:lineView];
    }
}

// 根据宽度计算高度
- (CGFloat)calculateRowHeight:(NSString *)string font:(UIFont *)font width:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName:font};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
// 颜色转成image
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

#pragma mark - defaultSetting，默认设置
@interface MCPopMenuSetting()

@end
@implementation MCPopMenuSetting
+ (MCPopMenuSetting *)defaultSetting {
    MCPopMenuSetting *setting = [[MCPopMenuSetting alloc] init];
    setting.maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]; // 遮罩背景色
    setting.backgroundColor = [UIColor whiteColor]; // 背景色
    setting.cornerRadius = 5.0; //圆角
    setting.textColor = [UIColor blackColor]; //字体颜色
    setting.textFont = [UIFont systemFontOfSize:15.0f]; //字体大小
    setting.textAlignment = NSTextAlignmentLeft;
    setting.margin = 10.0f; // 文本间距
    setting.dirction = MCPopMenuDirectionDown; // 箭头方向
    setting.rowHeight = 40.0f; // 菜单行高
    setting.highlightColor = [UIColor lightGrayColor]; // 菜单高亮颜色
    setting.lineColor = [UIColor whiteColor]; //分割线颜色
    setting.lineHeight = 0.5f; // 分割线高度
    return setting;
}
@end
