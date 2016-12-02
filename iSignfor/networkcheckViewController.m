//
//  networkcheckViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "networkcheckViewController.h"
#import "Reachability.h"

@interface networkcheckViewController ()

@end

@implementation networkcheckViewController

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


+(NSString *)network
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [reach currentReachabilityStatus];
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rechability" message:[ViewController stringFromStatus:status] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
     [alert show];
     */
    
    return [self stringFromStatus:status];
    
}

+(NSString *)stringFromStatus:(NetworkStatus)status
{
    NSString *string;
    switch (status) {
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rechability" message:@"当前网络不可用" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            
            //string = @"当前网络不可用";
            string = @"nonet";
            return string;
            break;
        }
        case ReachableViaWiFi:
            //string = @"Reachable via WIFI";
            return @"yes";
            break;
        case ReachableViaWWAN:
            
        {
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rechability" message:@"当前网络不太好哦！可能会操作失败！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            //[alert show];
            
            //string = @"当前网络不可用";
            //string = @"yes";
            return @"yes";
            break;
        }
            //string = @"当前网络不太好哦！可能会操作失败！";
            
        default:
            string = @"yes";
            return @"yes";
            break;
            
    }
    
    //return string;
}


@end
