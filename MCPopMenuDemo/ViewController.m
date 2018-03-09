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
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(300, 100, 100, 50)];
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*2, self.scrollView.frame.size.height*2.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)btnAction:(UIButton *)sender{
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initFromView:sender text:@"Hello World 我是可以滚动的按钮,我的内容在还是挺多的" viewWidth:100];
    menuView.setting.dirction = arc4random()%4;
    [menuView popView];
}

// 右侧加号按钮
- (IBAction)addBtnAction:(UIBarButtonItem *)sender {

    MCPopMenuView *menuView = [[MCPopMenuView alloc] initWithAnchor:CGPointMake(MC_SCREEN_W - 33, 66) text:@"Hello World 我是一个边角提示框" viewWidth:100];
    [menuView popView];
}
// 中间按钮，弹出label
- (IBAction)popLabelAction:(UIButton *)sender {
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initFromView:sender text:@"Hello World 你好欢迎来到我的社区" viewWidth:150];
    menuView.setting.dirction = arc4random()%4;
    menuView.setting.textFont = [UIFont systemFontOfSize:13];
    [menuView popView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initWithAnchor:point text:@"Hello World 我是一个任意位置弹出框，你可以点击屏幕任意位置找到我" viewWidth:150];
    menuView.setting.dirction = MCPopMenuDirectionLeft;
    [menuView popView];
    
}
@end
