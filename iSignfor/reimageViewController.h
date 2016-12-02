//
//  reimageViewController.h
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reimageViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *reloadimage;

@property (strong, nonatomic) NSMutableData *webData5;
@property (strong, nonatomic) NSMutableString *soapResults5;
@property (strong, nonatomic) NSXMLParser *xmlParser5;
@property (nonatomic) BOOL elementFound5;
@property (strong, nonatomic) NSString *matchingElement5;
@property (strong, nonatomic) NSURLConnection *conn5;
@property(nonatomic,retain) NSMutableData *receiveData2;

@property (weak, nonatomic) IBOutlet UILabel *rephotolabel;


@end
