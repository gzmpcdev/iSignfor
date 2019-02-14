//
//  takephotoViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "takephotoViewController.h"
#import "quedingViewController.h"
#import "GTMBase64.h"
#import "signidViewController.h"
#import "GDataXMLNode.h"
#import "networkcheckViewController.h"
#import "linkViewController.h"

@interface takephotoViewController ()

@end

NSString *theXML6;

static int irrr;


int tag;
NSString *picname;
int getpicflag;
int paizhaopanduan;//用于判断有没有照相上传，如果有，就不弹出框，如果没有就弹出框提醒。

NSString *sendstring;//用于传送查询的结果

static int connectflag;

int allimgcount;//如果上传成功，加一。最后传回给列表那边。///////////+++++++++++++++++++++++++

int goontakepic;

@implementation takephotoViewController

@synthesize webData5;
@synthesize soapResults5;
@synthesize xmlParser5;
@synthesize elementFound5;
@synthesize matchingElement5;
@synthesize conn5;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _takephotolabel.text=[signidViewController chuanqianshoudan];
    
    if (goontakepic!=1) {
        allimgcount = [quedingViewController chuanimgcount];
    }
    
    
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        
        //[self shibaipic];
        
        _image.image = [quedingViewController chuanpics];
        getpicflag = [quedingViewController chuanpicflag];
        
        //NSLog(@"ggggggggggggggggggggggggg%d",getpicflag);
    }
    
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

- (IBAction)camera2:(id)sender
{
    goontakepic=1;
     //------------------------------------------------------------------------------------
    //获取当前时间
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"hh:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    //NSString *timeSp = [NSString stringWithFormat:@"%d", (long)[locationString timeIntervalSince1970]];
    
    NSArray *jiequ;
    
    NSString *shijian;
    
    jiequ = [locationString componentsSeparatedByString:@":"];//nsarray
    //NSString *com = [cutresult objectAtIndex:0];
    
    //NSData *arry2data = [NSKeyedArchiver archivedDataWithRootObject:cutresult];
    
    //NSLog(@"%@",[jiequ objectAtIndex:0]);
    
    shijian = [[jiequ objectAtIndex:0] stringByAppendingString:[jiequ objectAtIndex:1]];
    
    shijian = [shijian stringByAppendingString:[jiequ objectAtIndex:2]];
    
    NSLog(@"%@",shijian);
    //-------------------------------------------------------------------------------------
    
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //获取照片名称
    NSString *signidd;
    NSString *fuhao;
    NSString *fuhao1;
    signidd = [signidViewController chuanqianshoudan];
    fuhao=@"_";
    fuhao1=@".jpg";
    picname = [signidd stringByAppendingString:fuhao];
    picname = [picname stringByAppendingString:shijian];
    picname = [picname stringByAppendingString:fuhao1];
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    

    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        picker.delegate = self;
        //[self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"OK");
        }];
        
        //[picker release];
        
        
    }
    else {
        NSLog(@"模拟其中无法打开照相机，请在真机中使用");
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    
    /*
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = NO;
     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     
     [self presentViewController:picker animated:YES completion:NULL];
     
    */
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    _image.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"image"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
    
    
       
    
    //-------------------------------------------------------------------------------------
    //保存进沙盒
    chosenImage = [self rotateImage2:chosenImage];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:picname];   // 保存文件的名称
    [UIImagePNGRepresentation(chosenImage)writeToFile: filePath    atomically:YES];
    
    [self savetosandbox];
    
    NSLog(@"%@",filePath);
    
    //-------------------------------------------------------------------------------------
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)upload:(id)sender
{
    
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        //NSData *obj = UIImageJPEGRepresentation(_Imagen.image, 0.5);
        
        // NSString *_encodedImageStr = [obj base64Encoding];
        
        
        UIImage *im = [[UIImage alloc]init];
        im=[self compressImage:_image.image];
        
        NSData *obj = UIImageJPEGRepresentation(im, 0.3);
        //UIImage *img = [UIImage imageNamed:@"512.png"];
        //NSData *obj = UIImageJPEGRepresentation(img, 0.5);
        NSString *_encodedImageStr = [[NSString alloc] initWithData:[GTMBase64 encodeData:obj] encoding:NSUTF8StringEncoding];
        
        
        //传输替换
        //String sendBuf = sb.toString().replace("+", "%2B");
        NSString *strUrl = [_encodedImageStr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        
        //-------------------------------------------------------------------------------------
        //传输字符串
        //拼接字符串
        NSString *string1;
        NSString *string2;
        NSString *string,*string4,*string5,*string6;
        
        string1=strUrl;
        string2=@"photo=";
        string4=@"&filename=";
        string5=@"&signforid=";
        string6=@"&used=";
        //string3=@"&filename=3604342_100911.jpg&signforid=3604342&used=16233";
        
        
        
        string = [string2 stringByAppendingString:string1];//
        string=[string stringByAppendingString:string4];//
        
        if (getpicflag == 1)
        {
            picname = [quedingViewController chuanpicname];
            string=[string stringByAppendingString:picname];
            getpicflag =0;
        }
        else
        {
            string=[string stringByAppendingString:picname];//
        }
        string=[string stringByAppendingString:string5];//
        string=[string stringByAppendingString:[signidViewController chuanqianshoudan]];
        string=[string stringByAppendingString:string6];
        string=[string stringByAppendingString:[ViewController chuanuserid]];
        
        NSLog(@"%@",string);
        
        //-------------------------------------------------------------------------------------
        
        
        
        //第一步，创建url
        NSURL *url = [NSURL URLWithString:[linkViewController takephotoviewcontroller]];//@"http://125.88.8.30:8887/AndroidWebservice/UploadImgservlet"
        
        //第二步，创建请求
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        
        [request setHTTPMethod:@"POST"];
        
        //[NSThread sleepForTimeInterval:5];
        NSLog(@"kaishi");
        
        NSString *str = string;
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:data];
        //第三步，连接服务器
        
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        
    }
    
    //[self cconnect];////////////////////////////////////
    
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",[res allHeaderFields]);
    
    self.receiveData = [NSMutableData data];
    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.receiveData appendData:data];
    
}

//数据传完之后调用此方法

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",receiveStr);
    tag=1;
    //[self cconnect];//上传成功，就链接一次，取图片的值；//////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    /**
     创建本地通知对象
     */
    
    //UILocalNotification *localnotification = [[UILocalNotification alloc]init];
    /**
     *  设置推送的相关属性
     */
    //localnotification.fireDate = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];//通知触发时间
    //localnotification.alertBody = [picname stringByAppendingString:@" 上传成功"];//通知具体内容
    //localnotification.alertTitle = @"notice";//谁发出的通知
    //localnotification.soundName = UILocalNotificationDefaultSoundName;//通知时的音效
    //localnotification.alertAction = @"滑动并查看";//默认为 滑动来 +查看;锁屏时显示底部提示
    /**
     *  调度本地通知,通知会在特定时间发出
     */
    //[[UIApplication sharedApplication] scheduleLocalNotification:localnotification];//在系统Notification处理队列中登记已设置完的UILocalNotification对象
    //[[UIApplication sharedApplication] presentLocalNotificationNow:localnotification];//立即发出本通知
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    /**
     *  调度本地通知,通知会在特定时间发出
     */
    
    UILocalNotification *localnotification = [[UILocalNotification alloc]init];
    [[UIApplication sharedApplication] scheduleLocalNotification:localnotification];//在系统Notification处理队列中登记已设置完的UILocalNotification对象
    //[[UIApplication sharedApplication] presentLocalNotificationNow:localnotification];//立即发出本通知
    
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:[picname stringByAppendingString:@" 上传成功"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
    
    
    [signidViewController signchushihua];
    allimgcount=allimgcount+1;
    paizhaopanduan=1;//用于判断有没有照相上传，如果有，就不弹出框，如果没有就弹出框提醒。
    
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}





//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
    
    NSLog(@"%@",[error localizedDescription]);
    
    /**
     创建本地通知对象
     */
    
    UILocalNotification *localnotification = [[UILocalNotification alloc]init];
    /**
     *  设置推送的相关属性
     */
    localnotification.fireDate = [NSDate dateWithTimeInterval:5.0 sinceDate:[NSDate date]];//通知触发时间
    localnotification.alertBody = [picname stringByAppendingString:@" 上传失败！"];//通知具体内容
    localnotification.alertTitle = @"notice";//谁发出的通知
    localnotification.soundName = UILocalNotificationDefaultSoundName;//通知时的音效
    localnotification.alertAction = @"滑动并查看";//默认为 滑动来 +查看;锁屏时显示底部提示
    /**
     *  调度本地通知,通知会在特定时间发出
     */
    //[[UIApplication sharedApplication] scheduleLocalNotification:localnotification];//在系统Notification处理队列中登记已设置完的UILocalNotification对象
    [[UIApplication sharedApplication] presentLocalNotificationNow:localnotification];//立即发出本通知
    
}


- (UIImage *)compressImage:(UIImage *)imgSrc
{
    
    CGFloat a,b;
    CGSize imageSize = imgSrc.size;
    CGFloat width  = imageSize.width;
    CGFloat height = imageSize.height;
    if (width>height) {
        a= 1500;
        b=841;
    }
    
    else
    {
        a= 900;
        b= 1600;
    }
    
    CGSize size={a,b};
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}


- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



-(void)savetosandbox
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *filePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:picname];   // 保存文件的名称
    
    NSLog(@"%@",filePath);
    [info setObject:filePath forKey:@"img"];
    
}

- (IBAction)backqueding:(id)sender
{
    if (paizhaopanduan == 1)
    {
        UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"queding"];
        childVC.hidesBottomBarWhenPushed = YES;
        [self presentViewController:childVC animated:YES completion:nil];
        goontakepic=0;
    }
    else
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片未上传，业务要求必须上传，是否确认取消拍照！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        
        [self.view addSubview:alter];
        
        alter.delegate  = self;
        [alter show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    
    // the user clicked OK
    
    if (buttonIndex == 0)
        
    {
        
        //do something here...
        UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"queding"];
        childVC.hidesBottomBarWhenPushed = YES;
        [self presentViewController:childVC animated:YES completion:nil];
        goontakepic=0;
    }
    
}

+(NSString *)chaxunchuanzhi2
{
    return sendstring;//传那串字符串用于列表显示
}

+(void)setnil
{
    sendstring=NULL;
}

+(int)sendtag
{
    return tag;
}

+(void)settag
{
    tag=0;
}

+(int)chuanallimgcount
{
    return allimgcount;
}


- (UIImage*)rotateImage2:(UIImage *)image//旋转
{
    int kMaxResolution = 960; // Or whatever
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}




@end
