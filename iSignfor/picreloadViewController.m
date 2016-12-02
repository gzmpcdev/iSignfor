//
//  picreloadViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "picreloadViewController.h"
#import "GDataXMLNode.h"
#import "networkcheckViewController.h"
#import "linkViewController.h"

@interface picreloadViewController ()

@end

NSString *theXML2;

UIImage *chuanpic2;

NSString *picname3;

static int picflag2;//用于判断图片是那个页面照的

NSString *op;

static int ir;

NSMutableArray *mutableArray2;
NSDictionary *dic3;


@implementation picreloadViewController


@synthesize webData1;
@synthesize soapResults1;
@synthesize xmlParser1;
@synthesize elementFound1;
@synthesize matchingElement1;
@synthesize conn1;
@synthesize stuArray3 = _stuArray3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        [self lianjie];
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


- (IBAction)reloadbacktoshouye:(id)sender {
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shouye"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}

-(void)lianjie
{
    // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
    matchingElement1 = @"getMobileCodeInfoResult";
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
    NSURL *url = [NSURL URLWithString: [linkViewController picreloadviewcontroller]];//@"http://125.88.8.30:8887/AndroidWebservice/CheckImgUploadPort"
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
    conn1 = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn1) {
        webData1 = [NSMutableData data];
        NSLog(@"HELLO");
    }
    
    NSLog(@"h2");
    
}


// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData1 setLength: 0];
    NSLog(@"connection didReceiveResponse");
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    //[webData appendData:data];
    NSLog(@"connection didReceiveData");
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", str);//得到想要的XML字符串然后解析
    //_textview.text=str;
    theXML2 = [[NSString alloc] initWithBytes:[webData1 mutableBytes] length:[webData1 length] encoding:NSUTF8StringEncoding];
    theXML2 = str;
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn1 = nil;
    webData1 = nil;
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
    NSLog(@"%@", theXML2);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser1 = [[NSXMLParser alloc] initWithData: webData1];
    [xmlParser1 setDelegate: self];
    [xmlParser1 setShouldResolveExternalEntities: YES];
    [xmlParser1 parse];
    NSLog(@"connectionDidFinishLoading");
    [self jiexi];
}


-(void)jiexi

{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:theXML2 options:0 error:nil];
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
    
    ir=json2.count;
    NSLog(@"%ld", (long)ir);
    
    NSInteger j;
    NSMutableArray *mutableArray2 = [[NSMutableArray alloc] init];
    
    for (j=0; j<ir; j++)
    {
        
        NSDictionary *dic = [json2 objectAtIndex:j];
        
        NSDictionary *latd = [dic objectForKey:@"signforid"];
        NSString * lat = [dic objectForKey:@"signforid"];
        NSLog(@"%@",lat);
        NSDictionary *latd1 = [dic objectForKey:@"printname"];
        NSString * lat1 = [dic objectForKey:@"printname"];
        NSLog(@"%@",lat1);
        NSDictionary *latd2 = [dic objectForKey:@"appsignfordate"];
        NSString * lat2 = [dic objectForKey:@"appsignfordate"];
        NSLog(@"%@",lat2);
        
        //[dic1 initWithObjectsAndKeys:lat,@"signforid",lat1,@"printname",lat2,@"appsignfordate", nil];
        
        NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:latd,@"signforid",latd1,@"printname",latd2,@"appsignfordate", nil];
        
        dic3 = [NSDictionary dictionaryWithObjectsAndKeys:latd,@"signforid",latd1,@"printname",latd2,@"appsignfordate", nil];
        
        NSLog(@"%@dic2",dic3);
        
        //[_stuArray arrayByAddingObject:dic1];
        //_stuArray=[NSArray arrayWithObject:dic1];
        
        /*
         shuzu = [lat stringByAppendingString:@"signforid"];
         shuzu = [shuzu stringByAppendingString:lat1];
         shuzu = [shuzu stringByAppendingString:@"printname"];
         shuzu = [shuzu stringByAppendingString:lat2];
         shuzu = [shuzu stringByAppendingString:@"appsignfordate"];
         */
        
        //ar = [ NSArray arrayWithObject:dic1];
        
        
        //MutableArray = [NSMutableArray arrayWithObject:ar];
        [mutableArray2 insertObject:dic1 atIndex:0];
        
        NSLog(@"%ld", (long)j);
        
        
        
    }
    // _stuArray = MutableArray;
    //_stuArray = [NSArray arrayWithObjects:shuzu, nil];
    //_stuArray = [[NSArray alloc]initWithObjects:MutableArray, nil];
    _stuArray3 = [mutableArray2 copy];
    NSLog(@"%@",_stuArray3);
    NSLog(@"%@",mutableArray2);
    
    
    NSLog(@"-------------------");
    //}
    
    [self.picreloadtableview reloadData];
}

//每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ir;
    
}

//表的分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//定义分区的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"上传失败的图片";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [self customCellWithOutXib:tableView withIndexPath:indexPath];
    assert(cell != nil);
    return cell;
}

//修改行高度的位置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

//通过代码自定义cell
-(UITableViewCell *)customCellWithOutXib:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    //定义标识符
    static NSString *customCellIndentifier = @"CustomCellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIndentifier];
    
    //定义新的cell
    if(cell == nil){
        //使用默认的UITableViewCell,但是不使用默认的image与text，改为添加自定义的控件
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellIndentifier];
        
        
        CGRect nameeTipRect = CGRectMake(10, 20, 60, 14);
        UILabel *nameeLabel = [[UILabel alloc]initWithFrame:nameeTipRect];
        nameeLabel.text = @"公司号码：";
        nameeLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:nameeLabel];
        
        //姓名
        CGRect nameRect = CGRectMake(70, 15, 60, 25);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:nameRect];
        nameLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        nameLabel.tag = nameTag;
        nameLabel.textColor = [UIColor brownColor];
        [cell.contentView addSubview:nameLabel];
        
        //班级
        CGRect classTipRect = CGRectMake(10, 40, 60, 14);
        UILabel *classTipLabel = [[UILabel alloc]initWithFrame:classTipRect];
        classTipLabel.text = @"公司名称：";
        classTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:classTipLabel];
        
        
        CGRect classRect = CGRectMake(70, 40, 150, 14);
        UILabel *classLabel = [[UILabel alloc]initWithFrame:classRect];
        classLabel.tag = classTag;
        classLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:classLabel];
        
        //学号
        CGRect stuNameTipRect = CGRectMake(10, 60, 160, 12);
        UILabel *stuNameTipLabel = [[UILabel alloc]initWithFrame:stuNameTipRect];
        stuNameTipLabel.text = @"上次未能上传时间：";
        stuNameTipLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [cell.contentView addSubview:stuNameTipLabel];
        
        CGRect stuNameRect = CGRectMake(120, 60, 150, 14);
        UILabel *stuNameLabel = [[UILabel alloc]initWithFrame:stuNameRect];
        stuNameLabel.tag = stuNumberTag;
        stuNameLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        
        [cell.contentView addSubview:stuNameLabel];
        
        //按钮
        UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button4.frame = CGRectMake(300, 13, 50, 50);
        [button4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button4.backgroundColor = [UIColor yellowColor];
        [button4 setTitle:@"重新上传" forState:UIControlStateNormal];
        [button4 addTarget:self action:@selector(reloadbtn:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button4];
        
        /*
         //图片
         CGRect imageRect = CGRectMake(15, 15, 60, 60);
         UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageRect];
         imageView.tag = imageTag;
         
         //为图片添加边框
         CALayer *layer = [imageView layer];
         layer.cornerRadius = 8;
         layer.borderColor = [[UIColor whiteColor]CGColor];
         layer.borderWidth = 1;
         layer.masksToBounds = YES;
         [cell.contentView addSubview:imageView];
         */
    }
    //获得行数
    NSUInteger row = [indexPath row];
    
    
    
    //取得相应行数的数据（NSDictionary类型，包括姓名、班级、学号、图片名称）
    NSDictionary *dic = [_stuArray3 objectAtIndex:row];
    
    NSLog(@"%@",dic);
    
    
    //设置图片
    //UIImageView *imageV = (UIImageView *)[cell.contentView viewWithTag:imageTag];
    //imageV.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    
    //设置姓名
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:nameTag];
    name.text = [dic objectForKey:@"signforid"];
    
    
    //设置班级
    UILabel *class = (UILabel *)[cell.contentView viewWithTag:classTag];
    class.text = [dic objectForKey:@"printname"];
    
    //设置学号
    UILabel *stuNumber = (UILabel *)[cell.contentView viewWithTag:stuNumberTag];
    stuNumber.text = [dic objectForKey:@"appsignfordate"];
    
    //设置右侧箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)erweima
{
    NSLog(@"shangchuan");
    
}

-(void)reloadbtn:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];   // 把触摸的事件放到集合里
    
    UITouch *touch = [touches anyObject];   //把事件放到触摸的对象了
    
    CGPoint currentTouchPosition = [touch locationInView:self.picreloadtableview]; //把触发的这个点转成二位坐标
    
    NSIndexPath *indexPath = [self.picreloadtableview indexPathForRowAtPoint:currentTouchPosition]; //匹配坐标点
    if(indexPath !=nil)
    {
        //[selftableView:self.tableviewaccessoryButtonTappedForRowWithIndexPath:indexPath];
        //NSLog(@"shangchuan");
        
        //[self deletepic:indexPath];
        UITableViewCell *cell = [self.picreloadtableview cellForRowAtIndexPath: indexPath];
        
        UIView *dddd;
        
        dddd = [cell viewWithTag:1];
        UILabel *label = (UILabel *)dddd;
        op = label.text;
        //cell.textLabel.text;
        //cell.textLabel.text = @"abc";
        NSLog(@"%@",op);
        
        [self reupload];
        
    }
    
    
}


-(void)reupload
{
    //------------------------------------------------------------------------------------
    //获取当前时间
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"hh:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
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
    signidd = op;
    fuhao=@"_";
    fuhao1=@".jpg";
    picname3 = [signidd stringByAppendingString:fuhao];
    picname3 = [picname3 stringByAppendingString:shijian];
    picname3 = [picname3 stringByAppendingString:fuhao1];
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    

    /*
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
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
     */
    
    
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = NO;
     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     
     [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chuanpic2 = chosenImage;
    
    picflag2=1;
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reimage"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
    
        
    //-------------------------------------------------------------------------------------
    //保存进沙盒
    
    chosenImage = [self rotateImage3:chosenImage];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:picname3];   // 保存文件的名称
    [UIImagePNGRepresentation(chosenImage)writeToFile: filePath    atomically:YES];
    
    [self savetosandbox];
    
    NSLog(@"%@",filePath);
    
    //-------------------------------------------------------------------------------------
    

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


+(UIImage *)chuanpics2//图片
{
    return chuanpic2;
}


-(void)savetosandbox
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *filePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:picname3];   // 保存文件的名称
    
    NSLog(@"%@",filePath);
    [info setObject:filePath forKey:@"img"];
    
}


+(int)chuanpicflag2
{
    return picflag2;
}

+(NSString *)chuanqianshoudan2
{
    return op;//用于传输签收单号
}

+(NSString *)chuanpicname
{
    return picname3;
}


- (UIImage*)rotateImage3:(UIImage *)image//旋转
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
