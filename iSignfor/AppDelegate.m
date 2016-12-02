//
//  AppDelegate.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "AppDelegate.h"
#import "GDataXMLNode.h"
#import "networkcheckViewController.h"
#import "linkViewController.h"

@interface AppDelegate ()

@end

NSString *theXML3;

static int irr;

NSInteger check;
NSString *needs;
NSString *memo;


@implementation AppDelegate


@synthesize webData3;
@synthesize soapResults3;
@synthesize xmlParser3;
@synthesize elementFound3;
@synthesize matchingElement3;
@synthesize conn3;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //NSLog(@"<<<<<<<<<");
    //授权
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
        /**
         *  iOS8注册授权,设置本地通知模式
         */
        /*
         UIUserNotificationTypeNone    = 0,      不发出通知
         UIUserNotificationTypeBadge   = 1 << 0, 改变应用程序图标右上角的数字
         UIUserNotificationTypeSound   = 1 << 1, 播放音效
         UIUserNotificationTypeAlert   = 1 << 2, 是否运行显示横幅
         */
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound |UIUserNotificationTypeAlert  categories:nil];
        /**
         *  然后注册通知
         */
        [application registerUserNotificationSettings:settings];
        //NSLog(@"aaaaaaaaaaa");
    }
    /**
     *  如果程序正常启动(冷启动),launchOptions的参数为null
     *  如果程序非正常启动(热启动),launchOptions的参数时有值的
     */
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        NSLog(@"%@",launchOptions);
        
        //[self jumpToSession];
    }
    //--------------------------------------------------------------------------
    //检测网络
    //[networkcheckViewController network];
    
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        
        //--------------------------------------------------------------------------
        //一开始运行就检测版本
        NSString * URLString = [linkViewController checkversion];//@"http://125.88.8.30:8887/AndroidWebservice/download/signfor_ios(checkversion).json"
        NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:URL];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"error: %@",[error localizedDescription]);
        }else{
            NSLog(@"response : %@",response);
            NSLog(@"backData : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        [self analyseJsonforversioncheck:data];
        
        
        //-------------------------------------------------------------------------------------------
        
        //检查有多少未上传的图片
        // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
        matchingElement3 = @"getMobileCodeInfoResult";
        // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
        NSString *soapMsg = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             // "<soap12:Envelope "
                             
                             "<soapenv:Envelope "
                             "xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
                             "xmlns:upl=\"http://upload.czl.com/\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<upl:getUploadImgFailJson>"
                             //<!--Optional:-->
                             "<arg0>%@</arg0>"
                             "</upl:getUploadImgFailJson>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>",@"16233"];
        
        
        
        // 将这个XML字符串打印出来
        NSLog(@"%@", soapMsg);
        // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
        NSURL *url = [NSURL URLWithString: @"http://125.88.8.30:8887/AndroidWebservice/CheckImgUploadPort"];
        // 根据上面的URL创建一个请求
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
        // 添加请求的详细信息，与请求报文前半部分的各字段对应
        [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        // 设置请求行方法为POST，与请求报文第一行对应
        [req setHTTPMethod:@"POST"];
        // 将SOAP消息加到请求中
        [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
        // 创建连接
        conn3 = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        if (conn3) {
            webData3 = [NSMutableData data];
            NSLog(@"HELLO");
        }
        
        NSLog(@"h2");
        
        
        
    }
    
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "gzmpc.iSignfor" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iSignfor" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iSignfor.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


-(void)analyseJsonforversioncheck:(NSData *)b
{
    
    //check=[[int alloc] init];
    //needs=[[NSString alloc] init];
    //memo=[[NSString alloc] init];
    
    //NSString *haha = [[NSString alloc] initWithData:b  encoding:NSUTF8StringEncoding];
    //NSLog(@"%@bbbbbbbbbbbbbbbbbbbbbbbb",haha);
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:b options:kNilOptions error:nil];
    
    NSArray *json2 = [json objectForKey:@"chickversion"];
    
    
    NSDictionary *dic = [json2 objectAtIndex:0];
    NSString * appname = [dic objectForKey:@"appname"];
    NSLog(@"%@",appname);
    NSString * apkname = [dic objectForKey:@"apkname"];
    NSLog(@"%@",apkname);
    NSString * verName = [dic objectForKey:@"verName"];
    NSLog(@"%@",verName);
    NSString * verCode = [dic objectForKey:@"verCode"];
    NSLog(@"%@",verCode);
    NSString * updatememo = [dic objectForKey:@"updatememo"];
    NSLog(@"%@",updatememo);
    NSString * need = [dic objectForKey:@"need"];
    NSLog(@"%@",need);
    
    check = [verCode integerValue];
    NSLog(@"%ld",(long)check);
    
    needs = need;
    memo = updatememo;
}


/**
 *  该方法,接收到本地通知执行,如果应用程序在前台,依然收到通知,但不应该执行跳转;
 如果应用程序在后台,收到通知,点击通知,执行跳转代码;
 应用程序被关闭,收到通知,但不能执行跳转代码,(需要在didFinishLaunchingWithOptions方法中执行)
 *
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"收到本地通知");
    [application setApplicationIconBadgeNumber:0];
    
    if (application.applicationState == UIApplicationStateActive)//程序当前正处于前台
    {
        
        return;
    }
    else if (application.applicationState == UIApplicationStateInactive)//程序在后台状态
    {
        [self jumpToSession];
    }
    else if(application.applicationState == UIApplicationStateBackground)
    {
        /**
         *  不会执行该代码
         */
        NSLog(@"在后台");
    }
}
- (void)jumpToSession
{
    NSLog(@"执行跳转页面");
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor redColor];
    redView.frame = CGRectMake(100, 100, 100, 100);
    [self.window.rootViewController.view addSubview:redView];
    
    
}


// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData3 setLength: 0];
    NSLog(@"connection didReceiveResponse");
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    //[webData appendData:data];
    NSLog(@"connection didReceiveData");
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", str);//得到想要的XML字符串然后解析
    //_textview.text=str;
    theXML3 = [[NSString alloc] initWithBytes:[webData3 mutableBytes] length:[webData3 length] encoding:NSUTF8StringEncoding];
    theXML3 = str;
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn3 = nil;
    webData3 = nil;
    NSLog(@"connection didFailWithError");
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败，请重新连接！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
    
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    // NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
    //    length:[webData length]
    // encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML3);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser3 = [[NSXMLParser alloc] initWithData: webData3];
    [xmlParser3 setDelegate: self];
    [xmlParser3 setShouldResolveExternalEntities: YES];
    [xmlParser3 parse];
    NSLog(@"connectionDidFinishLoading");
    [self jiexi];
}


-(void)jiexi

{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:theXML3 options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
    NSString *gen = [ rootElement stringValue];
    //NSLog(gen);
    //GDataXMLElement *users = [rootElement elementsForName:@"S:Envelope"];
    GDataXMLElement *third = [[rootElement elementsForName:@"S:Body"]objectAtIndex:0];
    NSString *gen2 = [ third stringValue];
    //  NSLog(gen2);
    // NSLog(@"1");
    
    GDataXMLElement *forth = [[third elementsForName:@"ns2:getUploadImgFailJsonResponse"]objectAtIndex:0];
    //NSString *gen3 = [ forth stringValue];
    //NSLog(gen3);
    // NSLog(@"qian");
    
    //for (GDataXMLElement *user in forth)
    //{
    //User节点的id属性
    GDataXMLElement *name = [[forth elementsForName:@"return"] objectAtIndex:0];
    NSString *a=[name stringValue];
    
    NSLog(@"%@",a);
    NSLog(@"print");
    
    
    NSData *b = [a dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:b options:kNilOptions error:Nil];
    
    NSArray *json2 = [json objectForKey:@"ImgUploadFailData"];
    
    irr=json2.count;
    NSLog(@"%ld", (long)irr);
    if (irr!=0)
    {
        /**
         创建本地通知对象
         */
        UILocalNotification *localnotification = [[UILocalNotification alloc]init];
        
        localnotification.applicationIconBadgeNumber = irr;//右上角显示的数字
        /**
         *  调度本地通知,通知会在特定时间发出
         */
        [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];//在系统Notification处理队列中登记已设置完的UILocalNotification对象
        //[[UIApplication sharedApplication] presentLocalNotificationNow:localnotification];//立即发出本通知
        
        
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"你有未上传的图片！" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:promptAlert
                                        repeats:YES];
        [promptAlert show];
        
    }
}


- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

+(NSInteger)sendversion
{
    return check;
}

+(NSString *)sendneeds
{
    return needs;
}


+(NSString *)sendmemo
{
    return memo;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // Do something with the url here
    return YES;
}



@end
