//
//  ViewController.m
//  MCPopMenuDemo
//
//  Created by chh on 2018/3/1.
//  Copyright © 2018年 chh. All rights reserved.
//

#import "ViewController.h"
#import "MCPopMenuView.h"

#define MC_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define MC_SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *PopLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80, 100, 100, 50)];
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height*2.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)btnAction:(UIButton *)sender{
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initFromView:sender text:@"Hello World 我是可以滚动的按钮" viewWidth:100];
    menuView.setting.dirction = arc4random()%4;
    menuView.setting.textFont = [UIFont systemFontOfSize:13];
    [menuView popView];
}

// 右侧加号按钮
- (IBAction)addBtnAction:(UIBarButtonItem *)sender {
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initWithAnchor:CGPointMake(MC_SCREEN_W - 50, 66) Width:60 Height:100];
    [menuView popView];
}
// 中间按钮，弹出label
- (IBAction)popLabelAction:(UIButton *)sender {
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initFromView:sender text:@"Hello World 你好欢迎来到我的社区"];
    menuView.setting.dirction = arc4random()%4;
    menuView.setting.textFont = [UIFont systemFontOfSize:13];
    [menuView popView];
}
@end
