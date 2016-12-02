//
//  AppDelegate.h
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@property (strong, nonatomic) NSMutableData *webData3;
@property (strong, nonatomic) NSMutableString *soapResults3;
@property (strong, nonatomic) NSXMLParser *xmlParser3;
@property (nonatomic) BOOL elementFound3;
@property (strong, nonatomic) NSString *matchingElement3;
@property (strong, nonatomic) NSURLConnection *conn3;

+(NSString *)sendneeds;
+(NSInteger)sendversion;
+(NSString *)sendmemo;


@end

