//
//  shouyeViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "shouyeViewController.h"
#import "UIButton+CenterImageAndTitle.h"

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height      //屏幕高度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width      //屏幕宽度

@interface shouyeViewController ()

@end

@implementation shouyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake((kScreenWidth/4)-45, (kScreenHeight/4), 70, 70);

    
    [button1.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button1.layer setCornerRadius:10];
    [button1.layer setBorderWidth:2];//设置边界的宽度
    //设置按钮的边界颜色
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,1,1,1});
    [button1.layer setBorderColor:color];
    
    
    button1.backgroundColor = [UIColor yellowColor];
    [button1 setImage:[UIImage imageNamed:@"signfor"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth/4)-45, (kScreenHeight/4)+60, 80, 80)];
    //设置背景色
    label1.backgroundColor = [UIColor clearColor];
    //设置标签文本
    label1.text = @"签收功能";
    //设置标签文本字体和字体大小
    label1.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label1];
    

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake((kScreenWidth/2)-35, (kScreenHeight/4), 70, 70);
    
    [button2.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button2.layer setCornerRadius:10];
    [button2.layer setBorderWidth:2];//设置边界的宽度
    //设置按钮的边界颜色
    CGColorSpaceRef colorSpaceRef2 = CGColorSpaceCreateDeviceRGB();
    CGColorRef color2 = CGColorCreate(colorSpaceRef2, (CGFloat[]){1,1,1,1});
    [button2.layer setBorderColor:color2];
    
    button2.backgroundColor = [UIColor yellowColor];
    [button2 setImage:[UIImage imageNamed:@"uploadimg"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showpicreload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth/2)-35, (kScreenHeight/4)+60, 80, 80)];
    //设置背景色
    label2.backgroundColor = [UIColor clearColor];
    //设置标签文本
    label2.text = @"图片补传";
    //设置标签文本字体和字体大小
    label2.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label2];
    
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(((kScreenWidth/4)*3)-25, (kScreenHeight/4), 70, 70);
    
    [button3.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button3.layer setCornerRadius:10];
    [button3.layer setBorderWidth:2];//设置边界的宽度
    //设置按钮的边界颜色
    CGColorSpaceRef colorSpaceRef3 = CGColorSpaceCreateDeviceRGB();
    CGColorRef color3 = CGColorCreate(colorSpaceRef3, (CGFloat[]){1,1,1,1});
    [button3.layer setBorderColor:color3];
    
    button3.backgroundColor = [UIColor yellowColor];
    [button3 setImage:[UIImage imageNamed:@"lookup"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(picmanagebtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(((kScreenWidth/4)*3)-25, (kScreenHeight/4)+60, 80, 80)];
    //设置背景色
    label3.backgroundColor = [UIColor clearColor];
    //设置标签文本
    label3.text = @"图片管理";
    //设置标签文本字体和字体大小
    label3.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label3];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sign:(id)sender
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signid"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];

}

- (IBAction)picmanagebtn:(id)sender
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"picmanage"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}


- (IBAction)showpicreload:(id)sender
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"picreload"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}

- (IBAction)backtologin:(id)sender
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}

- (IBAction)bangzhu:(id)sender
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"jieshao"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}


@end
