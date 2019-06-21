//
//  MCMenuTableView.h
//  MCPopMenuDemo
//
//  Created by caohouhong on 2019/6/21.
//  Copyright © 2019 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPopMenuSetting.h"
@class MCMenuTableViewCell;
NS_ASSUME_NONNULL_BEGIN

typedef void(^rowSelectBlock)(NSUInteger row);

@interface MCMenuTableView : UIView
@property (nonatomic, strong) NSArray<NSString*> *textArray;
@property (nonatomic, strong) NSArray<NSString*> *imageArray;
@property (nonatomic, copy) rowSelectBlock selectBlock;
@property (nonatomic, strong) MCPopMenuSetting *menuSetting;
@end

@interface MCMenuTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *contentButton;
@end
NS_ASSUME_NONNULL_END
