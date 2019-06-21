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

@interface ViewController ()<MCPopMenuViewDelegate>
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
//弹出可滑动菜单
- (IBAction)popScrollMenu:(UIButton *)sender {
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initFromView:sender titleArray:@[@"发起群聊",@"扫一扫",@"摇一摇",@"加好友",@"收款",@"付款"] viewWidth:100];
    menuView.delegate = self;
    menuView.setting.rowHeight = 30;
    [menuView popView];
}
//弹出常规不可滑动菜单
- (IBAction)popNormalMenu:(UIButton *)sender {
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initFromView:sender titleArray:@[@"发起群聊",@"扫一扫",@"摇一摇"] imageArray:@[@"add_22",@"add_22",@"add_22"] viewWidth:120];
    menuView.setting.menuScrollEnable = NO;
    menuView.setting.maxNumber = 0;
    [menuView popView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    MCPopMenuView *menuView = [[MCPopMenuView alloc] initWithAnchor:point text:@"Hello World 我是一个任意位置弹出框，你可以点击屏幕任意位置找到我" viewWidth:150];
    menuView.setting.dirction = MCPopMenuDirectionLeft;
    [menuView popView];
    
}

- (void)menuSelectAtIndex:(NSUInteger)index {
    NSLog(@"%@", [NSString stringWithFormat:@"选择了第%lu行",(unsigned long)index]);
}
@end
