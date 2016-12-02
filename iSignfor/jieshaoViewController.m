//
//  jieshaoViewController.m
//  iSignfor
//
//  Created by pro on 16/2/1.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "jieshaoViewController.h"

@interface jieshaoViewController ()

@end

@implementation jieshaoViewController

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

- (IBAction)close:(id)sender
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shouye"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}


@end
