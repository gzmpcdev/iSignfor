//
//  linkViewController.m
//  iSignfor
//
//  Created by pro on 16/1/29.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "linkViewController.h"

@interface linkViewController ()

@end

@implementation linkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

+(NSString *)viewcontrollerlogin//登陆
{
    return @"http://125.88.8.30:8888/AndroidWebservice/signforLoginPort";
}


+(NSString *)signviewcontroller//查询签收单
{
    return @"http://125.88.8.30:8888/AndroidWebservice/SingforBAPort";
}

+(NSString *)quedingviewcontroller//确定按钮
{
    return @"http://125.88.8.30:8888/AndroidWebservice/SingforBAPort";
}


+(NSString *)takephotoviewcontroller//上传图片
{
    return @"http://125.88.8.30:8888/AndroidWebservice/UploadImgservlet";
}


+(NSString *)picreloadviewcontroller//加载上传失败图片
{
    return @"http://125.88.8.30:8888/AndroidWebservice/CheckImgUploadPort";
}

+(NSString *)reimageviewcontroller//重新上传图片
{
    return @"http://125.88.8.30:8888/AndroidWebservice/UploadImgservlet";
}

+(NSString *)checkversion//版本检查
{
    return @"http://125.88.8.30:8888/AndroidWebservice/download/signfor_ios(checkversion).json";
}

@end
