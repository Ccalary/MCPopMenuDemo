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
    /** 下方 */
    MCPopMenuDirectionDown = 0,
    /** 上方 */
    MCPopMenuDirectionUp   = 1,
    /** 左侧 */
    MCPopMenuDirectionLeft = 2,
    /** 右侧 */
    MCPopMenuDirectionRight= 3,
};

// 弹窗种类
typedef NS_ENUM(NSUInteger, MCPopViewType){
    MCPopViewTypeText = 0, //文本弹窗
    MCPopViewTypeMenu = 1, //菜单弹窗
};

@class MCPopMenuSetting;
@interface MCPopMenuView : UIView
// 基本属性设置
@property (nonatomic, strong) MCPopMenuSetting *setting;
/**
 初始化方法
 @param anchor 起始点的位置，三角的顶点位置
 @param text 文本内容
 @param width 文本宽度
 @return 初始化对象
 */
- (instancetype)initWithAnchor:(CGPoint)anchor text:(NSString *)text viewWidth:(CGFloat)width;

/**
 文本框初始方法
 @param view 点击的view
 @param text 文本内容
 @param width 文本宽度
 @return 初始化对象
 */
- (instancetype)initFromView:(UIView *)view text:(NSString *)text viewWidth:(CGFloat) width;

/**
 菜单选择初始化方法
 @param view 点击的View
 @param titleArray 标题数组
 @param imageArray 图片数组
 @param width 宽度
 @return 初始化对象
 */
- (instancetype)initFromView:(UIView *)view titleArray:(NSArray <NSString *>*)titleArray imageArray:(NSArray<NSString *>*)imageArray viewWidth:(CGFloat) width;
// 弹出
- (void)popView;

@end

@interface MCPopMenuSetting: NSObject
/** 遮罩颜色，默认 [0,0,0,0.3] */
@property (nonatomic, strong) UIColor *maskColor;
/** view背景色, 默认白色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 圆角，默认5.0 */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 文字颜色，默认blackColor */
@property (nonatomic, strong) UIColor *textColor;
/** 字体大小，默认15.0f */
@property (nonatomic, strong) UIFont *textFont;
/** 文字排布方向，默认left */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** 文本margin大小,例如10.0f，那么左右各5.0f */
@property (nonatomic, assign) CGFloat margin;
/** 箭头方向, 默认 MCPopMenuDirectionDown 朝下 */
@property (nonatomic, assign) MCPopMenuDirection dirction;
/** 菜单row的高度，默认40.0f */
@property (nonatomic, assign) CGFloat rowHeight;
/** 菜单点击时的高亮颜色，默认亮灰色 [UIColor lightGrayColor]*/
@property (nonatomic, strong) UIColor *highlightColor;
/** 菜单分割线的颜色，默认白色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 分割线默认高度，0.5f*/
@property (nonatomic, assign) CGFloat lineHeight;
+ (MCPopMenuSetting *)defaultSetting;
@end
