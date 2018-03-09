//
//  MCPopMenuView.h
//  MCPopMenuDemo
//
//  Created by chh on 2018/3/1.
//  Copyright © 2018年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
// 箭头所在的方向
typedef NS_ENUM(NSInteger, MCPopMenuDirection){
    MCPopMenuDirectionDown = 0,   // 下方
    MCPopMenuDirectionUp   = 1,   // 上方
    MCPopMenuDirectionLeft = 2,   // 左侧
    MCPopMenuDirectionRight= 3,   // 右侧
};

@class MCPopMenuSetting;
@interface MCPopMenuView : UIView
// 基本属性设置
@property (nonatomic, strong) MCPopMenuSetting *setting;
/**
 初始化方法
 @param anchor 起始点的位置，三角的顶点位置
 @param width 宽度
 @param height 高度
 @return 初始化对象
 */
- (instancetype)initWithAnchor:(CGPoint)anchor Width:(CGFloat)width Height:(CGFloat)height;

/**
 文本框初始方法
 @param view 点击的view
 @param text 文本内容
 @param width 文本宽度
 @return 初始化对象
 */
- (instancetype)initFromView:(UIView *)view text:(NSString *)text viewWidth:(CGFloat) width;

- (instancetype)initFromView:(UIView *)view text:(NSString *)text;

// 弹出
- (void)popView;

@end

@interface MCPopMenuSetting: NSObject
@property (nonatomic, strong) UIColor *maskColor;       // 遮罩颜色，默认 [0,0,0,0.3];
@property (nonatomic, strong) UIColor *backgroundColor; // view背景色, 默认白色
@property (nonatomic, assign) CGFloat cornerRadius;     // 圆角，默认5.0
@property (nonatomic, strong) UIColor *textColor;       // 文字颜色，默认blackColor
@property (nonatomic, strong) UIFont *textFont;         // 字体大小，默认15.0f
@property (nonatomic, assign) NSTextAlignment textAlignment; // 文字排布方向，默认left
@property (nonatomic, assign) CGFloat margin;           // 文本margin大小
@property (nonatomic, assign) MCPopMenuDirection dirction; // 箭头方向, 默认 MCPopMenuDirectionDown
+ (MCPopMenuSetting *)defaultSetting;
@end
