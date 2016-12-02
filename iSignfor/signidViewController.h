//
//  signidViewController.h
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ZBarSDK.h"

@interface signidViewController : UIViewController<NSXMLParserDelegate,NSURLConnectionDelegate,ZBarReaderDelegate>
{
    
    __weak IBOutlet UILabel *chuanname;
    
}

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

@property (strong, nonatomic) UITextField *quedingsignid;


+(NSString *)chaxunchuanzhi;
+(NSString *)chuanqianshoudan;

+(NSDictionary *)chuandic;//++++++++++++++++++++++++++
+(int)chuanimgcount;//++++++++++++++++++++++++++
+(NSString *)chuanimgstatus;//++++++++++++++++++++++++++
+(void)signchushihua;
+(int)returnchushihua;


@end
