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
#define TRIANGLE_HEIGHT   5.0f // 箭头的高度
#define MC_SCREEN_MARGIN  10.0f //距离屏幕边缘最小距离

@interface MCPopMenuView()
@property (nonatomic, strong) UIView *bgHoldView;
@property (nonatomic, assign) CGPoint anchor;
@property (nonatomic, assign) CGFloat v_width; //菜单的宽度
@property (nonatomic, assign) CGFloat v_height; //菜单的高度
@property (nonatomic, strong) UIView *anchorView; //目标View
@property (nonatomic, strong) NSString *content; //文本内容
@end

@implementation MCPopMenuView
/**
 初始化方法
 @param anchor 起始点的位置，三角的顶点位置
 @param width 宽度
 @param height 高度
 @return 初始化对象
 */
- (instancetype)initWithAnchor:(CGPoint)anchor Width:(CGFloat)width Height:(CGFloat)height{
    if (self = [super initWithFrame:CGRectMake(0, 0, MC_SCREEN_W, MC_SCREEN_H)]){
        self.anchor = anchor;
        self.v_width = width;
        self.v_height = height;
        [self initView];
    }
    return self;
}

- (instancetype)initFromView:(UIView *)view text:(NSString *)text {
    return [self initFromView:view text:text viewWidth:100];
}

- (instancetype)initFromView:(UIView *)view text:(NSString *)text viewWidth:(CGFloat) width{
    if (self = [super initWithFrame:CGRectMake(0, 0, MC_SCREEN_W, MC_SCREEN_H)]){
        self.anchorView = view;
        self.v_width = width;
        self.content = text;
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
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX-self.v_width/2.0, startY+TRIANGLE_HEIGHT, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
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
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX-self.v_width/2.0, startY-TRIANGLE_HEIGHT-self.v_height, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
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
        //宽度过大自适应
        if ((self.v_width + TRIANGLE_HEIGHT) > startX){
            self.v_width = startX - MC_SCREEN_MARGIN - TRIANGLE_HEIGHT;
        }
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX-self.v_width-TRIANGLE_HEIGHT, startY-self.v_height/2.0, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
        [bezierPath moveToPoint:CGPointMake(startX-TRIANGLE_HEIGHT, startY-TRIANGLE_HEIGHT)];
        [bezierPath addLineToPoint:CGPointMake(startX, startY)];
        [bezierPath addLineToPoint:CGPointMake(startX-TRIANGLE_HEIGHT, startY+TRIANGLE_HEIGHT)];
        shapeLayer.path = bezierPath.CGPath;
        //确定文本位置
        textLabel.frame = CGRectMake(0, 0, self.v_width - self.setting.margin, self.v_height);
        [textLabel sizeToFit];
        textLabel.center = CGPointMake(bezierPath.bounds.origin.x + bezierPath.bounds.size.width/2.0 - TRIANGLE_HEIGHT/2.0, bezierPath.bounds.origin.y + bezierPath.bounds.size.height/2.0);
    }else {
        //箭头顶点
        self.anchor = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.0);
        CGFloat startX = self.anchor.x;
        CGFloat startY = self.anchor.y;
        //宽度过大自适应
        if ((self.v_width + TRIANGLE_HEIGHT) > (MC_SCREEN_W - startX)){
            self.v_width = MC_SCREEN_W - startX - TRIANGLE_HEIGHT - MC_SCREEN_MARGIN;
        }
        //绘制背景区域
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX+TRIANGLE_HEIGHT, startY-self.v_height/2.0, self.v_width, self.v_height) cornerRadius:self.setting.cornerRadius];
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

- (void)tapAction {
    [self removeFromSuperview];
}

// 根据宽度计算高度
- (CGFloat)calculateRowHeight:(NSString *)string font:(UIFont *)font width:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName:font};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
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
    setting.margin = 10.0f;
    setting.dirction = MCPopMenuDirectionDown; // 箭头方向
    return setting;
}
@end
