//
//  MCPopMenuView.h
//  MCPopMenuDemo
//
//  Created by chh on 2018/3/1.
//  Copyright © 2018年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPopMenuSetting.h"
// 弹窗种类
typedef NS_ENUM(NSUInteger, MCPopViewType){
    MCPopViewTypeText = 0, //文本弹窗
    MCPopViewTypeMenu = 1, //菜单弹窗
};

@protocol MCPopMenuViewDelegate <NSObject>
// 选择某一行
- (void)menuSelectAtIndex:(NSUInteger)index;
@end

@interface MCPopMenuView : UIView
// 基本属性设置
@property (nonatomic, strong) MCPopMenuSetting *setting;
@property (nonatomic, weak) id<MCPopMenuViewDelegate> delegate;
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

/**
 菜单选择初始化方法
 @param view 点击的View
 @param titleArray 标题数组
 @param width 宽度
 @return 初始化对象
 */
- (instancetype)initFromView:(UIView *)view titleArray:(NSArray <NSString *>*)titleArray viewWidth:(CGFloat) width;

// 弹出
- (void)popView;
// 消失
- (void)dismissView;
@end

