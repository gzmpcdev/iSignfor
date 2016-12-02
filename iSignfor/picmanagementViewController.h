//
//  picmanagementViewController.h
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define nameTag          1
#define fontSize        15

@interface picmanagementViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *listphoto;

@property (retain,nonatomic) NSArray *stuArray1;

+(NSString *)chuanpicname;


@end
