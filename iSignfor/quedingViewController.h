//
//  quedingViewController.h
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define nameTag          1
#define adressTag         2
#define consignorTag     3
#define imageTag         4
#define totalcaseTag     5
#define coldcaseTag    6
#define mj2ffzjcaseTag 7
#define recmoneyTag 8
#define appsignforflagTag   9
#define imgcntTag  10


#define nameFontSize    20
#define fontSize        20

@interface quedingViewController : UIViewController<UIAlertViewDelegate>

@property (retain,nonatomic) NSArray *stuArray;

@property (strong, nonatomic) NSMutableData *webData4;
@property (strong, nonatomic) NSMutableString *soapResults4;
@property (strong, nonatomic) NSXMLParser *xmlParser4;
@property (nonatomic) BOOL elementFound4;
@property (strong, nonatomic) NSString *matchingElement4;
@property (strong, nonatomic) NSURLConnection *conn4;

@property (weak, nonatomic) IBOutlet UILabel *chuanid;




+(UIImage *)chuanpics;
+(NSString *)chuanpicname;
+(int)chuanpicflag;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *data;

+(int)chuanimgcount;//////////////+++++++++++++++++++++++++++++

+(UIImage *)chuanpics;
+(NSString *)chuanpicname;
+(int)chuanpicflag;



@end
