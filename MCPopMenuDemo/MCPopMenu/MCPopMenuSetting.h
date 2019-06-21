//
//  MCPopMenuSetting.h
//  MCPopMenuDemo
//
//  Created by caohouhong on 2019/6/21.
//  Copyright © 2019 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
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
@interface MCPopMenuSetting : NSObject
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
/** 菜单分割线的颜色，默认白色 */
@property (nonatomic, strong) UIColor *separateColor;
/** 最多展示菜单个数，默认4个，如果设置为0则根据个数展示 */
@property (nonatomic, assign) int maxNumber;
/** 固定菜单高度，默认0个，如果设置为0则不固定，其他则行高*个数 */
@property (nonatomic, assign) int fixedNumber;
/** 菜单是否可滑动 默认可滑动 */
@property (nonatomic, assign) BOOL menuScrollEnable;
+ (MCPopMenuSetting *)defaultSetting;
@end

NS_ASSUME_NONNULL_END
