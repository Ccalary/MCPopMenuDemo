//
//  MCPopMenuSetting.m
//  MCPopMenuDemo
//
//  Created by caohouhong on 2019/6/21.
//  Copyright © 2019 chh. All rights reserved.
//

#import "MCPopMenuSetting.h"

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
    setting.maxNumber = 4;
    setting.fixedNumber = 0; // 固定菜单个数
    setting.menuScrollEnable = YES; // 默认可滑动
    return setting;
}
@end
