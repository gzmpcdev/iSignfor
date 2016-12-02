//
//  networkcheckViewController.h
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface networkcheckViewController : UIViewController

+(NSString *)network;

+(NSString *)stringFromStatus:(NetworkStatus)status;

@end
