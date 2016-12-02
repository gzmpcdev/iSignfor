//
//  openpicViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "openpicViewController.h"

#import "picmanagementViewController.h"

#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface openpicViewController ()

@end

@implementation openpicViewController

UIImage *imgg;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self show:[picmanagementViewController chuanpicname]];
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

-(void)show:(NSString *)openpicname
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:openpicname];   // 保存文件的名称
    NSLog(@"%@",filePath);
    
    /*
     NSBundle *mainBundle = [NSBundle mainBundle];
     
     NSString *imagePath = [mainBundle pathForResource:@"pic" ofType:@"png"];
     */
    imgg = [UIImage imageWithContentsOfFile:filePath];
    
    NSLog(@"%@",imgg);
    //_openpicview.contentMode = UIViewContentModeScaleAspectFill;        // 设置图片正常填充
    
    
    _openpicview.image = imgg;
    
}

- (IBAction)backtopicmanage:(id)sender {
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"picmanage"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library saveImage:imgg toAlbum:@"签收系统" completion:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            NSLog(@"chenggong");
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"已成功添加到相册" message:Nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [self.view addSubview:alter];
            
            alter.delegate  = self;
            [alter show];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"shibai");
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"保存失败" message:Nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [self.view addSubview:alter];
        
        alter.delegate  = self;
        [alter show];
    }];

}




@end
