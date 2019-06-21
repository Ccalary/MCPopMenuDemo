//
//  MCMenuTableView.m
//  MCPopMenuDemo
//
//  Created by caohouhong on 2019/6/21.
//  Copyright © 2019 chh. All rights reserved.
//

#import "MCMenuTableView.h"


@interface MCMenuTableView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation MCMenuTableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)    style:UITableViewStylePlain];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    MCMenuTableViewCell *cell = (MCMenuTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MCMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell.contentButton setTitle:self.textArray[indexPath.row] forState:UIControlStateNormal];
    if (self.imageArray.count == self.textArray.count){
        [cell.contentButton setImage:[UIImage imageNamed:self.imageArray[indexPath.row]] forState:UIControlStateNormal];
        cell.contentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        cell.contentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        cell.contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    cell.contentButton.titleLabel.font = self.menuSetting.textFont;
    [cell.contentButton setTitleColor:self.menuSetting.textColor forState:UIControlStateNormal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.menuSetting.rowHeight ?: 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock){
        self.selectBlock(indexPath.row);
    }
}

- (void)setTextArray:(NSArray<NSString *> *)textArray {
    _textArray = textArray;
     [self.tableView reloadData];
}

- (void)setImageArray:(NSArray<NSString *> *)imageArray {
    _imageArray = imageArray;
     [self.tableView reloadData];
}

- (void)setMenuSetting:(MCPopMenuSetting *)menuSetting {
    _menuSetting = menuSetting;
    _tableView.scrollEnabled = menuSetting.menuScrollEnable;
    _tableView.separatorColor = menuSetting.separateColor;
    [self.tableView reloadData];
}

@end

#pragma Mark - Cell
@interface MCMenuTableViewCell()

@end
@implementation MCMenuTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView {
    _contentButton = [[UIButton alloc] init];
    _contentButton.userInteractionEnabled = NO;
    _contentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_contentButton];
//            [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
//            [button setTitleColor:self.setting.textColor forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
//            button.titleLabel.font = self.setting.textFont;
//            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//            [button setBackgroundImage:[self imageWithColor:self.setting.backgroundColor] forState:UIControlStateNormal];
//            [bgView addSubview:button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentButton.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

@end
