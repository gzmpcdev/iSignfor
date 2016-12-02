//
//  signidViewController.m
//  iSignfor
//
//  Created by pro on 16/1/26.
//  Copyright © 2016年 com.gzmpc. All rights reserved.
//

#import "signidViewController.h"
#import "ViewController.h"
#import "GDataXMLNode.h"
#import "networkcheckViewController.h"
#import "networkcheckViewController.h"
#import "linkViewController.h"

#define kScreenHeight2 [[UIScreen mainScreen] bounds].size.height      //屏幕高度
#define kScreenWidth2 [[UIScreen mainScreen] bounds].size.width      //屏幕宽度

@interface signidViewController ()

@end

UITextField *quedingsignid;
NSMutableArray *mutableArray;
NSString *a;

NSString *theXML1;

NSString *qianshoudanquzhi;

int chushihua;//用于判断takephotoviewcontroller 的图片数有没有被初始化；///////////+++++++++++++++++++++++++

@implementation signidViewController

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    chuanname.text = [ViewController chuanzhi];
    
    chushihua=0;
    
    //初始化textfield并设置位置及大小
    quedingsignid = [[UITextField alloc]initWithFrame:CGRectMake((kScreenWidth2/2)-140, (kScreenHeight2/4), 280, 50)];
    //设置边框样式，只有设置了才会显示边框样式
    quedingsignid.borderStyle = UITextBorderStyleRoundedRect;
    //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
    quedingsignid.backgroundColor = [UIColor whiteColor];
    //当输入框没有内容时，水印提示 提示内容为password
    quedingsignid.placeholder = @"签收单id";
    //设置输入框内容的字体样式和大小
    quedingsignid.font = [UIFont fontWithName:@"Arial" size:45.0f];
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    quedingsignid.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:quedingsignid];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button5.frame = CGRectMake((kScreenWidth2/3)-20, (kScreenHeight2/4)+70, 77, 30);
    [button5 setTitle:@"扫描" forState:UIControlStateNormal];
    button5.titleLabel.font = [UIFont systemFontOfSize: 30];
    [button5 addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];

    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button6.frame = CGRectMake(((kScreenWidth2/3)*2)-60, (kScreenHeight2/4)+70, 77, 30);
    [button6 setTitle:@"确定" forState:UIControlStateNormal];
    button6.titleLabel.font = [UIFont systemFontOfSize: 30];
    [button6 addTarget:self action:@selector(queding:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button6];
    
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
- (IBAction)qianbackshouye:(id)sender {    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"shouye"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}


- (IBAction)queding:(id)sender {
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        qianshoudanquzhi = quedingsignid.text;
        
        //qianshoudanquzhi=@"3604396";
        [self link];
    }
}

-(void)link
{
    //[networkcheckViewController network];
    
    //列表之前先链接服务器拿数据；
    // 设置我们之后解析XML时用的关键字，与响应报文中Body标签之间的getMobileCodeInfoResult标签对应
    matchingElement = @"getMobileCodeInfoResult";
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
    
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soapenv:Envelope "
                         "xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
                         "xmlns:sig=\"http://signfor.czl.com/\">"
                         "<soapenv:Header/>"
                         "<soapenv:Body>"
                         "<sig:getJsonSignfor>"
                         //<!--Optional:-->
                         "<arg0>%@</arg0>"
                         "</sig:getJsonSignfor>"
                         "</soapenv:Body>"
                         //"</soapenv:Envelope>",@"3604396"];
                         "</soapenv:Envelope>",qianshoudanquzhi];
    
    
    // 将这个XML字符串打印出来
    NSLog(@"%@", soapMsg);
    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
    NSURL *url = [NSURL URLWithString: [linkViewController signviewcontroller]];//@"http://125.88.8.30:8887/AndroidWebservice/SingforBAPort"
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
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
        NSLog(@"HELLO");
    }
    
}

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response{
    [webData setLength: 0];
    NSLog(@"connection didReceiveResponse");
}

// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    //[webData appendData:data];
    NSLog(@"connection didReceiveData");
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", str);//得到想要的XML字符串然后解析
    //_textview.text=str;
    theXML1 = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    theXML1 = str;
}

// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    conn = nil;
    webData = nil;
    NSLog(@"connection didFailWithError");
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    // NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
    //    length:[webData length]
    // encoding:NSUTF8StringEncoding];
    
    // 打印出得到的XML
    NSLog(@"%@", theXML1);
    // 使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    NSLog(@"connectionDidFinishLoading");
    [self jiexi];
}

-(void)jiexi

{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:theXML1 options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
    //NSString *gen = [ rootElement stringValue];
    //NSLog(gen);
    //GDataXMLElement *users = [rootElement elementsForName:@"S:Envelope"];
    GDataXMLElement *third = [[rootElement elementsForName:@"S:Body"]objectAtIndex:0];
    //NSString *gen2 = [ third stringValue];
    //  NSLog(gen2);
    // NSLog(@"1");
    
    GDataXMLElement *forth = [[third elementsForName:@"ns2:getJsonSignforResponse"]objectAtIndex:0];
    //NSString *gen3 = [ forth stringValue];
    //NSLog(gen3);
    // NSLog(@"qian");
    
    //for (GDataXMLElement *user in forth)
    //{
    //User节点的id属性
    GDataXMLElement *name = [[forth elementsForName:@"return"] objectAtIndex:0];
    a=[name stringValue];
    
    
    
    NSLog(@"username%@",a);
    //NSLog(@"print");
    
    if (a!=NULL) {
        
        [self chaxuntanchukuang];
    }
    
    else
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有查询到数据，请检查签收单id是否正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alter show];
    }
    
    
}

-(void)chaxuntanchukuang
{
    UIViewController *childVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"queding"];
    childVC.hidesBottomBarWhenPushed = YES;
    [self presentViewController:childVC animated:YES completion:nil];
}

+(NSString *)chaxunchuanzhi
{
    return a;//传那串字符串用于列表显示
}


+(NSString *)chuanqianshoudan
{
    return qianshoudanquzhi;//用于传输签收单号
}



- (IBAction)scan:(id)sender {
    if ([[networkcheckViewController network] isEqualToString:@"yes"])
    {
        ZBarReaderViewController * reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        ZBarImageScanner * scanner = reader.scanner;
        [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
        
        reader.showsZBarControls = YES;
        
        [self presentViewController:reader animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    //_imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    qianshoudanquzhi = symbol.data;
    [self link];
}

+(void)signchushihua///////////+++++++++++++++++++++++++
{
    chushihua=1;
}


+(int)returnchushihua
{
    return chushihua;
}



@end
