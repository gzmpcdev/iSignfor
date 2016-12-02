//
//  picreloadViewController.h
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import <UIKit/UIKit.h>

//学生
#define nameTag          1
#define classTag         2
#define stuNumberTag     3
#define imageTag         4
#define nameFontSize    15
#define fontSize        12


@interface picreloadViewController : UIViewController

@property (strong, nonatomic) NSMutableData *webData1;
@property (strong, nonatomic) NSMutableString *soapResults1;
@property (strong, nonatomic) NSXMLParser *xmlParser1;
@property (nonatomic) BOOL elementFound1;
@property (strong, nonatomic) NSString *matchingElement1;
@property (strong, nonatomic) NSURLConnection *conn1;

@property (retain,nonatomic) NSArray *stuArray3;

@property (weak, nonatomic) IBOutlet UITableView *picreloadtableview;


+(int)chuanpicflag2;
+(UIImage *)chuanpics2;
+(NSString *)chuanqianshoudan2;
+(NSString *)chuanpicname;


@end
